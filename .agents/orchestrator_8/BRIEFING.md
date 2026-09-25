# Orchestrator 8 Briefing: DEAP01-spec-core Defect Remediation & Full-Fleet Downstream Propagation

**Session Timestamp:** 2026-09-25T14:30:00Z  
**Orchestrator ID:** orchestrator_8  
**Parent Sentinel:** 1ea536b6-1e7b-4283-a4d0-66cf8f306dec  
**Repository Classification:** UPSTREAM_SPEC_CORE_COMPILER  
**Primary Commercial Toolchain Integration Context:** MATLAB / Simulink / Stateflow / Embedded Coder  

---

## 1. Context & Executive Directive
This mission orchestrates the remediation of tooling and governance defects in `DEAP01-spec-core`, followed by adversarial audits, tracker issue publication, leaf-level specification grounding in `uav-009`, and full-fleet propagation across all domain distribution templates and customer application workspaces defined in `README.md`.

## 2. Milestone Execution Plan
- **Milestone 1: Fix Issue #363 in DEAP01-spec-core (`scripts/install_pipeline.sh`)**
  - Root Cause: Role detection in `scripts/install_pipeline.sh` (lines 324-342) fails to classify `--domain-url` as `DOMAIN_DISTRIBUTION_TEMPLATE`, omitting the onboarding clone command in `README.md`.
  - Fix: Ensure `[ -n "$DOMAIN_URL" ]` and `[ -n "$DOMAIN_NAME" ]` trigger `DOMAIN_DISTRIBUTION_TEMPLATE` or synthesize domain onboarding commands cleanly.
  - Verification: 9/9 tests pass in `tests/test_domain_url_synthesis.py`.
  - Review Gate: Reviewers and Challengers verify diff and neutral commit citation `(refs #363)`. Push to GitHub `origin/main`.
- **Milestone 2: Adversarial Defect Audits & Tracker Grounding**
  - Audit 1: Governance Ingestion Defect in `README.md` and `docs/OPERATOR_PROMPT_CATALOG.md` -> Post to GitHub `gintatkinson/DEAP01-spec-core`.
  - Audit 2: Single-Provider Tooling Defect in `create_issue.sh` -> Post to GitHub `gintatkinson/DEAP01-spec-core`.
  - Audit 3: Downstream Specification Grounding Defect in `/Users/perkunas/jail/uav-009/docs/` -> Post to GitLab `gintatkinson/uav-009`.
  - Convene Multi-Agent Gate (Reviewers & Challengers) to verify 12 checks + offline Check 7 Mermaid syntax before posting.
  - Update `HANDOFF.md` to `DEAP-HANDOFF-ROOT-004`.
- **Milestone 3: Implementation, Grounding & Full-Fleet Downstream Propagation**
  - Step 1: Fix governance ingestion in `DEAP01-spec-core` (`README.md`, `docs/OPERATOR_PROMPT_CATALOG.md`, `scripts/scaffold_downstream_agents.py`), pass `tests/test_readme_scaffolding.py` (27/27) and Check 14.
  - Step 2: Refactor `create_issue.sh` for dual-provider (`gh` / `glab`) auto-detection and link rewriting. Pass `tests/test_create_issue_dual_provider.py`.
  - Step 3: Deploy to `/Users/perkunas/jail/uav-009`, publish 75 specs via `glab`, run `reconcile_backlog.py --provider gitlab`, replace `#[IssueID]` tokens with live numeric IDs, and pass 30/30 baseline checks.
  - Step 4: Propagate installer to customer workspaces (`uav-011`, `uav-007`, `uav-006`, `uas-003`), pass 30/30 checks and push to GitLab.
  - Step 5: Propagate installer to the 6 Tier 1 domain distribution templates (`DEAP-uas-infrastructure-safety`, `DEAP-surgical-robotics-console`, `DEAP-space-cubesat-constellation`, `DEAP-industrial-warehouse-agv`, `DEAP-subsea-oceanographic-auv`, `DEAP-rail-autonomous-locomotive`) and 4 Profile Repositories (`DEAP-profile-flutter-app`, `DEAP-profile-react-web`, `DEAP-profile-backend-api`, `DEAP-profile-vhdl-hardware`). Preserve clean landing zone invariant (`.gitkeep` only), verify 0-byte remote diffs, and push to GitHub.
- **Milestone 4: Multi-Agent Consensus Gate & Independent Victory Audit**
  - Convene 2 Reviewers, 2 Challengers, and 1 Forensic Auditor for unanimous consensus.
  - Request parent Sentinel to dispatch `teamwork_preview_victory_auditor` for 3-phase audit.
  - Achieve `VICTORY CONFIRMED`.
