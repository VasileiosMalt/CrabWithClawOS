# 🦀 OpenClawOS — AI-Native Debian Linux Distribution

<p align="center">
  <img src="https://raw.githubusercontent.com/VasileiosMalt/CrabWithClawOS/refs/heads/main/pics/Screenshot_1.png" alt="OpenClawOS" width="800">
</p>

**OpenClawOS** is a custom Debian Bookworm 12 (amd64) based Linux distribution engineered from the ground up for AI-driven development, LLM orchestration, and high-performance terminal workflows. It integrates a unified AI proxy, local inference engines, and the industry's most advanced CLI coding agents into a seamless, ready-to-use environment.

*Note: This is an experimental effort for the formulation of an AI- and Agentic-oriented Linux Distro that would facilitate an optimal utilization of the OS env in agentic mode. There is also a heavy software toolkit of various functionalities (image and video editing, virtualization, containerazation, remote connections, CI/CD and more) whose tools can, nevertheless, be operationalised through terminal (given that agentic ai will be using them)**
---

## 📥 Download & Installation

### Latest Release (v1.0)
You can download the hybrid ISO image (supporting both BIOS and UEFI boot) from SourceForge:
- **[Download OpenClawOS from SourceForge](https://sourceforge.net/projects/openclawos/files/v1.0/)**
- **[Direct Download Link](https://sourceforge.net/projects/openclawos/files/v1.0/openclawos-bookworm-amd64.hybrid.iso/download)**

### Requirements & Booting
- **Architecture:** x86_64 (amd64) CPU.
- **RAM:** 4 GB minimum (8 GB+ recommended for heavy AI workloads).
- **Booting:** Write the ISO to USB using `dd`, `Rufus`, `Balena Etcher`, or `Ventoy`.

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
- **Base System:** Debian 12 "Bookworm" (Kernel 6.1) with full firmware bundles (Wi-Fi, Realtek, Atheros, Intel, Broadcom).
- **Filesystems:** `btrfs`, `exfat`, `NTFS`, and `snapper` for snapshots.
- **Virtualization:** Docker (with Buildx/Compose), Podman, Buildah, Skopeo, and Distrobox.
- **Cloud & K8s:** `kubectl`, `helm`, `k9s`, and Tailscale mesh VPN integration.
- **Runtimes:** **Node.js 22 LTS**, **Python 3.12+**, **Go 1.23**, **Rust (Stable)**, **Bun**, and **uv**.

### 🎨 Desktop & Browsers
- **Primary:** **XFCE4** (Xorg) — Lightweight, stable, and highly responsive.
- **Experimental:** **Hyprland** (Wayland) — Dynamic tiling with Waybar and custom blur/gaps.
- **Web Browsers:** **Firefox ESR** (Default), **Brave Browser**, and **Opera** (Pre-installed with official repositories).
- **Branding:** Custom OpenClawOS wallpapers and "Arc-Dark" / "Papirus" theme integration.
- **Media:** VLC, LibreOffice, GParted, Evince, Mousepad, Ristretto.

---

## 🛡️ Verification & Safety

After downloading the ISO, verify its integrity:
- **SHA256:** `sha256sum openclawos-*.hybrid.iso` (compare with `.sha256` file)
- **MD5:** `md5sum openclawos-*.hybrid.iso` (compare with `.md5` file)

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
2. **Patching:** If you encounter minor CLI tool issues, download the `openclaws_patch.sh` when you have installed OpenClawOS in a disk, and then run the patch script (Highly recommended to run, if you don't trust it feel free to run an antivirus and scan it for vulnerabilities) :
   ```bash
   sed -i 's/\r//g' openclaws_patch.sh && chmod +x openclaws_patch.sh && sudo bash openclaws_patch.sh
   ```
3. **Setup API Keys:** Export your keys to use the LiteLLM gateway:
   ```bash
   export ANTHROPIC_API_KEY=sk-ant-...
   export GEMINI_API_KEY=...
   export OPENAI_API_KEY=sk-...
   ```
4. **LiteLLM Proxy:** Edit `/etc/openclawos/litellm_config.yaml` to manage your model routing.
5. **Ollama:** Manage local models using `ollama run <model>` or `ollama list`.
6. **Environment:** Use the global `CLAUDE.md` in your home directory to set context for AI agents.

### AI Service Management
- **LiteLLM Proxy:** `sudo systemctl status litellm` (Service on port 4000)
- **Ollama:** `sudo systemctl status ollama` (Service on port 11434)

---

## 📋 Complete Tool Stack

| Category | Tools |
|----------|-------|
| **AI Agents** | `claude-code`, `gemini-cli`, `aider`, `opencode-ai`, `sgpt`, `fabric`, `llm`, `codex`, `open-webui` |
| **Inference** | `Ollama`, `LiteLLM`, `huggingface-cli`, `jupyter` |
| **Dev Tools** | `git`, `lazygit`, `gh`, `docker`, `podman`, `buildah`, `skopeo`, `distrobox`, `tailscale` |
| **K8s** | `kubectl`, `helm`, `k9s` |
| **Terminal** | `Zsh`, `Starship`, `Zellij`, `Ghostty`, `Kitty`, `Yazi`, `zoxide`, `mise`, `eza`, `delta`, `just` |
| **Editors** | `Neovim`, `Helix`, `Vim`, `Nano` |
| **Media** | `FFmpeg`, `SoX`, `ImageMagick`, `GraphicsMagick`, `MLT-7`, `VLC` |
| **Monitoring** | `btop`, `nvtop`, `iotop`, `sysstat`, `bandwhich`, `htop`, `baobab` |
| **Filesystems** | `btrfs-progs`, `exfat-fuse`, `ntfs-3g`, `snapper` |
| **Browsers** | `BrowserOS`, `Firefox ESR`, `Brave`, `Opera` |

---

*OpenClawOS: The first AI-agent oriented Linux OS* 🦀
