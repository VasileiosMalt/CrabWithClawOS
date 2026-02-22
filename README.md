# 🦀 OpenClawOS — AI-Native Debian Linux Distribution

<p align="center">
  <img src="https://raw.githubusercontent.com/VasileiosMalt/CrabWithClawOS/refs/heads/main/CrabWithClawOS.png" alt="OpenClawOS" width="800">
</p>

**OpenClawOS** is a custom Debian Bookworm-based Linux distribution engineered from the ground up for AI-driven development, LLM orchestration, and high-performance terminal workflows. It integrates a unified AI proxy, local inference engines, and the industry's most advanced CLI coding agents into a seamless, ready-to-use environment.

---

## 🚀 Core Features

### 🤖 The AI Command Center
- **LiteLLM Gateway:** A unified proxy (running on `localhost:4000`) that routes to 100+ LLM providers (OpenAI, Anthropic, Gemini, Groq, DeepSeek) with a single API interface.
- **Ollama Integration:** Pre-configured local LLM server (running on `localhost:11434`) with GPU acceleration and resource-optimized systemd services.
- **Agent Toolset:** Pre-installed and path-ready: `claude-code`, `gemini-cli`, `aider`, `opencode-ai`, `sgpt (shell-gpt)`, `fabric`, and `llm`.
- **AI System Slice:** Custom `cgroups` slice (`ai-agents.slice`) and `sysctl` optimizations for memory-intensive LLM workflows.

### 💻 Developer Experience (DX)
- **Modern Shell:** Zsh configured with **Starship** (async prompt), **zoxide** (smart cd), and **mise** (universal runtime manager).
- **Terminal Stack:** **Ghostty** and **Kitty** terminal emulators with **Zellij** multiplexer and **Yazi** file manager.
- **Editors:** **Neovim** (pre-configured with LazyVim) and **Helix** (modal editor with built-in LSP).
- **Tooling:** `lazygit`, `lazydocker`, `gh` (GitHub CLI), `jq`, `fd`, `ripgrep`, `bat`, `delta`, and `fzf`.

### 🏗️ Infrastructure & Runtimes
- **Virtualization:** Docker (ce-stable) and Podman/Distrobox pre-installed.
- **Cloud & K8s:** `kubectl`, `helm`, `k9s`, and Tailscale mesh VPN integration.
- **Runtimes:** **Node.js 22 LTS**, **Python 3.12+**, **Go 1.23**, **Rust (Stable)**, **Bun**, and **uv**.

### 🎨 Desktop Environment
- **Primary:** **XFCE4** — Lightweight, stable, and highly responsive.
- **Experimental:** **Hyprland** (Wayland) — Dynamic tiling with Waybar and custom blur/gaps.
- **Branding:** Custom OpenClawOS wallpapers and "Arc-Dark" / "Papirus" theme integration.


---

## 📖 Usage Guide

### Default Credentials
- **Username:** `openclawos`
- **Password:** `openclawos`
- **Hostname:** `openclawos`

### Quick Start
1. **System Status:** Run the custom status command to check your AI services and tool health:
   ```bash
   openclawos-info
   ```
2. **Setup API Keys:** Export your keys to use the LiteLLM gateway:
   ```bash
   export ANTHROPIC_API_KEY=sk-ant-...
   export GEMINI_API_KEY=...
   export OPENAI_API_KEY=sk-...
   ```
3. **LiteLLM Proxy:** Edit `/etc/openclawos/litellm_config.yaml` to manage your model routing.
4. **Ollama:** Manage local models using `ollama run <model>` or `ollama list`.
5. **Environment:** Use the global `CLAUDE.md` in your home directory to set context for AI agents.

### AI Service Management
- **LiteLLM Proxy:** `sudo systemctl status litellm` (Service on port 4000)
- **Ollama:** `sudo systemctl status ollama` (Service on port 11434)

---

## 📋 Complete Tool Stack

| Category | Tools |
|----------|-------|
| **AI Agents** | `claude-code`, `gemini-cli`, `aider`, `opencode-ai`, `sgpt`, `fabric`, `llm`, `codex` |
| **Inference** | `Ollama`, `LiteLLM`, `huggingface-cli` |
| **Dev Tools** | `git`, `lazygit`, `gh`, `docker`, `podman`, `distrobox`, `tailscale` |
| **K8s** | `kubectl`, `helm`, `k9s` |
| **Terminal** | `Zsh`, `Starship`, `Zellij`, `Ghostty`, `Kitty`, `Yazi`, `zoxide`, `mise` |
| **Editors** | `Neovim`, `Helix`, `Vim`, `Nano` |
| **Media** | `FFmpeg`, `SoX`, `ImageMagick`, `GraphicsMagick`, `MLT-7` |
| **Monitoring** | `btop`, `nvtop`, `iotop`, `sysstat`, `bandwhich` |

---

*OpenClawOS: The first AI-agent oriented Linux OS* 🦀
