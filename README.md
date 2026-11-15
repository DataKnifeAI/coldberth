# Coldberth

![Coldberth — Hermes Agent + vLLM Linux setup](docs/assets/coldberth-hero.jpg)


**Coldberth — a cold dock berth for local inference.** One-script Linux setup for [Hermes Agent](https://github.com/NousResearch/hermes-agent) on **your GPU** via [vLLM](https://github.com/vllm-project/vllm).

Formerly **enodios**. CLI and data dir are now `coldberth` / `~/.local/share/coldberth` (re-run install after pull).

Local inference. Fast tool calling. No cloud API keys.

**Documentation:** https://dataknifeai.github.io/coldberth/

---

## Overview

Coldberth installs vLLM, tunes it for Hermes 3 (64k context, tool parser), and wires Hermes to `http://127.0.0.1:8000/v1`.

**Install order:** Coldberth → start vLLM → Hermes Agent → `hermes setup`.

Default model: `solidrust/Hermes-3-Llama-3.1-8B-AWQ` served as `hermes3:8b` (~20GB VRAM @ 64k on a 4090).

**More:** [Advanced setup & reference](docs/advanced.md) — wizard walkthrough, distributed Hermes, tuning, troubleshooting.

---

## Quick start

```bash
# 1. Coldberth + vLLM
curl -fsSL https://raw.githubusercontent.com/DataKnifeAI/coldberth/main/install.sh | bash
coldberth recommend --apply && source ~/.local/share/coldberth/recommended.env
coldberth start -b && coldberth bench

# 2. Hermes (after vLLM is up)
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
hermes setup    # Full setup → Inference Provider → Custom endpoint
# URL: http://127.0.0.1:8000/v1  model: hermes3:8b  context: 65536

# Or skip wizard:
coldberth configure && hermes chat

# Free GPU for games / heavy tasks:
coldberth stop      # resume: coldberth start -b
```

**Update:** `coldberth update`

---

## Commands

| Command | Description |
|---------|-------------|
| `coldberth deps` | Check OS GPU deps (apt/dnf/yum/zypper/pacman); `--install` |
| `coldberth install` | OS deps check + venv + vLLM + CLI link |
| `coldberth update` | git pull + upgrade vLLM |
| `coldberth recommend` | GPU → model/settings (`--apply` to save) |
| `coldberth start -b` | Background vLLM (loopback) |
| `coldberth start --lan` | Expose on LAN for remote Hermes |
| `coldberth stop` / `pause` | Free GPU VRAM |
| `coldberth configure` | Wire Hermes to local vLLM |
| `coldberth configure --url URL` | Wire Hermes to remote vLLM |
| `coldberth firewall` | Check / allow port 8000 (`--allow`) |
| `coldberth urls` | Local + LAN API URLs |
| `coldberth status` | `/v1/models` + URLs |
| `coldberth bench` | Tool-call smoke test |
| `coldberth doctor` | GPU, venv, endpoint health |
| `coldberth help` | Full CLI help |

---

## Architecture

**Same machine (default):**

```mermaid
flowchart LR
  U[You] --> H[Hermes Agent]
  H -->|127.0.0.1:8000/v1| V[vLLM]
  V --> G[NVIDIA GPU]
  H --> T[Tools]
```

**Distributed** — see [advanced guide](docs/advanced.md#distributed-hermes):

```mermaid
flowchart LR
  U[You] --> C[Controller Hermes]
  C -->|LAN :8000/v1| V[vLLM GPU host]
  V --> G[NVIDIA GPU]
```

**Orchestrator + sub-agents** — see [advanced guide](docs/advanced.md#orchestrator--sub-agents):

```mermaid
flowchart TB
  U[You] --> O[Hermes Orchestrator]
  O -->|delegate| C1[Client Hermes]
  O -->|delegate| C2[Client Hermes]
  O -->|delegate| C3[Client Hermes]
  O -->|plan :8000/v1| VO[vLLM]
  C1 -->|infer| V[vLLM via Coldberth]
  C2 -->|infer| V
  C3 -->|infer| V
  C1 --> T1[Sub-task tools]
  C2 --> T2[Sub-task tools]
  C3 --> T3[Sub-task tools]
  VO --> G[NVIDIA GPU hosts]
  V --> G
```

---

## License

MIT — see [LICENSE](LICENSE).
