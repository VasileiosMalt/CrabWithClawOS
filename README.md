# 🦀 CrabWithClawOS — Complete Debian-Based Distribution Blueprint

<img src="https://raw.githubusercontent.com/VasileiosMalt/CrabWithClawOS/refs/heads/main/CrabWithClawOS.png" alt="CrabWithClawOS" width="800" height="450">

A custom **Debian Bookworm**-based Linux distribution engineered for AI CLI coding agents, terminal-based development workflows, free LLM provider orchestration, and multimedia CLI tools.

***

## 1. System Requirements & Disk Space

### Hardware Requirements

CrabWithClawOS targets AI-focused workloads, so requirements exceed standard [Debian minimums](https://invgate.com/itdb/debian-12-bookworm).

| Tier | CPU | RAM | Storage | GPU | Use Case |
|------|-----|-----|---------|-----|----------|
| **Minimum** | 4-core 2.0 GHz (x86_64) | 8 GB | 60 GB SSD | None (CPU-only inference) | API-only AI tools, light Ollama models |
| **Recommended** | 8-core 3.0 GHz+ | 16 GB | 120 GB NVMe SSD | NVIDIA RTX 3060 (8 GB VRAM) | Full AI stack + local 7B models |
| **Optimal** | 12+ core (AMD Ryzen 9 / Intel i7+) | 32 GB+ | 256 GB+ NVMe SSD | NVIDIA RTX 4070+ (12 GB+ VRAM) | Multiple concurrent agents + local 70B models |

### Disk Space Breakdown

| Component | Space Required |
|-----------|---------------|
| [Debian base system](https://www.debian.org/releases/bookworm/amd64/ch02s05.en.html) + kernel + firmware | ~4 GB |
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

CrabWithClawOS is built using Debian's official [live-build](https://live-team.pages.debian.net/live-manual/html/live-manual.en.html) toolchain:

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

Package lists go in `config/package-lists/*.list.chroot`, dotfiles and configs in `config/includes.chroot_after_packages/etc/skel/`, and [post-install scripts](https://debian-live-config.readthedocs.io/en/latest/custom.html) in `config/hooks/`.

### Installer
- **[Calamares](https://habr.com/en/articles/654755/)** — GUI installer branded for CrabWithClawOS (crab+claw logo, slideshow explaining the AI tool stack)
- **First-boot wizard**: Select GPU vendor → install appropriate drivers → select AI tool preset (Minimal / Full / Local-only) → configure API keys via encrypted keyring

***

## 3. Complete AI CLI Tool Stack

### Tier 1 — Core AI Coding Agents (Pre-installed)

| Tool | License | Key Strength | Install |
|------|---------|-------------|---------|
| **[Claude Code](https://code.claude.com/docs/en/skills)** | Proprietary | Best autonomous agent, MCP, skills, context compaction | `npm i -g @anthropic-ai/claude-code` |
| **[Gemini CLI](https://awesomeagents.ai/tools/best-ai-coding-cli-tools-2026/)** | Free | 1M token context, free tier (1000 req/day), huge monorepo | `npm i -g @google/gemini-cli` |
| **[Aider](https://awesomeagents.ai/tools/best-ai-coding-cli-tools-2026/)** | Apache 2.0 | 100+ model support, deepest git integration, 39K+ stars | `pipx install aider-chat` |
| **[OpenCode](https://www.freecodecamp.org/news/integrate-ai-into-your-terminal-using-opencode/)** | Open Source | LSP integration, 75+ providers, multi-session, 95K+ stars | `curl -fsSL https://opencode.ai/install \| bash` |
| **[OpenAI Codex CLI](https://awesomeagents.ai/tools/best-ai-coding-cli-tools-2026/)** | Open Source | Rust-based, 3-tier permissions, ChatGPT integration | `npm i -g @openai/codex` |
| **[OpenClaw](https://vertu.com/ai-tools/the-ultimate-guide-setting-up-openclaw-with-claude-code-and-gemini-3-pro/)** | Open Source | Routes Claude + Gemini, gateway architecture, TUI + Web | `curl -fsSL https://openclaw.ai/install.sh \| bash` |
| **[Amp (Sourcegraph)](https://www.secondtalent.com/resources/amp-ai-review/)** | Freemium | Sub-agent orchestration, deep reasoning mode | `npm i -g @sourcegraph/amp` |

### Tier 2 — Additional AI Agents (via `crab-install`)

| Tool | Purpose |
|------|---------|
| **[Goose (Block)](https://hyperdev.matsuoka.com/p/goose-an-open-source-take-on-vibe)** | Autonomous task agent, MCP-native, Ollama support |
| **[Kilo Code CLI](https://www.datastudios.org/post/kilo-code-the-open-source-agent-that-s-redefining-ai-coding-assistants)** | Plan-act-observe-fix loop, 400+ models, audit logging |
| **[Cline](https://dev.to/forgecode/top-10-open-source-cli-coding-agents-you-should-be-using-in-2025-with-links-244m)** | Autonomous coding agent, 48K+ stars, executes commands |
| **[GitHub Copilot CLI](https://vertu.com/ar/ai-tools/top-10-open-source-ai-code-editors-for-developers-2025/)** | GitHub-native shell completions |
| **ForgeCode** | In-terminal pair programmer |

### Tier 3 — MCP & Local Inference

| Tool | Purpose |
|------|---------|
| **[MCP Tools CLI](https://github.com/f/mcptools)** | Discover, call, manage MCP servers from terminal |
| **[Ollama](https://docs.ollama.com/linux)** | Local LLM server (llama3, codellama, deepseek-coder) |
| **Open WebUI** | Browser UI for Ollama models |
| **LiteLLM Proxy** | Unified API proxy for 100+ LLM providers |

### Tier 4 — AI Pipeline & Research Tools

| Tool | Purpose |
|------|---------|
| **HuggingFace CLI** | Download models, datasets, push to HF Hub from terminal |
| **llm (Simon Willison)** | Universal CLI to call 50+ LLM APIs, log queries to SQLite |
| **fabric** | AI prompt pipeline framework (e.g., `echo text | fabric --pattern summarize`) |
| **sgpt (shell-gpt)** | ChatGPT-like CLI for shell commands and code generation |
| **Jupyter CLI** | Launch notebooks for AI experiments from terminal |

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
| **[Aider](https://awesomeagents.ai/tools/best-ai-coding-cli-tools-2026/)** | Native support for 100+ providers including all listed above via `--model` flag |
| **[OpenCode](https://www.freecodecamp.org/news/integrate-ai-into-your-terminal-using-opencode/)** | 75+ providers natively, OpenAI-compatible endpoints |
| **[Gemini CLI](https://awesomeagents.ai/tools/best-ai-coding-cli-tools-2026/)** | Google AI Studio directly (free tier) |
| **Claude Code** | Anthropic API (paid), but can route via OpenRouter free models for non-Claude tasks |
| **[Goose](https://hyperdev.matsuoka.com/p/goose-an-open-source-take-on-vibe)** | Ollama locally + any OpenAI-compatible endpoint |
| **[Kilo Code](https://www.datastudios.org/post/kilo-code-the-open-source-agent-that-s-redefining-ai-coding-assistants)** | 400+ models, all OpenAI-compatible providers |
| **[OpenClaw](https://vertu.com/ai-tools/the-ultimate-guide-setting-up-openclaw-with-claude-code-and-gemini-3-pro/)** | Routes between Claude + Gemini natively |
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

Claude Code skills are markdown files stored in `~/.claude/skills/` that extend Claude's capabilities. CrabWithClawOS ships with a curated selection [pre-installed](https://github.com/VoltAgent/awesome-claude-skills):

### Official Anthropic Skills (Pre-installed)

| Skill | What It Does |
|-------|-------------|
| `anthropic/docx` | Create, edit, and analyze Word documents |
| `anthropic/xlsx` | Create, edit, and analyze Excel spreadsheets |
| `anthropic/pdf` | Extract text, create PDFs, handle forms |
| `anthropic/pptx` | Create and edit PowerPoint presentations |
| `anthropic/doc-coauthoring` | Collaborative document editing |
| `anthropic/mcp-builder` | Create MCP servers to integrate external APIs |
| `anthropic/webapp-testing` | Test web apps using Playwright |
| `anthropic/frontend-design` | Frontend design and UI/UX development |
| `anthropic/canvas-design` | Design visual art in PNG/PDF |
| `anthropic/algorithmic-art` | Generative art using p5.js |
| `anthropic/skill-creator` | Meta-skill: guide for creating new skills |

### Community Skills (Pre-installed — Curated Best)

| Skill | Category | Purpose |
|-------|----------|---------|
| `obra/test-driven-development` | Development | Write tests before implementing code |
| `obra/systematic-debugging` | Development | Methodical problem-solving in code |
| `obra/root-cause-tracing` | Development | Investigate fundamental problems |
| `obra/subagent-driven-development` | Development | Multi-sub-agent development workflow |
| `obra/dispatching-parallel-agents` | Productivity | Coordinate multiple simultaneous agents |
| `obra/verification-before-completion` | Development | Validate work before finalizing |
| `obra/brainstorming` | Productivity | Generate and explore ideas |
| `obra/writing-plans` | Productivity | Create strategic documentation |
| `obra/executing-plans` | Productivity | Implement strategic plans |
| `obra/finishing-a-development-branch` | Git | Complete Git code branches |
| `obra/requesting-code-review` | Git | Initiate code review processes |
| `obra/receiving-code-review` | Git | Process and incorporate feedback |
| `obra/using-git-worktrees` | Git | Manage multiple Git working trees |
| `fvadicamo/dev-agent-skills` | Git/GitHub | git-commit, PR creation, merge, review |
| `alinaqi/claude-bootstrap` | Project Init | Security-first guardrails, spec-driven todos |
| `zxkane/aws-skills` | Cloud | AWS infrastructure automation |
| `lackeyjb/playwright-skill` | Testing | Browser automation with Playwright |
| `sanjay3290/postgres` | Database | Safe read-only SQL against PostgreSQL |
| `scarletkc/vexor` | Search | Semantic file search with vector CLI |
| `SHADOWPR0/security-bluebook-builder` | Security | Build security Blue Books for sensitive apps |
| `obra/defense-in-depth` | Security | Multi-layered security approaches |
| `wrsmith108/varlock-claude-skill` | Security | Secure env variable management |
| `ComposioHQ/changelog-generator` | DevOps | Transform git commits into release notes |
| `K-Dense-AI/claude-scientific-skills` | Science | Scientific research and analysis |
| `czlonkowski/n8n-*` (7 skills) | Automation | Full n8n workflow automation suite |

### Context Engineering Skills (Pre-installed)

These advanced skills by muratcankoylan teach Claude how to handle context effectively:

- `context-fundamentals` — What context is and why it matters
- `context-degradation` — Recognize context failure patterns
- `context-compression` — Compression strategies for long sessions
- `context-optimization` — Compaction, masking, caching
- `multi-agent-patterns` — Orchestrator, peer-to-peer, hierarchical architectures
- `memory-systems` — Short-term, long-term, graph-based memory
- `tool-design` — Build tools agents can use effectively
- `evaluation` — Build evaluation frameworks for agent systems

### Global CLAUDE.md (Pre-configured)

CrabWithClawOS ships with a [global CLAUDE.md](https://code.claude.com/docs/en/skills) optimized for the distro:

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

Brave is the most AI-integrated browser available for Linux:

- **[Leo AI](https://brave.com/blog/leo-roadmap-2025-update/)** — Built-in AI assistant in the sidebar, powered by multiple models (Llama, Mixtral, Claude)
- **[AI Browsing](https://support.brave.app/hc/en-us/articles/41240379376909-How-do-I-use-AI-Browsing-in-Brave)** — Autonomous agent mode that can browse, research, fill carts, compare products
- **Multi-Tab Context** — Leo understands content across multiple open tabs
- **Skills** — Create custom AI Skills like `/fact-check`, `/research-brief`
- **Vision** — Analyze images on webpages and in PDFs
- **[Privacy-first](https://brave.com/blog/leo-release/)** — No logging, conversations not stored, anonymous reverse-proxy
- **Cross-session memory** — AI remembers previous browsing sessions

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

### Alternative Browser: [Zen Browser](https://zen-browser.app/release-notes/)

Pre-installed as secondary option for users preferring maximum [privacy](https://www.oreateai.com/blog/discovering-zen-browser-a-privacyfocused-alternative/f7f4874c7e58f0612b3a12f782148a1a):
- Firefox-based, MPL 2.0 open source
- All telemetry completely stripped from core
- Vertical tabs, split view, workspace management
- No AI features (for users who want pure privacy without cloud AI)

***

## 7. CLI Media Tools

### Dictation / Speech-to-Text

| Tool | Description | Install |
|------|-------------|---------|
| **[SoupaWhisper](https://www.ksred.com/soupawhisper-how-i-replaced-superwhisper-on-linux/)** | Local push-to-talk voice-to-text using faster-whisper. Hold F12 → speak → release → text typed into active window. ~250 line Python script, 100% local, no cloud | `pipx install soupawhisper` |
| **[nerd-dictation](https://github.com/ideasman42/nerd-dictation)** | Offline speech-to-text using VOSK-API. Single-file Python script, minimal deps, zero background overhead. Manual begin/end activation, configurable with Python string ops | `pip install nerd-dictation` + VOSK model |

**Recommended primary**: SoupaWhisper (uses faster-whisper which is much faster than VOSK)
**Recommended fallback**: nerd-dictation (lighter, no GPU needed)

### Audio Editing (CLI)

| Tool | Description | Install |
|------|-------------|---------|
| **[SoX (Sound eXchange)](https://hyaline.systems/blog/sox-guide/)** | "Swiss Army knife of audio." Convert between 20+ formats, apply effects (echo, fade, chorus, normalize, reverse, trim), batch process entire folders. Chain effects: `sox in.wav out.mp3 trim 10 5 norm reverse` | `apt install sox libsox-fmt-all` |
| **[FFmpeg](https://community.hetzner.com/tutorials/how-to-use-ffmpeg-for-video-editing/)** (audio mode) | Extract audio from video, convert formats, adjust bitrate/sample rate, mix channels. Example: `ffmpeg -i video.mp4 -vn -acodec libmp3lame audio.mp3` | `apt install ffmpeg` |

**Recommended primary**: SoX (purpose-built for audio)
**Recommended secondary**: FFmpeg (when working with audio extracted from video)

### Image Editing (CLI)

| Tool | Description | Install |
|------|-------------|---------|
| **[ImageMagick 7](https://img.ly/blog/open-source-photo-editing-sdks-vs-img-ly-ce-sdk-an-honest-comparison-for-developers/)** | Industry-standard CLI image manipulation. Resize, crop, color adjust, composite, annotate, format convert, batch process. Example: `magick input.jpg -resize 50% -blur 0x2 -quality 85 output.jpg` | `apt install imagemagick` |
| **[GraphicsMagick](https://img.ly/blog/open-source-photo-editing-sdks-vs-img-ly-ce-sdk-an-honest-comparison-for-developers/)** | ImageMagick fork focused on stability and performance. Same syntax, faster for large batches. Better thread safety | `apt install graphicsmagick` |

**Recommended primary**: ImageMagick 7 (wider format support, more filters)
**Recommended fallback**: GraphicsMagick (faster batch processing)

### Video Editing (CLI)

| Tool | Description | Install |
|------|-------------|---------|
| **[FFmpeg](https://gist.github.com/ntamvl/6ea38b566506e4811e4a029095bfa915)** | The universal video tool. Cut/trim, merge, transcode, extract frames, add subtitles, stabilize, resize, adjust speed. Example: `ffmpeg -i in.mp4 -ss 00:01:00 -t 00:00:30 -c copy clip.mp4` | `apt install ffmpeg` |
| **MLT (melt)** | Command-line video editor from the Shotcut/Kdenlive ecosystem. Supports transitions, filters, multi-track compositing. Example: `melt clip1.mp4 -mix 25 -mixer luma clip2.mp4 -consumer avformat:output.mp4` | `apt install mlt-7` |

**Recommended primary**: FFmpeg (handles 99% of CLI video tasks)
**Recommended secondary**: melt (when you need transitions/compositing without a GUI)

***

## 8. Terminal Environment Stack

### Terminal Emulator: Ghostty (Primary) + Kitty (Fallback)

- **[Ghostty](https://www.youtube.com/watch?v=HRTw7bLWQYs)** — GPU-accelerated, clean interface, excellent multi-tab performance
- **[Kitty](https://www.youtube.com/watch?v=HRTw7bLWQYs)** — Mature GPU-accelerated terminal, image protocol, built-in splits
- **[WezTerm](https://www.youtube.com/watch?v=HRTw7bLWQYs)** — Lua-configurable Rust-based fallback

### Terminal Multiplexer: Zellij + tmux

- **[Zellij](https://keyholesoftware.com/zellij-the-impressions-of-a-casual-tmux-user/)** — Modern, self-documenting, plugin system, intuitive defaults
- **[tmux](https://tmuxai.dev/tmux-vs-zellij/)** — Pre-installed for compatibility

### Shell: Zsh + Starship

- **[Zsh](https://carlosneto.dev/blog/2024/2024-02-08-starship-zsh/)** with zsh-autosuggestions, zsh-syntax-highlighting, fzf integration
- **[Starship](https://news.ycombinator.com/item?id=44364874)** — Rust-compiled async prompt showing git, Python/Node versions, GPU status

### Editor Stack

| Editor | Role |
|--------|------|
| **Neovim** (LazyVim config) | Primary — LSP, Treesitter, Copilot, AI integrations |
| **Helix** | Secondary — built-in LSP, no config needed |
| **VS Code (code-oss)** | Optional — for extension-based AI tools |

### Typography & Icons (Nerd Fonts)

The entire visual stack (Starship, Neovim, Zellij icons, eza, yazi) requires Nerd Fonts to render correctly:

- **JetBrains Mono Nerd Font** — Pre-installed as default
- **FiraCode Nerd Font** — Ligature-heavy alternative
- **Installation**: Managed via `fonts-jetbrains-mono` + Nerd Fonts patcher script at first boot.

***

## 9. Development Infrastructure

### Runtimes & Version Managers
- **[mise](https://arctiq.com/blog/simplify-development-with-the-nix-ecosystem)** — Universal runtime version manager (replaces nvm, pyenv, etc.)
- **Python 3.12+** with `pip`, `pipx`, `uv` (fast replacement for pip)
- **Node.js 22 LTS** with `npm`, `pnpm`
- **Rust** via `rustup`
- **Go 1.22+**
- **Bun** — Fast JS runtime used by [OpenClaw](https://vertu.com/ai-tools/the-ultimate-guide-setting-up-openclaw-with-claude-code-and-gemini-3-pro/)

### Cloud Provider CLIs & IaC
- **Cloud CLIs**: AWS CLI v2, Google Cloud (gcloud), Azure (az), DigitalOcean (doctl), Fly.io (flyctl), Vercel, Netlify
- **Infrastructure as Code**: [OpenTofu](https://opentofu.org/) (Terraform fork), Ansible (agentless configuration), Pulumi (IaC via Python/TS), Terragrunt

### Kubernetes & Container Orchestration
- **[Docker](https://lazydocker.com)** + **Docker Compose** + **[lazydocker](https://dev.to/sardinessz/5-developer-tools-to-really-step-up-your-workflow-2f1o)** (TUI)
- **Podman** + **Distrobox**
- **Kubernetes**: `kubectl`, `k9s` (TUI), `helm`, `k3s`/`minikube` for local AI workloads

### Database CLI Tools
- **Relational**: `pgcli` (PostgreSQL), `mycli` (MySQL/MariaDB), `litecli` (SQLite) — all with auto-completion
- **NoSQL & Universal**: `mongosh` (MongoDB), `redis-cli`, `usql` (Universal CLI for 20+ databases)

### Network, Remote Access & Secrets
- **Remote**: **Mosh** (mobile shell), **Tailscale** (mesh VPN), **Termius** (SSH manager), **sshs** (TUI SSH config), **tmate** (shared sessions)
- **Secrets**: `age` (encryption), `sops` (Git-safe secrets), `pass` (Unix standard), Bitwarden CLI, HashiCorp Vault
- **HTTP/API**: [HTTPie](https://httpie.io/), `xh` (Rust-based fast HTTPie), `curlie`

### Task Automation & Git
- **[Git](https://dev.to/sardinessz/5-developer-tools-to-really-step-up-your-workflow-2f1o)** + **lazygit** (TUI) + **delta** (syntax diffs) + **gh** (GitHub CLI)
- **Automation**: `just` (modern Makefile), `watchexec` (run on change), `process-compose` (manage multi-process AI stacks)
- **[direnv](https://arctiq.com/blog/simplify-development-with-the-nix-ecosystem)** — Auto-load environment variables per directory

### File Tools & CLI Essentials
- **[yazi](https://dev.to/sardinessz/5-developer-tools-to-really-step-up-your-workflow-2f1o)** (file manager), `fzf` (fuzzy finder), `ripgrep`, `fd`, `bat`, `eza`, `zoxide`, `jq`/`yq`, `tokei`

***

## 10. Kernel & OS-Level Optimizations

### Kernel: `linux-image-amd64` (Debian stock) + [Custom tuning](https://www.zdnet.com/article/why-ai-runs-on-linux/)

Debian's stock kernel is used for stability, with [AI-optimized sysctl](https://www.itprotoday.com/ai-machine-learning/how-linux-optimizes-ai-hardware-acceleration) settings:

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
- **NVIDIA**: `nvidia-driver` + `nvidia-cuda-toolkit` from `non-free` repos, persistence mode
- **AMD**: `firmware-amd-graphics` + ROCm from AMD repos
- **Intel**: `intel-media-va-driver` + `intel-compute-runtime`

### Filesystem: [Btrfs](https://klarasystems.com/articles/zfs-vs-btrfs-architects-features-and-stability-2/)

```
# Subvolume layout
@           -> /
@home       -> /home
@models     -> /var/lib/ollama/models
@docker     -> /var/lib/docker
@snapshots  -> /.snapshots
```

Automated snapshots via **snapper** — hourly + pre/post apt hooks.

### [cgroups v2 Resource Control](https://ohyaan.github.io/tips/cgroups_v2_&_systemd-run_-_resource_control_and_sandboxing_for_raspberry_pi/)

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
| `ollama.service` | [Local LLM server](https://docs.ollama.com/linux), GPU-aware, memory-limited |
| `openclaw-gateway.service` | [OpenClaw](https://www.reddit.com/r/AiForSmallBusiness/comments/1r4uyrh/the_ultimate_openclaw_setup_guide/) orchestrator, port 18789 |
| `litellm-proxy.service` | Unified LLM API proxy on localhost:4000 |
| `crab-monitor.service` | System + AI monitoring dashboard |
| `crab-snapshot.timer` | Automated Btrfs snapshots every 2 hours |

### Sandboxing
- **[Firejail](https://firejail.wordpress.com/2025/08/20/how-to-sandbox-linux-apps-with-firejail-and-bubblewrap/)** for AI agents that execute arbitrary code
- **bubblewrap** for finer-grained sandboxing
- systemd `ProtectSystem=strict`, `PrivateTmp=yes`, `NoNewPrivileges=yes` on all AI services

***

## 11. Monitoring & Observability

| Tool | Purpose |
|------|---------|
| **[btop](https://github.com/aristocratos/btop)** | [CPU, RAM, Disk, Network](https://www.youtube.com/watch?v=CHeZ5-rbVGo) monitoring with GPU support |
| **[nvtop](https://github.com/Syllo/nvtop)** | [GPU utilization](https://www.x-cmd.com/install/nvtop/), VRAM, temp, power (NVIDIA/AMD/Intel) |
| **bandwhich** | Per-process network bandwidth |
| **systemd-cgtop** | Real-time [cgroup resource](https://ohyaan.github.io/tips/cgroups_v2_&_systemd-run_-_resource_control_and_sandboxing_for_raspberry_pi/) consumption |

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
- Set up **[live-build](https://live-team.pages.debian.net/live-manual/html/live-manual.en.html)** environment on Debian Bookworm
- Define all `*.list.chroot` package lists and Btrfs subvolumes
- Calamares installer with **[CrabWithClawOS branding](https://habr.com/en/articles/654755/)**

### Phase 2: AI Tool Stack (Weeks 4–6)
- Build `crab-install` wrapper for all AI CLI tools
- Pre-configure LiteLLM with all free providers
- Claude Code skills deployment and systemd services for Ollama/OpenClaw
- Firejail profiles + cgroups v2 slices

### Phase 3: UX & Browser (Weeks 7–9)
- Brave browser with predefined bookmarks and Zen Browser secondary
- Hyprland + Waybar configuration
- Zsh + Starship + Neovim (LazyVim) setup
- `crab-monitor` TUI dashboard

### Phase 4: Media & Polish (Weeks 10–12)
- CLI media tools (FFmpeg, SoX, SoupaWhisper) integration
- Documentation site and automated ISO build via GitHub Actions
- v1.0 release: **"CrabWithClawOS — The Pincer Edition"** 🦀

***

## 15. Communication & Knowledge Management

### Team Collaboration (CLI-native)
- **Slack CLI**: Manage enterprise team communication from the terminal.
- **neomutt**: High-performance terminal email client.
- **gomuks**: Matrix TUI for secure, open-source team chat.
- **tmate**: Instant shared terminal sessions for pair programming and debugging.

### Knowledge Management & Research
- **[Logseq](https://logseq.com/)**: Local-first, Markdown-based knowledge graph for research notes and prompts.
- **jrnl**: CLI journaling tool to log AI experiments (`jrnl today I tested DeepSeek R1 and...`).
- **glow**: Terminal Markdown renderer for beautiful documentation reading.

***

*CrabWithClawOS: Where every terminal has claws, and every model has a key.* 🦀🔑


