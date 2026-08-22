# DEAP Profile: Flutter Application

> **Repository Role:** `IMPLEMENTATION_PROFILE`  
> **Primary Technology Profiles:** `Flutter Desktop / Web / Mobile` | `Dart`  
> **Primary Commercial Toolchain Integration Context:** MATLAB / Simulink / Stateflow / Embedded Coder  

---

## 1. System Overview

This repository provides the canonical **Flutter Application Implementation Profile** for the Digital Engineering Autonomous Pipeline (DEAP). It supplies downstream application scaffolding, LUI bindings, automated baseline verifiers, and test suites for Flutter-based human-machine interfaces, ground control stations, and telemetry visualization consoles.

### 1.1 Primary Commercial Toolchain Integration Context

This project explicitly declares **MATLAB / Simulink / Stateflow / Embedded Coder** as the Primary Tier-1 Commercial Toolchain Integration Context (Model-Based Design, Control Law Synthesis, DO-178C C/SPARK Ada code generation).

---

## 2. Pipeline Structure & Governance

- `.agents/` & `AGENTS.md`: Agent behavior rules, role boundaries, and subagent dispatch protocols.
- `CLAUDE.md`: Claude Code project guidelines and quality gates.
- `rules/`: Platform engineering rules and LaTeX / KaTeX rendering integrity specifications.
- `schema/`: Schema and specification contracts directory.
- `scripts/`: Pipeline installation (`install_pipeline.sh`, `install_pipeline.py`) and downstream baseline conformance verifier (`verify_downstream_baseline.py`).
- `tests/`: Automated baseline verification and environment integrity test suite.
- `app_flutter/`: Canonical Flutter application implementation workspace and UI shell.

---

## 3. Verification & Quality Gates

Execute baseline verification:

```bash
# Run baseline tests
pytest tests/

# Run downstream conformance gate
python3 scripts/verify_downstream_baseline.py --no-domain
```
