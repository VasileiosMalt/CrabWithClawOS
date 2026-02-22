#!/bin/bash
# OpenClawOS Corrective Script — Full Edition
# Run with: sed -i 's/\r//g' fix-openclawos.sh && sudo bash fix-openclawos.sh

set -euo pipefail
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
log_info()    { echo -e "\n${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }

REALUSER="${SUDO_USER:-$(logname 2>/dev/null || echo openclawos)}"
REALHOME="/home/${REALUSER}"

echo -e "\n${GREEN}════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  OpenClawOS Corrective Script — starting${NC}"
echo -e "${GREEN}  Running as root on behalf of: ${REALUSER}${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════${NC}\n"

###############################################################################
# SECTION 0 — Fix Debian Bookworm NO_PUBKEY errors
###############################################################################
log_info "0/10 — Fixing Debian Bookworm archive keys"

apt-get install --reinstall -y debian-archive-keyring 2>/dev/null || true

MISSING_KEYS=$(apt-get update 2>&1 | grep "NO_PUBKEY" | awk '{print $NF}' | sort -u)
if [ -n "${MISSING_KEYS}" ]; then
  for KEY in ${MISSING_KEYS}; do
    log_warning "Fetching missing key: ${KEY}"
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys "${KEY}" 2>/dev/null || true
    gpg --export "${KEY}" | apt-key add - 2>/dev/null || true
    gpg --keyserver hkps://keys.openpgp.org --recv-keys "${KEY}" 2>/dev/null || true
    gpg --export "${KEY}" | apt-key add - 2>/dev/null || true
  done
fi

apt-get update -qq 2>/dev/null || true
log_success "Bookworm archive keys fixed"

###############################################################################
# SECTION 1 — Fix Tailscale GPG key + sources
###############################################################################
log_info "1/10 — Fixing Tailscale GPG key"

rm -f /usr/share/keyrings/tailscale-archive-keyring.gpg
rm -f /etc/apt/trusted.gpg.d/tailscale*.gpg
rm -f /etc/apt/trusted.gpg.d/tailscale*.asc
rm -f /etc/apt/sources.list.d/tailscale.list
apt-key del $(apt-key list 2>/dev/null | grep -B1 -i tailscale | grep pub \
  | awk '{print $2}' | cut -d/ -f2) 2>/dev/null || true

mkdir -p /usr/share/keyrings
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg \
  -o /usr/share/keyrings/tailscale-archive-keyring.gpg

cat > /etc/apt/sources.list.d/tailscale.list << 'EOF'
deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/debian bookworm main
EOF

apt-get update -qq 2>/dev/null || true
apt-get install -y tailscale 2>/dev/null || true
systemctl enable --now tailscaled 2>/dev/null || true
log_success "Tailscale key reset done — run: tailscale up --authkey=<your-key>"

###############################################################################
# SECTION 2 — Fix Brave GPG key + sources
###############################################################################
log_info "2/10 — Fixing Brave GPG key"

rm -f /usr/share/keyrings/brave-browser-archive-keyring.gpg
rm -f /etc/apt/trusted.gpg.d/brave*.gpg
rm -f /etc/apt/trusted.gpg.d/brave*.asc
rm -f /etc/apt/sources.list.d/brave-browser.list

curl -fsSL \
  https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg \
  -o /usr/share/keyrings/brave-browser-archive-keyring.gpg

cat > /etc/apt/sources.list.d/brave-browser.list << 'EOF'
deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main
EOF

apt-get update -qq 2>/dev/null || true
apt-get install -y brave-browser 2>/dev/null || true
log_success "Brave key reset done"

###############################################################################
# SECTION 3 — Fix Opera GPG key + sources
###############################################################################
log_info "3/10 — Fixing Opera GPG key"

rm -f /usr/share/keyrings/opera.gpg
rm -f /etc/apt/trusted.gpg.d/opera*.gpg
rm -f /etc/apt/trusted.gpg.d/opera*.asc
rm -f /etc/apt/sources.list.d/opera-stable.list

curl -fsSL https://deb.opera.com/archive.key \
  | gpg --dearmor -o /usr/share/keyrings/opera.gpg

cat > /etc/apt/sources.list.d/opera-stable.list << 'EOF'
deb [signed-by=/usr/share/keyrings/opera.gpg] https://deb.opera.com/opera-stable/ stable non-free
EOF

apt-get update -qq 2>/dev/null || true
apt-get install -y opera-stable 2>/dev/null || true
log_success "Opera key reset done"

###############################################################################
# SECTION 4 — Set desktop wallpaper (XFCE)
###############################################################################
log_info "4/10 — Setting desktop wallpaper"

WALLPAPER="/usr/share/backgrounds/openclawos/OpenClawOS.png"

if [ -f "${WALLPAPER}" ]; then
  mkdir -p /etc/xdg/xfce4/xfconf/xfce-perchannel-xml

  cat > /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml << XMLEOF
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="workspace0" type="empty">
          <property name="last-image" type="string" value="${WALLPAPER}"/>
          <property name="image-style" type="int" value="5"/>
          <property name="color-style" type="int" value="0"/>
        </property>
      </property>
    </property>
  </property>
</channel>
XMLEOF

  # Apply live if a desktop session is running
  sudo -u "${REALUSER}" bash -c "
    export DISPLAY=\${DISPLAY:-:0}
    export DBUS_SESSION_BUS_ADDRESS=\${DBUS_SESSION_BUS_ADDRESS:-unix:path=/run/user/\$(id -u ${REALUSER})/bus}
    for p in \$(xfconf-query -c xfce4-desktop -l 2>/dev/null | grep last-image); do
      xfconf-query -c xfce4-desktop -p \"\$p\" -s \"${WALLPAPER}\" 2>/dev/null || true
    done
    for p in \$(xfconf-query -c xfce4-desktop -l 2>/dev/null | grep image-style); do
      xfconf-query -c xfce4-desktop -p \"\$p\" -s 5 2>/dev/null || true
    done
  " 2>/dev/null || true

  # Also set for lightdm greeter background
  if [ -f /etc/lightdm/lightdm-gtk-greeter.conf ]; then
    sed -i "s|^#*background=.*|background=${WALLPAPER}|" \
      /etc/lightdm/lightdm-gtk-greeter.conf 2>/dev/null || true
  fi

  log_success "Wallpaper set: ${WALLPAPER} (re-login if not visible)"
else
  log_warning "Wallpaper not found at ${WALLPAPER} — skipping"
fi

###############################################################################
# SECTION 5 — Antigravity repo + package
###############################################################################
log_info "5/10 — Installing Antigravity"

mkdir -p /etc/apt/keyrings
curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg \
  | gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg

cat > /etc/apt/sources.list.d/antigravity.list << 'EOF'
deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main
EOF

apt-get update -qq 2>/dev/null || true
apt-get install -y antigravity 2>/dev/null \
  || log_warning "antigravity not yet available — repo saved for future use"
log_success "Antigravity configured"

###############################################################################
# SECTION 6 — BrowserOS v0.40.1
###############################################################################
log_info "6/10 — Installing BrowserOS v0.40.1"

BROWSEROS_DEB="/tmp/BrowserOS_v0.40.1_amd64.deb"
curl -fsSL --connect-timeout 30 --max-time 180 \
  "https://github.com/browseros-ai/BrowserOS/releases/download/v0.40.1/BrowserOS_v0.40.1_amd64.deb" \
  -o "${BROWSEROS_DEB}" || true

if [ -f "${BROWSEROS_DEB}" ] && [ -s "${BROWSEROS_DEB}" ]; then
  dpkg -i "${BROWSEROS_DEB}" 2>/dev/null || apt-get install -fy 2>/dev/null || true
  log_success "BrowserOS installed"
else
  log_warning "BrowserOS download failed — check internet and retry manually:
  curl -fsSL https://github.com/browseros-ai/BrowserOS/releases/download/v0.40.1/BrowserOS_v0.40.1_amd64.deb -o /tmp/browseros.deb && dpkg -i /tmp/browseros.deb"
fi

###############################################################################
# SECTION 7 — Node.js + npm AI tools (timeout-guarded, non-blocking)
###############################################################################
log_info "7/10 — Node.js + npm AI tools"

# Keep existing nodesource channel (node 23.x as installed in live OS)
# Just ensure nodejs is at latest for the configured channel
apt-get install -y nodejs 2>/dev/null || true
log_info "Node: $(node --version 2>/dev/null || echo unknown)  npm: $(npm --version 2>/dev/null || echo unknown)"

# Silence npm noise
npm config set fund false           2>/dev/null || true
npm config set update-notifier false 2>/dev/null || true
npm config set yes true             2>/dev/null || true
npm config set loglevel error       2>/dev/null || true

npm_install() {
  local PKG="$1"
  log_info "npm install -g ${PKG}"
  timeout 120 npm install -g --prefer-offline "${PKG}" 2>/dev/null && \
    log_success "${PKG} installed" || \
  timeout 120 npm install -g "${PKG}" 2>/dev/null && \
    log_success "${PKG} installed" || \
    log_warning "Skipped (timeout/unavailable): ${PKG}"
  return 0
}

npm_install "@anthropic-ai/claude-code"
npm_install "@google/gemini-cli"
npm_install "@openai/codex"
npm_install "openclaw"
npm_install "@modelcontextprotocol/sdk"
npm_install "@sourcegraph/amp"
npm_install "vercel"
npm_install "netlify-cli"
npm_install "promptfoo"

log_success "npm tools done"

###############################################################################
# SECTION 8 — Full system upgrade + dependency fix
###############################################################################
log_info "8/10 — Full system upgrade"

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -f -y
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y \
  -o Dpkg::Options::="--force-confold" \
  -o Dpkg::Options::="--force-confdef"
apt-get autoremove -y
apt-get autoclean
log_success "System upgraded"

###############################################################################
# SECTION 9 — LiteLLM Python dependencies
###############################################################################
log_info "9/10 — LiteLLM Python deps"

# Allow pip to install into system Python on Debian 12
cat > /etc/pip.conf << 'PIPEOF'
[global]
break-system-packages = true
disable-pip-version-check = true
PIPEOF

pip3 install --break-system-packages --upgrade --quiet \
  litellm \
  backoff \
  openai \
  anthropic \
  httpx \
  tiktoken \
  pydantic \
  anyio \
  tenacity \
  aiohttp \
  python-dotenv \
  2>/dev/null || true

# Inject into pipx litellm environment if it exists
if command -v pipx >/dev/null 2>&1; then
  sudo -u "${REALUSER}" \
    pipx inject litellm backoff openai anthropic httpx tiktoken \
    2>/dev/null || true
fi

# Add one-time auto-check to .zshrc and .bashrc
LITELLM_LINE='# LiteLLM deps (OpenClawOS)\ncommand -v litellm >/dev/null 2>&1 || pip3 install litellm backoff openai anthropic httpx tiktoken --break-system-packages -q 2>/dev/null'
for RC in "${REALHOME}/.zshrc" "${REALHOME}/.bashrc"; do
  if [ -f "${RC}" ] && ! grep -q "LiteLLM deps (OpenClawOS)" "${RC}"; then
    printf "\n%b\n" "${LITELLM_LINE}" >> "${RC}"
  fi
done

log_success "LiteLLM Python deps done"

###############################################################################
# SECTION 10 — Command reference on Desktop
###############################################################################
log_info "10/10 — Writing command reference to Desktop"

DESKTOP_DIR="${REALHOME}/Desktop"
mkdir -p "${DESKTOP_DIR}"

cat > "${DESKTOP_DIR}/OpenClawOS_Commands.txt" << 'CMDEOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║              OpenClawOS AI Edition — Command Reference                     ║
╚══════════════════════════════════════════════════════════════════════════════╝

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🤖  LLM & AI AGENT TOOLS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
claude                  → Claude Code AI agent (Anthropic)
gemini                  → Gemini CLI (Google)
codex                   → OpenAI Codex CLI
aider                   → Aider AI pair programming
sgpt                    → ShellGPT — ChatGPT in the shell
tgpt                    → Terminal GPT (no API key needed)
llm                     → Simon Willison's LLM CLI
fabric                  → Fabric AI prompt pipeline tool
openclaw                → OpenClaw orchestration agent
amp                     → Sourcegraph Amp AI agent

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🦙  LOCAL LLM (OLLAMA)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ollama serve            → Start Ollama server (localhost:11434)
ollama run llama3.2     → Run Llama 3.2 locally
ollama run gemma3       → Run Gemma 3 locally
ollama run mistral      → Run Mistral locally
ollama run deepseek-r1  → Run DeepSeek R1 locally
ollama list             → List downloaded models
ollama pull <model>     → Download a model

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔀  AI PROXY & ROUTING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
litellm --config /etc/openclawos/litellm_config.yaml --port 4000
                        → Start LiteLLM proxy (localhost:4000)
sudo systemctl start litellm    → Start as service
sudo systemctl status litellm   → Check LiteLLM status
sudo systemctl start ollama     → Start Ollama service

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌐  WEB BROWSERS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
brave-browser           → Brave Browser (privacy-focused)
opera                   → Opera Browser (built-in VPN)
firefox-esr             → Firefox ESR
browseros               → BrowserOS AI Browser

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📄  OFFICE & DOCUMENTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
libreoffice             → LibreOffice Suite launcher
libreoffice --writer    → Word processor (DOCX/ODT)
libreoffice --calc      → Spreadsheet (XLSX/ODS)
libreoffice --impress   → Presentations (PPTX/ODP)
libreoffice --draw      → Vector drawing
xournalpp               → PDF annotation & handwriting
pdfarranger             → PDF merge/split/reorder
evince                  → PDF/document viewer
pdftoppm                → Convert PDF to images
pdfinfo                 → PDF metadata info

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🖼️  IMAGE & MEDIA TOOLS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ristretto               → Image viewer (XFCE)
convert / imagemagick   → Convert/edit images (CLI)
gm / graphicsmagick     → Graphics processing (CLI)
ffmpeg                  → Video/audio convert & process
vlc                     → VLC Media Player
sox                     → Audio processing CLI
v4l2-ctl                → Webcam/video4linux control

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💻  DEVELOPMENT TOOLS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
nvim                    → Neovim editor
hx / helix              → Helix modal editor
node                    → Node.js runtime
npm / pnpm / bun        → JS package managers
python3                 → Python 3.11
pip3 / pipx / uv / uvx  → Python package tools
go                      → Go runtime
cargo / rustc           → Rust toolchain
docker                  → Docker CLI
docker compose          → Docker Compose
podman / buildah        → Rootless containers
distrobox               → Run other Linux distros in terminal
mise                    → Runtime version manager

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔧  DEVOPS & CLOUD
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
lazygit / lg            → Terminal Git UI
lazydocker / lzd        → Terminal Docker UI
k9s                     → Kubernetes TUI
kubectl                 → Kubernetes CLI
helm                    → Helm chart manager
gh                      → GitHub CLI
vercel                  → Vercel deploy CLI
netlify                 → Netlify deploy CLI
snyk                    → Security vulnerability scanner
yq                      → YAML processor (like jq)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🛡️  NETWORKING & SECURITY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
tailscale up            → Connect to Tailscale VPN
tailscale status        → Show VPN peers
tailscale ip            → Show your Tailscale IP
tailscale down          → Disconnect VPN
firejail <app>          → Sandbox any application
mosh                    → Mobile shell (SSH on bad networks)
ssh                     → Secure Shell client

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊  SYSTEM MONITORING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
openclawos-info         → OpenClawOS system + AI status
btop                    → Beautiful resource monitor
htop                    → Classic process viewer
iotop                   → Disk I/O monitor
sensors                 → CPU/GPU temperatures
smartctl -a /dev/sda    → Disk health (SMART)
dmidecode               → Hardware info dump

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🗂️  FILE & SHELL TOOLS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
yazi                    → Terminal file manager
eza / ll / la           → Modern ls with icons
bat                     → Syntax-highlighted cat
fzf                     → Fuzzy finder
rg / ripgrep            → Fast file content search
fd                      → Fast file finder
z / zoxide              → Smart cd (learns your paths)
delta                   → Beautiful git diffs
watchexec               → Re-run on file change
just                    → Modern make alternative
zellij                  → Terminal multiplexer
tmux                    → Classic terminal multiplexer
jq                      → JSON processor

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📦  PACKAGE MANAGEMENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
sudo apt update && sudo apt upgrade
                        → Full system upgrade
sudo apt install <pkg>  → Install apt package
gdebi <file.deb>        → Install local .deb with deps
synaptic                → GUI package manager
pip3 install <pkg>      → Python package (system)
pipx install <pkg>      → Python CLI tool (isolated)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚙️  SHELL ALIASES (built-in)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
update                  → sudo apt update && sudo apt upgrade -y
install <pkg>           → sudo apt install <pkg>
myip                    → curl ifconfig.me
sysinfo                 → openclawos-info
g / gs / gl             → git / git status / git log graph
d / dc                  → docker / docker compose
ll / la                 → eza with icons
lg / lzd                → lazygit / lazydocker
CMDEOF

chown "${REALUSER}:${REALUSER}" "${DESKTOP_DIR}/OpenClawOS_Commands.txt"
log_success "Command reference saved to ~/Desktop/OpenClawOS_Commands.txt"

###############################################################################
# DONE
###############################################################################
echo ""
echo -e "${GREEN}════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  OpenClawOS corrective script COMPLETE${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════${NC}"
echo ""
echo "  Next steps:"
echo "  1. tailscale up --authkey=<your-key>   → connect Tailscale VPN"
echo "  2. Log out and back in                 → wallpaper takes effect"
echo "  3. ~/Desktop/OpenClawOS_Commands.txt   → all available commands"
echo "  4. sudo systemctl start ollama         → start local AI"
echo ""
