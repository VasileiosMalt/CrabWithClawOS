\# OpenClawOS AI Edition (Hybrid ISO)



OpenClawOS AI Edition is an \*\*AI‑native\*\* Debian Bookworm 12 (amd64) live system with a focus on local and proxied LLM tooling, a polished XFCE desktop, and ready‑to‑use AI developer tooling out of the box.



---



\## 1. Overview



\- Base: Debian 12 “Bookworm” (64‑bit), live ISO, hybrid BIOS/UEFI boot.  

\- Desktop: XFCE 4.18 with LightDM + lightdm‑gtk‑greeter and a custom OpenClawOS theme/wallpaper.

\- Target use cases: AI experimentation, coding, data science, secure browsing, and general desktop usage.



---



\## 2. Main Features



\- Live system with installer  

&nbsp; - Built with `live-build` for an ISO‑hybrid image that boots on both BIOS and UEFI systems.  

\- Desktop \& multimedia  

&nbsp; - XFCE 4.18, LightDM, full Xorg stack, Firefox ESR, VLC, LibreOffice, GParted, Evince, PDF tools, screenshot \& screen locker (xscreensaver).  

\- Hardware support  

&nbsp; - Linux kernel 6.1 (Debian), full firmware bundles for Wi‑Fi, Realtek, Atheros, Intel, Broadcom, plus btrfs, exfat, NTFS, and snapshot tools (snapper). 



---



\## 3. AI \& Developer Stack



\### AI runtimes and tools



\- Local models  

&nbsp; - Ollama installed system‑wide, with a systemd service (`ollama.service`) and tuned environment options.  

\- Unified AI proxy  

&nbsp; - LiteLLM configured on port 4000 with a YAML config under `/etc/openclawos/litellmconfig.yaml`, supporting Anthropic, Gemini, OpenAI, Groq, DeepSeek, and local Ollama routing via environment API keys.

\- Python AI tooling (via `pipx`)  

&nbsp; - Includes: `aider-chat`, `litellm`, `fabric-ai`, `llm`, `shell-gpt (sgpt)`, `huggingface-hub`, `jupyter`, `open-webui` and their shims under `/usr/local/bin`. 

\- Node.js AI tooling  

&nbsp; - Node.js 22.x from NodeSource, NPM global tools including a variety of AI/LLM CLIs and helper utilities.



\### Languages and runtimes



\- Python 3.11 “full” stack with `python3-dev`, `venv`, `pip`, `pipx`. 

\- Node.js 22, npm, pnpm, plus additional JS tooling.  

\- Go toolchain (1.23.x) under `/usr/local`, with common CLI tools like `lazygit`, `lazydocker`, `k9s`, `gh`, `yq` installed to `/usr/local/bin`. 

\- Rust via rustup, with a curated set of cargo utilities (e.g. `zellij`, `eza`, `delta`, `just`) copied into `/usr/local/bin`.  

\- Additional runtimes: Bun, `uv` (Python), and `mise` for multi‑runtime management.



\### Containers, DevOps \& networking



\- Containers  

&nbsp; - Docker Engine (with Buildx and Compose plugins), Podman, Buildah, Skopeo, Distrobox.  

\- Kubernetes  

&nbsp; - `kubectl` (latest stable), Helm 3 installed via upstream script.  

\- VPN \& mesh  

&nbsp; - Tailscale from the official `bookworm` repo with proper keyring and `tailscaled` systemd integration.  



---



\## 4. Desktop \& UX



\- XFCE session with: panel plugins, power manager, notify daemon, task manager, clipman, pulseaudio plugin, whisker menu, and xfce‑screenshooter.  

\- Audio: PulseAudio, PipeWire, wireplumber with `pavucontrol` and GStreamer plugins. 

\- File and disk tools: Thunar with archive plugin, Mousepad, Ristretto, GNOME Disk Utility, Baobab.  

\- Printing: CUPS, system‑config‑printer, cups‑filters. 

\- Theming \& fonts: Arc theme, Papirus icons, Adwaita icons, FiraCode, Hack, Noto (incl. emoji), DejaVu, Liberation fonts.



---



\## 5. Included Browsers



\- Firefox ESR as the default web browser.

\- Brave Browser and Opera from their official repositories with GPG keyrings under `/usr/share/keyrings/` and separate `.list` files in `/etc/apt/sources.list.d/`.



---



\## 6. System Utilities



\- Core CLI tools: `tmux`, `zsh`, `fish`, `fzf`, `ripgrep`, `fd-find`, `bat`, `zoxide`, `btop`, `htop`, `iotop`, `sysstat`, `tree`, `git`, `git-lfs`, `cmake`, `build-essential`, `shellcheck`.  

\- System info helper: `openclawos-info` script in `/usr/local/bin` to show kernel, uptime, resources, and AI service status.

\- Shell configuration  

&nbsp; - Zsh (default for user) with Starship prompt, aliases, zoxide integration, and environment variables for the AI proxy and Ollama host.  

&nbsp; - Bash with a similar setup for users preferring bash.  



---



\## 7. Default Credentials



On the live system (and by default after install):



\- Username: `openclawos`  

\- Password: `openclawos`  

\- The user is in `sudo`, `audio`, `video`, `plugdev`, `netdev`, `cdrom`, `scanner`, and other common groups and has password‑less sudo configured via `/etc/sudoers.d/openclawos`.

You should change the password and adjust sudo privileges after installation.



---



\## 8. Requirements \& Booting



\- Architecture: x86\_64 (amd64) CPU.  

\- RAM: 4 GB minimum recommended for desktop; more for heavy AI workloads.  

\- Boot:  

&nbsp; - Write the ISO to USB using `dd`, `Rufus`, `Balena Etcher`, `Ventoy`, or similar hybrid‑ISO‑compatible tools.

&nbsp; - Boot from USB in BIOS or UEFI mode and choose “Live” from the menu.



---



\## 9. Installation Notes



\- The image is built using Debian live‑build (`lb build`) with the Debian installer in “live” mode, so you can either run it as a live system or install to disk from the menu. 

\- After install you may want to:  

&nbsp; - Set your own user and passwords.  

&nbsp; - Provide API keys (`ANTHROPIC\_API\_KEY`, `OPENAI\_API\_KEY`, `GEMINI\_API\_KEY`, `GROQ\_API\_KEY`, `DEEPSEEK\_API\_KEY`, `LITELLM\_MASTER\_KEY`, etc.) in your environment or `/etc/environment` for full LiteLLM routing.



---



\## 10. Known Issues



\- Some optional npm global packages fail to install due to missing or deprecated modules (e.g. `npm-agentskills`, `wllama`, `brain.js` native build issues). These failures do not prevent the system from functioning but some experimental CLIs may be missing.  

\- During GPU and X stack installation, various `npm` and OpenGL‑related deprecation warnings are printed in the build log; they are cosmetic for most users.

\- To fix: Run the `openclaws\_patch.sh` by placing it into your home dir and open a terminal in the dir that you placed it and run `sed -i 's/\\r//g' openclaws\_patch.sh \&\& chmod +x openclaws\_patch.sh \&\& sudo bash openclaws\_patch.sh`



---



\## 11. Verification



After downloading from SourceForge:



1\. Verify checksum (example):  

&nbsp;  - `sha256sum openclawos-\*.hybrid.iso`  

&nbsp;  - Compare with the `.sha256` file that was generated alongside the ISO in the build output.  

2\. Optionally verify MD5:  

&nbsp;  - `md5sum openclawos-\*.hybrid.iso` and compare with the `.md5` file.



---



\## 12. Feedback \& Contributions



This ISO is built via a single `build.sh` script using Debian live‑build and a series of hooks and package lists located under the `config/` and `confighooks` directories.  

Bug reports, suggestions, and contributions (especially around AI tool choices, security hardening, and desktop polish) are very welcome.



