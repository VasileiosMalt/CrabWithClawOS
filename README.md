# 🦀 CrabWithClawOS v2 — Complete Debian-Based Distribution Blueprint

A custom **Debian Bookworm**-based Linux distribution engineered for AI CLI coding agents, terminal-based development workflows, free LLM provider orchestration, and multimedia CLI tools.

***

## 1. System Requirements & Disk Space

### Hardware Requirements

CrabWithClawOS targets AI-focused workloads, so requirements exceed standard Debian minimums.[^1][^2]

| Tier | CPU | RAM | Storage | GPU | Use Case |
|------|-----|-----|---------|-----|----------|
| **Minimum** | 4-core 2.0 GHz (x86_64) | 8 GB | 60 GB SSD | None (CPU-only inference) | API-only AI tools, light Ollama models |
| **Recommended** | 8-core 3.0 GHz+ | 16 GB | 120 GB NVMe SSD | NVIDIA RTX 3060 (8 GB VRAM) | Full AI stack + local 7B models |
| **Optimal** | 12+ core (AMD Ryzen 9 / Intel i7+) | 32 GB+ | 256 GB+ NVMe SSD | NVIDIA RTX 4070+ (12 GB+ VRAM) | Multiple concurrent agents + local 70B models |

### Disk Space Breakdown

| Component | Space Required |
|-----------|---------------|
| Debian base system + kernel + firmware | ~4 GB [^2] |
| Desktop environment (Hyprland/Sway + Waybar) | ~1 GB |
| Terminal stack (Ghostty, Kitty, Zellij, tmux, Zsh, Neovim) | ~500 MB |
| All AI CLI tools (Claude Code, Aider, OpenCode, Gemini CLI, etc.) | ~3 GB |
| Node.js + Python + Rust + Go + Bun runtimes | ~4 GB |
| Docker + Podman + container images | ~5 GB |
| Brave Browser + extensions | ~1 GB |
| Ollama + 1 small model (3B) | ~5 GB |
| Ollama + 1 medium model (7B–13B) | ~10–15 GB |
| CLI media tools (FFmpeg, SoX, ImageMagick, Whisper) | ~2 GB |
| Claude Code skills + CLAUDE.md configs | ~100 MB |
| Monitoring tools (btop, nvtop, crab-monitor) | ~50 MB |
| System overhead + logs + swap space | ~4 GB |
| **TOTAL (Minimum Install, no local LLMs)** | **~25 GB** |
| **TOTAL (Recommended, with one 7B model)** | **~50 GB** |
| **TOTAL (Full Install, multiple models + Docker)** | **~80–120 GB** |

### ISO Image Size
- **Live ISO (full desktop):** ~4.5–5 GB
- **Netinstall ISO (minimal, downloads packages):** ~1.5 GB

***

## 2. Build System: Debian `live-build`

CrabWithClawOS is built using Debian's official `live-build` toolchain instead of archiso:[^3][^4][^5]

```bash
sudo apt install live-build debootstrap squashfs-tools xorriso grub-efi-amd64-bin
mkdir -p crabwithclawos && cd crabwithclawos

lb config -d bookworm \
  --debian-installer live \
  --debian-installer-distribution bookworm \
  --archive-areas "main contrib non-free non-free-firmware" \
  --debootstrap-options "--variant=minbase" \
  --bootappend-live "boot=live components username=crab"
```

Package lists go in `config/package-lists/*.list.chroot`, dotfiles and configs in `config/includes.chroot_after_packages/etc/skel/`, and post-install scripts in `config/hooks/`.[^4][^3]

### Installer
- **Calamares** — GUI installer branded for CrabWithClawOS (crab+claw logo, slideshow explaining the AI tool stack)[^6]
- **First-boot wizard**: Select GPU vendor → install appropriate drivers → select AI tool preset (Minimal / Full / Local-only) → configure API keys via encrypted keyring

***

## 3. Complete AI CLI Tool Stack

### Tier 1 — Core AI Coding Agents (Pre-installed)

| Tool | License | Key Strength | Install |
|------|---------|-------------|---------|
| **Claude Code** | Proprietary | Best autonomous agent, MCP, skills, context compaction | `npm i -g @anthropic-ai/claude-code` [^7][^8] |
| **Gemini CLI** | Free | 1M token context, free tier (1000 req/day), huge monorepo | `npm i -g @google/gemini-cli` [^7] |
| **Aider** | Apache 2.0 | 100+ model support, deepest git integration, 39K+ stars | `pipx install aider-chat` [^7] |
| **OpenCode** | Open Source | LSP integration, 75+ providers, multi-session, 95K+ stars | `curl -fsSL https://opencode.ai/install \| bash` [^9][^10] |
| **OpenAI Codex CLI** | Open Source | Rust-based, 3-tier permissions, ChatGPT integration | `npm i -g @openai/codex` [^7] |
| **OpenClaw** | Open Source | Routes Claude + Gemini, gateway architecture, TUI + Web | `curl -fsSL https://openclaw.ai/install.sh \| bash` [^11][^12] |
| **Amp (Sourcegraph)** | Freemium | Sub-agent orchestration, deep reasoning mode | `npm i -g @sourcegraph/amp` [^13] |

### Tier 2 — Additional AI Agents (via `crab-install`)

| Tool | Purpose |
|------|---------|
| **Goose (Block)** | Autonomous task agent, MCP-native, Ollama support [^14][^15] |
| **Kilo Code CLI** | Plan-act-observe-fix loop, 400+ models, audit logging [^16][^17] |
| **Cline** | Autonomous coding agent, 48K+ stars, executes commands [^18] |
| **GitHub Copilot CLI** | GitHub-native shell completions [^19] |
| **ForgeCode** | In-terminal pair programmer [^18] |

### Tier 3 — MCP & Local Inference

| Tool | Purpose |
|------|---------|
| **MCP Tools CLI** | Discover, call, manage MCP servers from terminal [^20] |
| **Ollama** | Local LLM server (llama3, codellama, deepseek-coder) [^21][^22] |
| **Open WebUI** | Browser UI for Ollama models |
| **LiteLLM Proxy** | Unified API proxy for 100+ LLM providers |

***

## 4. Free LLM Provider Integration

All tools listed above support OpenAI-compatible APIs, meaning they work with every free provider listed below via LiteLLM or direct configuration. CrabWithClawOS ships with a pre-configured `crab-keys` system and LiteLLM proxy config for all of these:

### Free Providers — Pre-configured in CrabWithClawOS

| Provider | Free Tier Limits | Key Models | API Key URL |
|----------|-----------------|------------|-------------|
| **OpenRouter** | 20 req/min, 1000 req/day (with $10 topup) | DeepSeek R1, Llama 3.3 70B, Qwen3, Gemma 3, 50+ free models | `https://openrouter.ai/keys`  |
| **Google AI Studio** | 250 req/day (Flash), 100 req/day (Pro) | Gemini 2.5 Pro, 2.5 Flash, 2.0 Flash, Gemma 3 | `https://aistudio.google.com/apikey`  |
| **NVIDIA NIM** | 40 req/min | Various open models | `https://build.nvidia.com/`  |
| **Mistral (La Plateforme)** | 1 req/sec, 500K tokens/min, 1B tokens/month | Mistral Small, Medium, Large, Codestral | `https://console.mistral.ai/api-keys`  |
| **Mistral (Codestral)** | 30 req/min, 2000 req/day | Codestral (code-specific) | `https://console.mistral.ai/codestral`  |
| **HuggingFace Inference** | $0.10/month credits | Various open models <10GB | `https://huggingface.co/settings/tokens`  |
| **Vercel AI Gateway** | $5/month free credits | Routes to multiple providers | `https://vercel.com/dashboard`  |
| **Cerebras** | 30 req/min, 14.4K req/day (8K context) | Qwen 3 32B, Llama 4 Scout, Llama 3.3 70B | `https://cloud.cerebras.ai/`  |
| **Groq** | 1K–14.4K req/day per model | Llama 3.3 70B, DeepSeek R1, Gemma 2 9B, Whisper | `https://console.groq.com/keys`  |
| **Cohere** | 20 req/min, 1000 req/month | Command-A, Command-R+, Aya Expanse/Vision | `https://dashboard.cohere.com/api-keys`  |
| **GitHub Models** | Per Copilot tier | GPT-4.1, o3, o4-mini, Llama 4, DeepSeek R1, 50+ models | `https://github.com/settings/tokens`  |
| **Cloudflare Workers AI** | 10,000 neurons/day | Llama 4 Scout, Qwen QwQ, Gemma 3, DeepSeek R1 | `https://dash.cloudflare.com/`  |
| **Together (Free)** | 60 req/min | Llama 3.3 70B, DeepSeek R1 Distil | `https://api.together.xyz/settings/api-keys`  |
| **Chutes** | 200 req/day ($5 one-time topup) | Various open models | `https://chutes.ai/`  |

### Trial Credit Providers (also pre-configured)

| Provider | Credits | Key Models |
|----------|---------|------------|
| **Baseten** | $30 | Any model, pay by compute  |
| **SambaNova** | $5/3 months | DeepSeek R1, Llama 3.3, Qwen3 32B  |
| **Nebius** | $1 | Various open models  |
| **Hyperbolic** | $1 | DeepSeek V3, Llama 3.1 405B, Qwen2.5  |
| **NLP Cloud** | $15 | Various open models  |
| **AI21** | $10/3 months | Jamba family  |
| **Scaleway** | 1M free tokens | Llama 3.3, Mistral Small, Gemma 3, devstral  |

### Which AI tools work with which free providers?

| AI Tool | Supports Free Providers Via |
|---------|---------------------------|
| **Aider** | Native support for 100+ providers including all listed above via `--model` flag [^7] |
| **OpenCode** | 75+ providers natively, OpenAI-compatible endpoints [^9][^10] |
| **Gemini CLI** | Google AI Studio directly (free tier) [^7] |
| **Claude Code** | Anthropic API (paid), but can route via OpenRouter free models for non-Claude tasks |
| **Goose** | Ollama locally + any OpenAI-compatible endpoint [^15] |
| **Kilo Code** | 400+ models, all OpenAI-compatible providers [^16] |
| **OpenClaw** | Routes between Claude + Gemini natively [^11] |
| **LiteLLM Proxy** | ALL of the above — unified gateway, pre-configured for every free provider |

### LiteLLM Configuration (Pre-installed)

```yaml
# /etc/crabwithclawos/litellm_config.yaml
model_list:
  - model_name: "free/deepseek-r1"
    litellm_params:
      model: "openrouter/deepseek/deepseek-r1-0528:free"
      api_key: "os.environ/OPENROUTER_API_KEY"
  - model_name: "free/gemini-flash"
    litellm_params:
      model: "gemini/gemini-2.0-flash"
      api_key: "os.environ/GOOGLE_API_KEY"
  - model_name: "free/llama-70b-groq"
    litellm_params:
      model: "groq/llama-3.3-70b"
      api_key: "os.environ/GROQ_API_KEY"
  - model_name: "free/qwen3-cerebras"
    litellm_params:
      model: "cerebras/qwen-3-32b"
      api_key: "os.environ/CEREBRAS_API_KEY"
  - model_name: "free/command-a"
    litellm_params:
      model: "cohere/command-a"
      api_key: "os.environ/COHERE_API_KEY"
  # ... 20+ more free model routes
```

***

## 5. Pre-installed Claude Code Skills & CLAUDE.md

Claude Code skills are markdown files stored in `~/.claude/skills/` that extend Claude's capabilities. CrabWithClawOS ships with a curated selection pre-installed:[^23][^24][^25]

### Official Anthropic Skills (Pre-installed)

| Skill | What It Does |
|-------|-------------|
| `anthropics/docx` | Create, edit, and analyze Word documents [^26] |
| `anthropics/xlsx` | Create, edit, and analyze Excel spreadsheets [^26] |
| `anthropics/pdf` | Extract text, create PDFs, handle forms [^26] |
| `anthropics/pptx` | Create and edit PowerPoint presentations [^26] |
| `anthropics/doc-coauthoring` | Collaborative document editing [^26] |
| `anthropics/mcp-builder` | Create MCP servers to integrate external APIs [^26] |
| `anthropics/webapp-testing` | Test web apps using Playwright [^26] |
| `anthropics/frontend-design` | Frontend design and UI/UX development [^26] |
| `anthropics/canvas-design` | Design visual art in PNG/PDF [^26] |
| `anthropics/algorithmic-art` | Generative art using p5.js [^26] |
| `anthropics/skill-creator` | Meta-skill: guide for creating new skills [^26] |

### Community Skills (Pre-installed — Curated Best)

| Skill | Category | Purpose |
|-------|----------|---------|
| `obra/test-driven-development` | Development | Write tests before implementing code [^26] |
| `obra/systematic-debugging` | Development | Methodical problem-solving in code [^26] |
| `obra/root-cause-tracing` | Development | Investigate fundamental problems [^26] |
| `obra/subagent-driven-development` | Development | Multi-sub-agent development workflow [^26] |
| `obra/dispatching-parallel-agents` | Productivity | Coordinate multiple simultaneous agents [^26] |
| `obra/verification-before-completion` | Development | Validate work before finalizing [^26] |
| `obra/brainstorming` | Productivity | Generate and explore ideas [^26] |
| `obra/writing-plans` | Productivity | Create strategic documentation [^26] |
| `obra/executing-plans` | Productivity | Implement strategic plans [^26] |
| `obra/finishing-a-development-branch` | Git | Complete Git code branches [^26] |
| `obra/requesting-code-review` | Git | Initiate code review processes [^26] |
| `obra/receiving-code-review` | Git | Process and incorporate feedback [^26] |
| `obra/using-git-worktrees` | Git | Manage multiple Git working trees [^26] |
| `fvadicamo/dev-agent-skills` | Git/GitHub | git-commit, PR creation, merge, review [^26] |
| `alinaqi/claude-bootstrap` | Project Init | Security-first guardrails, spec-driven todos [^26] |
| `zxkane/aws-skills` | Cloud | AWS infrastructure automation [^26] |
| `lackeyjb/playwright-skill` | Testing | Browser automation with Playwright [^26] |
| `sanjay3290/postgres` | Database | Safe read-only SQL against PostgreSQL [^26] |
| `scarletkc/vexor` | Search | Semantic file search with vector CLI [^26] |
| `SHADOWPR0/security-bluebook-builder` | Security | Build security Blue Books for sensitive apps [^26] |
| `obra/defense-in-depth` | Security | Multi-layered security approaches [^26] |
| `wrsmith108/varlock-claude-skill` | Security | Secure env variable management [^26] |
| `ComposioHQ/changelog-generator` | DevOps | Transform git commits into release notes [^26] |
| `K-Dense-AI/claude-scientific-skills` | Science | Scientific research and analysis [^26] |
| `czlonkowski/n8n-*` (7 skills) | Automation | Full n8n workflow automation suite [^26] |

### Context Engineering Skills (Pre-installed)

These advanced skills by muratcankoylan teach Claude how to handle context effectively:[^26]

- `context-fundamentals` — What context is and why it matters
- `context-degradation` — Recognize context failure patterns
- `context-compression` — Compression strategies for long sessions
- `context-optimization` — Compaction, masking, caching
- `multi-agent-patterns` — Orchestrator, peer-to-peer, hierarchical architectures
- `memory-systems` — Short-term, long-term, graph-based memory
- `tool-design` — Build tools agents can use effectively
- `evaluation` — Build evaluation frameworks for agent systems

### Global CLAUDE.md (Pre-configured)

CrabWithClawOS ships with a global `~/.claude/CLAUDE.md` optimized for the distro:

```markdown
# CrabWithClawOS Global Project Context

## Environment
- OS: CrabWithClawOS (Debian Bookworm-based)
- Shell: Zsh with Starship prompt
- Editor: Neovim (LazyVim config) or Helix
- Terminal: Ghostty/Kitty with Zellij multiplexer
- Package manager: apt + crab-install (AI tools)
- Container: Docker + Podman + Distrobox

## Conventions
- Use Conventional Commits for all git messages
- Always run tests before committing
- Use direnv for per-project environment variables
- API keys are managed via `crab-keys` — never hardcode
- Use `crab-sandbox` when running untrusted AI agent code
- Prefer local Ollama models for non-critical tasks to save API costs
- Use LiteLLM proxy (localhost:4000) for unified API access

## Available Tools
- All MCP servers accessible via `mcp-tools`
- Btrfs snapshots available: run `crab-snapshot` before risky operations
- AI monitoring: `crab-monitor` shows active agents, costs, GPU usage

## Coding Standards
- Python: ruff for linting, uv for package management
- JavaScript/TypeScript: ESLint + Prettier, pnpm preferred
- Rust: clippy + rustfmt
- All projects should have a .envrc for direnv
```

***

## 6. Browser: Brave with Leo AI + Predefined Bookmarks

### Why Brave

Brave is the most AI-integrated browser available for Linux:[^27][^28][^29]

- **Leo AI** — Built-in AI assistant in the sidebar, powered by multiple models (Llama, Mixtral, Claude)[^28][^30]
- **AI Browsing** — Autonomous agent mode that can browse, research, fill carts, compare products[^29]
- **Multi-Tab Context** — Leo understands content across multiple open tabs[^28]
- **Skills** — Create custom AI Skills like `/fact-check`, `/research-brief`[^29]
- **Vision** — Analyze images on webpages and in PDFs[^28]
- **Privacy-first** — No logging, conversations not stored, anonymous reverse-proxy[^31]
- **Cross-session memory** — AI remembers previous browsing sessions[^32]

### Pre-defined Bookmark Bar

CrabWithClawOS ships Brave with an organized bookmarks toolbar:

**📂 AI Hubs**
- ClawHub — `https://clawhub.io` (or relevant OpenClaw hub URL)
- Claude Hub — `https://claude.ai`
- ChatGPT — `https://chatgpt.com`
- Google AI Studio — `https://aistudio.google.com`
- Perplexity — `https://perplexity.ai`
- HuggingFace — `https://huggingface.co`

**📂 API Keys (Free Providers)**
- OpenRouter Keys — `https://openrouter.ai/keys`
- Google AI Studio Keys — `https://aistudio.google.com/apikey`
- NVIDIA NIM — `https://build.nvidia.com/`
- Mistral Console — `https://console.mistral.ai/api-keys`
- Mistral Codestral — `https://console.mistral.ai/codestral`
- HuggingFace Tokens — `https://huggingface.co/settings/tokens`
- Vercel Dashboard — `https://vercel.com/dashboard`
- Cerebras Cloud — `https://cloud.cerebras.ai/`
- Groq Console — `https://console.groq.com/keys`
- Cohere Dashboard — `https://dashboard.cohere.com/api-keys`
- GitHub Tokens — `https://github.com/settings/tokens`
- Together AI — `https://api.together.xyz/settings/api-keys`
- Cloudflare Workers — `https://dash.cloudflare.com/`
- Anthropic Console — `https://console.anthropic.com/settings/keys`
- OpenAI Platform — `https://platform.openai.com/api-keys`

**📂 API Keys (Trial Credits)**
- Baseten — `https://app.baseten.co/settings/api_keys`
- SambaNova — `https://cloud.sambanova.ai/apis`
- Nebius — `https://studio.nebius.com/`
- Hyperbolic — `https://app.hyperbolic.xyz/`
- NLP Cloud — `https://nlpcloud.com/home/token`
- AI21 — `https://studio.ai21.com/account/api-key`
- Scaleway — `https://console.scaleway.com/`
- Fireworks — `https://fireworks.ai/account/api-keys`

**📂 AI Dev Resources**
- Free LLM API Resources — `https://github.com/cheahjs/free-llm-api-resources`
- Awesome Claude Skills — `https://github.com/VoltAgent/awesome-claude-skills`
- Awesome CLAUDE.md — `https://github.com/josix/awesome-claude-md`
- MCP Servers — `https://github.com/modelcontextprotocol/servers`
- OpenCode Docs — `https://opencode.ai/docs/`
- Aider Docs — `https://aider.chat/docs/`
- Claude Code Docs — `https://code.claude.com/docs/en/`
- Ollama Models — `https://ollama.com/library`
- LiteLLM Docs — `https://docs.litellm.ai/`

**📂 CrabWithClawOS**
- CrabWithClawOS GitHub — `https://github.com/crabwithclawos` (project repo)
- CrabWithClawOS Docs — `https://crabwithclawos.dev/docs`
- CrabWithClawOS Issues — `https://github.com/crabwithclawos/issues`

### Alternative Browser: Zen Browser

Pre-installed as secondary option for users preferring maximum privacy:[^33][^34]
- Firefox-based, MPL 2.0 open source
- All telemetry completely stripped from core[^33]
- Vertical tabs, split view, workspace management[^34]
- No AI features (for users who want pure privacy without cloud AI)

***

## 7. CLI Media Tools

### Dictation / Speech-to-Text

| Tool | Description | Install |
|------|-------------|---------|
| **SoupaWhisper** | Local push-to-talk voice-to-text using faster-whisper. Hold F12 → speak → release → text typed into active window. ~250 line Python script, 100% local, no cloud [^35] | `pipx install soupawhisper` |
| **nerd-dictation** | Offline speech-to-text using VOSK-API. Single-file Python script, minimal deps, zero background overhead. Manual begin/end activation, configurable with Python string ops [^36][^37] | `pip install nerd-dictation` + VOSK model |

**Recommended primary**: SoupaWhisper (uses faster-whisper which is much faster than VOSK)[^35]
**Recommended fallback**: nerd-dictation (lighter, no GPU needed)[^37]

### Audio Editing (CLI)

| Tool | Description | Install |
|------|-------------|---------|
| **SoX (Sound eXchange)** | "Swiss Army knife of audio." Convert between 20+ formats, apply effects (echo, fade, chorus, normalize, reverse, trim), batch process entire folders. Chain effects: `sox in.wav out.mp3 trim 10 5 norm reverse` [^38][^39][^40] | `apt install sox libsox-fmt-all` |
| **FFmpeg** (audio mode) | Extract audio from video, convert formats, adjust bitrate/sample rate, mix channels. Example: `ffmpeg -i video.mp4 -vn -acodec libmp3lame audio.mp3` [^41] | `apt install ffmpeg` |

**Recommended primary**: SoX (purpose-built for audio)[^40]
**Recommended secondary**: FFmpeg (when working with audio extracted from video)[^41]

### Image Editing (CLI)

| Tool | Description | Install |
|------|-------------|---------|
| **ImageMagick 7** | Industry-standard CLI image manipulation. Resize, crop, color adjust, composite, annotate, format convert, batch process. Example: `magick input.jpg -resize 50% -blur 0x2 -quality 85 output.jpg` [^42][^43] | `apt install imagemagick` |
| **GraphicsMagick** | ImageMagick fork focused on stability and performance. Same syntax, faster for large batches. Better thread safety [^42][^43] | `apt install graphicsmagick` |

**Recommended primary**: ImageMagick 7 (wider format support, more filters)[^43]
**Recommended fallback**: GraphicsMagick (faster batch processing)[^42]

### Video Editing (CLI)

| Tool | Description | Install |
|------|-------------|---------|
| **FFmpeg** | The universal video tool. Cut/trim, merge, transcode, extract frames, add subtitles, stabilize, resize, adjust speed. Example: `ffmpeg -i in.mp4 -ss 00:01:00 -t 00:00:30 -c copy clip.mp4` [^41][^44][^45] | `apt install ffmpeg` |
| **MLT (melt)** | Command-line video editor from the Shotcut/Kdenlive ecosystem. Supports transitions, filters, multi-track compositing. Example: `melt clip1.mp4 -mix 25 -mixer luma clip2.mp4 -consumer avformat:output.mp4` | `apt install mlt-7` |

**Recommended primary**: FFmpeg (handles 99% of CLI video tasks)[^44][^41]
**Recommended secondary**: melt (when you need transitions/compositing without a GUI)

***

## 8. Terminal Environment Stack

### Terminal Emulator: Ghostty (Primary) + Kitty (Fallback)

- **Ghostty** — GPU-accelerated, clean interface, excellent multi-tab performance[^46]
- **Kitty** — Mature GPU-accelerated terminal, image protocol, built-in splits[^46]
- **WezTerm** — Lua-configurable Rust-based fallback[^46]

### Terminal Multiplexer: Zellij + tmux

- **Zellij** — Modern, self-documenting, plugin system, intuitive defaults[^47][^48]
- **tmux** — Pre-installed for compatibility[^48]

### Shell: Zsh + Starship

- **Zsh** with zsh-autosuggestions, zsh-syntax-highlighting, fzf integration[^49]
- **Starship** — Rust-compiled async prompt showing git, Python/Node versions, GPU status[^50]

### Editor Stack

| Editor | Role |
|--------|------|
| **Neovim** (LazyVim config) | Primary — LSP, Treesitter, Copilot, AI integrations |
| **Helix** | Secondary — built-in LSP, no config needed |
| **VS Code (code-oss)** | Optional — for extension-based AI tools |

***

## 9. Development Infrastructure

### Runtimes (Pre-installed)
- **Python 3.12+** with pip, pipx, uv (fast pip replacement)
- **Node.js 22 LTS** with npm, pnpm
- **Rust** via rustup
- **Go 1.22+**
- **Bun** — fast JS runtime used by OpenClaw[^11]

### Dev Tools
- **Git** + **lazygit** (TUI) + **delta** (syntax-highlighted diffs) + **gh** (GitHub CLI)[^51]
- **Docker** + **Docker Compose** + **lazydocker** (TUI)[^52]
- **Podman** + **Distrobox**
- **direnv** — auto-loads env vars per directory[^53]
- **mise** — runtime version manager (replaces nvm, pyenv, etc.)

### File Tools
- **yazi** (file manager), **fzf** (fuzzy finder), **ripgrep**, **fd**, **bat**, **eza**, **zoxide**, **jq/yq**, **tokei**

***

## 10. Kernel & OS-Level Optimizations

### Kernel: `linux-image-amd64` (Debian stock) + Custom `sysctl` tuning

Debian's stock kernel is used for stability, with AI-optimized sysctl settings:[^54][^55]

```ini
# /etc/sysctl.d/99-crabwithclawos.conf

# Memory — keep AI processes in RAM
vm.swappiness = 10
vm.vfs_cache_pressure = 50
vm.dirty_ratio = 40
vm.dirty_background_ratio = 10

# File system — AI tools watch many files
fs.inotify.max_user_watches = 524288
fs.file-max = 2097152
fs.aio-max-nr = 1048576

# Network — fast API connections
net.core.somaxconn = 65535
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_keepalive_time = 60
net.ipv4.tcp_keepalive_intvl = 10
net.core.netdev_max_backlog = 65536

# Scheduler
kernel.sched_autogroup_enabled = 0
```

### GPU Support
- **NVIDIA**: `nvidia-driver` + `nvidia-cuda-toolkit` from `non-free` repos, persistence mode[^54]
- **AMD**: `firmware-amd-graphics` + ROCm from AMD repos[^54]
- **Intel**: `intel-media-va-driver` + `intel-compute-runtime`

### Filesystem: Btrfs

```
# Subvolume layout
@           -> /
@home       -> /home
@models     -> /var/lib/ollama/models
@docker     -> /var/lib/docker
@snapshots  -> /.snapshots
```

Automated snapshots via **snapper** — hourly + pre/post apt hooks.[^56]

### cgroups v2 Resource Control

```ini
# /etc/systemd/system/ai-agents.slice
[Slice]
Description=AI Agent Resource Pool
MemoryMax=80%
CPUWeight=200
```

### Systemd Services

| Service | Purpose |
|---------|---------|
| `ollama.service` | Local LLM server, GPU-aware, memory-limited [^22] |
| `openclaw-gateway.service` | OpenClaw orchestrator, port 18789 [^12] |
| `litellm-proxy.service` | Unified LLM API proxy on localhost:4000 |
| `crab-monitor.service` | System + AI monitoring dashboard |
| `crab-snapshot.timer` | Automated Btrfs snapshots every 2 hours |

### Sandboxing
- **Firejail** for AI agents that execute arbitrary code[^57]
- **bubblewrap** for finer-grained sandboxing[^57]
- systemd `ProtectSystem=strict`, `PrivateTmp=yes`, `NoNewPrivileges=yes` on all AI services[^58]

***

## 11. Monitoring & Observability

| Tool | Purpose |
|------|---------|
| **btop** | CPU, RAM, Disk, Network monitoring with GPU support [^59][^60] |
| **nvtop** | GPU utilization, VRAM, temp, power (NVIDIA/AMD/Intel) [^61][^62] |
| **bandwhich** | Per-process network bandwidth |
| **systemd-cgtop** | Real-time cgroup resource consumption [^58] |

### `crab-monitor` TUI Dashboard
Custom dashboard aggregating per-tool token usage, API costs, GPU metrics, active agent sessions, model router health.

***

## 12. Desktop Environment

- **Hyprland** (Wayland) — dynamic tiling, per-monitor workspaces
- **Waybar** — status bar with GPU, active agents, API cost ticker
- **i3-gaps** (X11 fallback)

### Workspace Presets
```bash
crab-layout code      # Editor left, 2 AI agents right, monitor bottom
crab-layout research  # 4 AI agents in quadrants
crab-layout focus     # Single full-screen Zellij
crab-layout monitor   # btop + nvtop + crab-monitor + logs
```

***

## 13. Complete Package List (Debian)

### Core
```
linux-image-amd64 linux-headers-amd64 firmware-linux firmware-misc-nonfree
btrfs-progs snapper grub-efi-amd64 efibootmgr systemd-timesyncd
network-manager network-manager-gnome
```

### GPU
```
nvidia-driver nvidia-cuda-toolkit  # non-free
firmware-amd-graphics mesa-vulkan-drivers  # AMD
intel-compute-runtime intel-media-va-driver  # Intel
```

### Terminal
```
ghostty kitty wezterm zellij tmux zsh fish
```

### Dev Runtimes
```
python3 python3-pip python3-venv pipx
nodejs npm
golang-go
rustup (via installer)
```

### AI CLI Tools (via crab-install)
```
claude-code gemini-cli aider opencode codex-cli
openclaw amp goose kilo-code cline
ollama litellm mcp-tools open-webui
```

### Media CLI
```
ffmpeg sox libsox-fmt-all imagemagick graphicsmagick mlt-7
python3-faster-whisper nerd-dictation
```

### Development
```
git lazygit docker.io docker-compose podman distrobox
direnv neovim helix
```

### Monitoring
```
btop nvtop bandwhich
```

### File Tools
```
yazi fzf ripgrep fd-find bat eza zoxide jq
```

### Security
```
firejail bubblewrap gnome-keyring
```

### Desktop
```
hyprland waybar wofi grim slurp wl-clipboard
```

### Browser
```
brave-browser zen-browser
```

***

## 14. Build & Release Roadmap

### Phase 1: Foundation (Weeks 1–3)
- Set up `live-build` environment on Debian Bookworm[^3][^4]
- Define all `*.list.chroot` package lists
- Configure Btrfs subvolumes + snapper
- Calamares installer with CrabWithClawOS branding

### Phase 2: AI Tool Stack (Weeks 4–6)
- Build `crab-install` wrapper for all AI CLI tools
- Pre-configure LiteLLM with all free providers
- Claude Code skills deployment to `/etc/skel/.claude/skills/`
- Systemd services for Ollama, OpenClaw, LiteLLM
- Firejail profiles + cgroups v2 slices

### Phase 3: UX & Browser (Weeks 7–9)
- Brave browser with all predefined bookmarks (via `policies.json`)
- Zen Browser as secondary option
- Hyprland + Waybar configuration
- Zsh + Starship + Neovim (LazyVim) setup
- `crab-monitor` TUI dashboard
- Workspace layout presets

### Phase 4: Media & Polish (Weeks 10–12)
- CLI media tools integration + testing
- SoupaWhisper + nerd-dictation setup
- First-boot setup wizard
- Documentation site
- Automated ISO build via GitHub Actions
- v1.0 release: **"CrabWithClawOS — The Pincer Edition"** 🦀

***

*CrabWithClawOS: Where every terminal has claws, and every model has a key.* 🦀🔑

---

## References

1. [Debian 12 "Bookworm" | Specs, reviews and EoL info - InvGate](https://invgate.com/itdb/debian-12-bookworm) - Minimum Requirements:

 Processor: 1 GHz (i686 for 32-bit PC) RAM: 512 MB (1 GB recommended, 2 GB or...

2. [2.5. Memory and Disk Space Requirements - Debian](https://www.debian.org/releases/bookworm/amd64/ch02s05.en.html) - You must have at least 780MB of memory and 1160MB of hard disk space to perform a normal installatio...

3. [Quickly Build a Custom Debian Live ISO with Live-Build](https://ianlecorbeau.com/blog/debian-live-build.html) - Advice and rants about Unix, strength training, and other stuff

4. [Building a custom Debian ISO image](https://debian-live-config.readthedocs.io/en/latest/custom.html)

5. [Debian Live Manual](https://live-team.pages.debian.net/live-manual/html/live-manual.en.html) - As a first example, create a build directory, change to that directory and then execute the followin...

6. [Introducing into calamares bootloader - Habr](https://habr.com/en/articles/654755/) - Your directory with branding must be placed in /usr/share/calamares/branding, I will use /usr/share/...

7. [Best AI Coding CLI Tools in 2026: 7 Terminal Agents Compared](https://awesomeagents.ai/tools/best-ai-coding-cli-tools-2026/) - A data-driven comparison of the top AI coding CLI tools - Claude Code, Gemini CLI, Codex CLI, Aider,...

8. [Claude Code Review 2026: Complete AI Coding Assistant ...](https://hackceleration.com/claude-code-review/) - We see how we test automated code generation, contextual project analysis, and direct command execut...

9. [How to Integrate AI into Your Terminal Using OpenCode](https://www.freecodecamp.org/news/integrate-ai-into-your-terminal-using-opencode/) - OpenCode is an open-source AI coding assistant that works right inside your terminal. It's built for...

10. [OpenCode: an Open-source AI Coding Agent Competing with ...](https://www.infoq.com/news/2026/02/opencode-coding-agent/) - Open-source AI coding tool OpenCode features a native terminal-based UI, multi-session support, and ...

11. [Setup OpenClaw with Claude & Gemini: Your Private 24/7 ...](https://vertu.com/ai-tools/the-ultimate-guide-setting-up-openclaw-with-claude-code-and-gemini-3-pro/) - AI Tools · Guides. Support. Shipping & Delivery · Returns & Refunds ... OpenClaw is a “Pro” tool, me...

12. [The ULTIMATE OpenClaw Setup Guide!](https://www.reddit.com/r/AiForSmallBusiness/comments/1r4uyrh/the_ultimate_openclaw_setup_guide/) - OpenClaw Discord setup. OpenClaw GitHub installation guide. Top AI tools for small business growth. ...

13. [Amp Code AI Review 2026: Autonomous Agent for Developers](https://www.secondtalent.com/resources/amp-ai-review/) - Explore Amp (AmpCode), the AI-powered coding agent that automates workflows, refactors code, and col...

14. [Block released a new open source AI agent called Goose. It can do ...](https://www.reddit.com/r/LocalLLaMA/comments/1ic9wi6/block_released_a_new_open_source_ai_agent_called/) - Block released a new open source AI agent called Goose. It can do more than coding for engineers. Ot...

15. [Goose: An Open Source Take on Vibe Coding and Agentic Workflow ...](https://hyperdev.matsuoka.com/p/goose-an-open-source-take-on-vibe) - When OpenAI adopted MCP in March 2025 across ChatGPT and their Agents SDK, followed by Microsoft's i...

16. [The Open-Source Agent That's Redefining AI Coding Assistants](https://www.datastudios.org/post/kilo-code-the-open-source-agent-that-s-redefining-ai-coding-assistants) - Kilo Code—often simply called Kilo—has quickly become one of the most talked-about AI development to...

17. [Kilo Code: An open source AI coding agent that works with any model](https://tessl.io/blog/inside-kilo-code-an-open-source-ai-coding-agent-with-plans-to-reshape-software-development/) - Launched in March, 2025, Kilo Code is an open source coding agent that can be configured for a range...

18. [Top 10 Open-Source CLI Coding Agents You Should Be Using in ...](https://dev.to/forgecode/top-10-open-source-cli-coding-agents-you-should-be-using-in-2025-with-links-244m) - 1. ForgeCode – Your In-Terminal AI Pair Programmer · 2. Google Gemini CLI – Google's Terminal AI · 3...

19. [Top 10 Open Source AI Code Editors for Developers in 2025 - Vertu](https://vertu.com/ar/ai-tools/top-10-open-source-ai-code-editors-for-developers-2025/) - Visual Studio Code is a main ai-native code editor. Many developers pick it because it is open sourc...

20. [f/mcptools: A command-line interface for interacting with ...](https://github.com/f/mcptools) - A comprehensive command-line interface for interacting with MCP (Model Context Protocol) servers. Di...

21. [Run your own local LLM with Ollama](https://cylab.be/blog/377/run-your-own-local-llm-with-ollama) - So on Linux, you must. edit systemd service configuration with sudo systemctl edit ollama.service; a...

22. [Linux](https://docs.ollama.com/linux) - Create a service file in /etc/systemd/system/ollama.service : Copy. [Unit] Description=Ollama Servic...

23. [Extend Claude with skills - Claude Code Docs](https://code.claude.com/docs/en/skills) - Create, manage, and share skills to extend Claude's capabilities in Claude Code. Includes custom sla...

24. [Create Reusable Commands with Skills in Claude Code](https://wmedia.es/en/tips/claude-code-skills-custom-slash-commands) - Skills are markdown files that Claude Code executes as slash commands. Create a SKILL.md, invoke it ...

25. [Extend Claude with skills - Claude Code Docs](https://code.claude.com/docs/en/slash-commands) - Create, manage, and share skills to extend Claude's capabilities in Claude Code. Includes custom sla...

26. [The awesome collection of Claude Skills and resources. - GitHub](https://github.com/VoltAgent/awesome-claude-skills) - The awesome collection of Claude Skills and resources. - VoltAgent/awesome-claude-skills

27. [Brave’s Leo AI is Getting Smarter, Has Anyone Noticed the Improvements?](https://www.reddit.com/r/brave_browser/comments/1lypxbq/braves_leo_ai_is_getting_smarter_has_anyone/) - Brave’s Leo AI is Getting Smarter, Has Anyone Noticed the Improvements?

28. [Building Browser AI: Leo's Development Progress and Plans](https://brave.com/blog/leo-roadmap-2025-update/) - Leo has been evolving from a helpful browsing companion toward a smart, personalized collaborator—a ...

29. [How do I use AI Browsing in Brave?](https://support.brave.app/hc/en-us/articles/41240379376909-How-do-I-use-AI-Browsing-in-Brave) - Knowledge base for Brave Browser

30. [How do I use Brave Leo?](https://support.brave.app/hc/en-us/articles/20958609786637-How-do-I-use-Brave-Leo) - Knowledge base for Brave Browser

31. [Leo, Brave's browser-native AI assistant, is now available in Nightly ...](https://brave.com/blog/leo-release/) - Leo, the AI assistant built natively in the Brave browser, is now available for testing and feedback...

32. [AI Web Browsers Benchmark: Complete Selection Guide 2026research.aimultiple.com › ai-web-browser](https://research.aimultiple.com/ai-web-browser/) - Explore our comprehensive AI web browser benchmark comparing Brave Leo, Opera Aria, Arc Max, Perplex...

33. [Release notes - Zen Browser](https://zen-browser.app/release-notes/) - Zen Browser is built for speed, security, and true privacy. Download now to enjoy a beautifully-desi...

34. [Discovering Zen Browser: A Privacy-Focused Alternative - Oreate AI](https://www.oreateai.com/blog/discovering-zen-browser-a-privacyfocused-alternative/f7f4874c7e58f0612b3a12f782148a1a) - Zen Browser combines privacy-focused features with customizable options based on Firefox's framework...

35. [SoupaWhisper: How I Replaced SuperWhisper on Linux](https://www.ksred.com/soupawhisper-how-i-replaced-superwhisper-on-linux/) - Local voice-to-text for Linux using Whisper AI. Hold key, speak, release — text appears. No cloud, n...

36. [Nerd-Dictation - a simple, hackable speech to text tool for the Linux desktop](https://www.reddit.com/r/linux/comments/nl9oyv/nerddictation_a_simple_hackable_speech_to_text/?tl=fr) - Nerd-Dictation - a simple, hackable speech to text tool for the Linux desktop

37. [ideasman42/nerd-dictation: Simple, hackable offline ...](https://github.com/ideasman42/nerd-dictation) - This is a utility that provides simple access speech to text for using in Linux without being tied t...

38. [CLI Magic: Transform your audio files with SoX - Linux.com](https://www.linux.com/news/cli-magic-transform-your-audio-files-sox/) - Author: Shashank Sharma Sound eXchange (SoX) is a command-line sound sample translator. This Swiss A...

39. [sox man](https://linuxcommandlibrary.com/man/sox) - sox linux command man page: Convert, edit, and play audio files

40. [SoX guide: Convert, manipulate and generate audio on the ...](https://hyaline.systems/blog/sox-guide/) - SoX is a free command line audio processing tool with a text-based interface that let's you perform ...

41. [How to use FFmpeg for video editing - Hetzner Community](https://community.hetzner.com/tutorials/how-to-use-ffmpeg-for-video-editing/) - Step 1 - Installing. On Windows and Linux, you can download the latest build of FFmpeg from GitHub. ...

42. [CLI Editing Tools](https://www.reddit.com/r/photography/comments/1d7vpfy/cli_editing_tools/)

43. [Open-Source Photo Editing SDKs - 2025 Comparison | IMG.LY Blog](https://img.ly/blog/open-source-photo-editing-sdks-vs-img-ly-ce-sdk-an-honest-comparison-for-developers/) - Compare top open-source photo editing SDKs (Jimp, Pica, OpenCV, ImageMagick) with IMG.LY. Honest ana...

44. [FFMPEG: Convert & Edit Video via Command Line - GitHub Gist](https://gist.github.com/ntamvl/6ea38b566506e4811e4a029095bfa915) - FFMPEG is a free software that lets you create/edit/convert videos via command line. You can downloa...

45. [Video Editing on the Command Line](https://www.rigacci.org/wiki/doku.php/doc/appunti/linux/video/ffmpeg)

46. [Ghostty vs Kitty vs WezTerm – Which Terminal is BEST in 2026?](https://www.youtube.com/watch?v=HRTw7bLWQYs) - Ghostty vs Kitty vs WezTerm | Which Terminal Emulator is Best in 2025? In this video, I compare Ghos...

47. [Zellij: The Impressions of a Casual tmux User | Keyhole Software](https://keyholesoftware.com/zellij-the-impressions-of-a-casual-tmux-user/) - A terminal multiplexer is a program that allows you to interact with multiple terminal sessions with...

48. [Tmux vs Zellij: Terminal Multiplexer Decision Guide - TmuxAI](https://tmuxai.dev/tmux-vs-zellij/) - Both tools excel in their respective domains. tmux is the battle-tested workhorse with extensive eco...

49. [ZSH + Starship: A Productivity Masterpiece](https://carlosneto.dev/blog/2024/2024-02-08-starship-zsh/) - This blog post covers my prompt customization experience, favorite ZSH Plugins, ZSH options, and Sta...

50. [Starship: A minimal, fast, and customizable prompt for any ...](https://news.ycombinator.com/item?id=44364874) - I use oh-my-zsh which covers my needs well. Is starship 'faster' than that? If not, then I probably ...

51. [5 developer tools to really step up your workflow - DEV Community](https://dev.to/sardinessz/5-developer-tools-to-really-step-up-your-workflow-2f1o) - LazyDocker. lazydocker. Similar to lazygit, a TUI manager for docker. This is my favourite TUI so fa...

52. [LazyDocker - Simple Docker Terminal UI Tool](https://lazydocker.com) - Lazydocker Simplify Docker Management with TUI Tool. Lazydocker is a simple, terminal-based UI for m...

53. [Simplify Development with the Nix Ecosystem - Arctiq](https://arctiq.com/blog/simplify-development-with-the-nix-ecosystem) - The devenv CLI tool, built on-top of nix-shell and direnv, provides commands to simplify the creatio...

54. [How Linux Optimizes AI Hardware Acceleration](https://www.itprotoday.com/ai-machine-learning/how-linux-optimizes-ai-hardware-acceleration) - This article examines Linux's role in enhancing AI hardware acceleration, focusing on recent advance...

55. [This OS quietly powers all AI - and most future IT jobs, too](https://www.zdnet.com/article/why-ai-runs-on-linux/) - The Linux kernel is being tuned for AI and ML workloads. Nvidia's CUDA X stack, better partition mem...

56. [ZFS vs Btrfs: Architecture, Features, and Stability #2 - Klara Systems](https://klarasystems.com/articles/zfs-vs-btrfs-architects-features-and-stability-2/) - ZFS and Btrfs are often compared but differ in architecture, stability, and reliability. Learn how t...

57. [How to Sandbox Linux Apps with Firejail and Bubblewrap](https://firejail.wordpress.com/2025/08/20/how-to-sandbox-linux-apps-with-firejail-and-bubblewrap/) - On Linux systems, Bubblewrap and Firejail are two common sandboxing tools used if you need to provid...

58. [cgroups v2 & systemd-run - Resource Control and Sandboxing for ...](https://ohyaan.github.io/tips/cgroups_v2_&_systemd-run_-_resource_control_and_sandboxing_for_raspberry_pi/) - Control Groups (cgroups) v2 is a unified Linux kernel feature that provides hierarchical resource ma...

59. [aristocratos/btop: A monitor of resources](https://github.com/aristocratos/btop) - Resource monitor that shows usage and stats for processor, memory, disks, network and processes. C++...

60. [Modern Linux CLI Tools #16: BTOP](https://www.youtube.com/watch?v=CHeZ5-rbVGo) - In this new video today we are going to talk about BUP another of those um terminal tools that are s...

61. [Efficiency Improvement Hard? nvtop for Quick Solution](https://www.x-cmd.com/install/nvtop/) - NVTOP stands for Neat Videocard TOP, a (h)top like task monitor for GPUs and accelerators.. Install ...

62. [Syllo/nvtop: GPU & Accelerator process monitoring ...](https://github.com/Syllo/nvtop) - NVTOP stands for Neat Videocard TOP, a (h)top like task monitor for GPUs and accelerators. It can ha...

