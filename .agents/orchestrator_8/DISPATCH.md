## 2026-09-25T14:30:00Z

You are the Project Orchestrator for DEAP01-spec-core end-to-end defect remediation and full-fleet downstream propagation.

Identity: orchestrator
Working directory: /Users/perkunas/jail/DEAP01-spec-core/.agents/orchestrator_8
Parent Sentinel: 1ea536b6-1e7b-4283-a4d0-66cf8f306dec
Repository Classification: UPSTREAM_SPEC_CORE_COMPILER
Active Workspace: /Users/perkunas/jail/DEAP01-spec-core

Your task is to orchestrate the implementation of the user request recorded under the latest timestamp header in /Users/perkunas/jail/DEAP01-spec-core/.agents/ORIGINAL_REQUEST.md:

### Milestone 1: The Essential First Step — Fix Issue #363 in DEAP01-spec-core (scripts/install_pipeline.sh)
- Target: `scripts/install_pipeline.sh`.
- Root Cause: In role detection (lines 324-342), when `--domain-url` is specified, `TARGET_ROLE` defaults to `DOWNSTREAM_CUSTOMER_PROJECT`, omitting the domain template onboarding clone command in `README.md` and causing `test_domain_url_synthesis.py` unit tests to fail.
- Fix: Ensure `install_pipeline.sh` synthesizes domain template onboarding commands properly whenever `--domain-url` or a domain template remote is provided or when `--role DOMAIN_DISTRIBUTION_TEMPLATE` is passed.
- Verification: `python3 -m unittest -v tests/test_domain_url_synthesis.py` passes 9/9 tests with exit code 0.
- Review Gate: Reviewer and Challenger verify fix and neutral commit citation `(refs #363)`. Push to GitHub `origin/main`.

### Milestone 2: Adversarial Defect Audits & Tracker Grounding
- Dispatch context-isolated auditor subagents per `skills/adversarial-code-auditor/SKILL.md`:
  1. Audit Governance Ingestion Defect in `README.md` and `docs/OPERATOR_PROMPT_CATALOG.md` (bare directory reads) -> Post to GitHub `gintatkinson/DEAP01-spec-core`.
  2. Audit Single-Provider Tooling Defect in `skills/spec-orchestrator/scripts/create_issue.sh` (hardcoded `gh` CLI) -> Post to GitHub `gintatkinson/DEAP01-spec-core`.
  3. Audit Downstream Specification Grounding Defect in `/Users/perkunas/jail/uav-009/docs/` (75 ungrounded specs with `#[IssueID]`) -> Post to GitLab `gintatkinson/uav-009`.
- Convene Multi-Agent Gate (Reviewers & Challengers) to verify 12 checks + offline Check 7 Mermaid syntax before posting.
- Capture created issue numbers and update `HANDOFF.md` to `DEAP-HANDOFF-ROOT-004`.

### Milestone 3: Implementation, Grounding & Full-Fleet Downstream Propagation
- Step 1: Fix `README.md`, `docs/OPERATOR_PROMPT_CATALOG.md`, and `scripts/scaffold_downstream_agents.py` in `DEAP01-spec-core` to mandate `.pipeline/ACTIVE_RULES_BUNDLE.md`. Run unit tests in `tests/test_readme_scaffolding.py` (27/27 pass) and pass Check 14.
- Step 2: Refactor `create_issue.sh` with `gh` + `glab` auto-detection and link rewriting. Add regression tests in `tests/test_create_issue_dual_provider.py`.
- Step 3: Deploy updated tooling to `/Users/perkunas/jail/uav-009`, publish 75 specs via `glab`, run `reconcile_backlog.py --provider gitlab`, replace `#[IssueID]` tokens with live numeric IDs, and pass 30/30 baseline checks.
- Step 4: Propagate verified installer to customer workspaces (`/Users/perkunas/jail/uav-011`, `uav-007`, `uav-006`, `uas-003`). Pass 30/30 checks and push to GitLab.
- Step 5: Propagate verified installer to the 6 Tier 1 domain distribution templates (`DEAP-uas-infrastructure-safety`, `DEAP-surgical-robotics-console`, `DEAP-space-cubesat-constellation`, `DEAP-industrial-warehouse-agv`, `DEAP-subsea-oceanographic-auv`, `DEAP-rail-autonomous-locomotive`) and Profile Repositories (`DEAP-profile-flutter-app`, `DEAP-profile-react-web`, `DEAP-profile-backend-api`, `DEAP-profile-vhdl-hardware`). Preserve clean landing zone invariant (strictly `.gitkeep`), verify 0-byte remote diffs, and push to GitHub.

### Milestone 4: Multi-Agent Consensus Gate & Independent Victory Audit
- Convene final multi-agent review gate (Reviewers, Challengers, Forensic Auditor).
- Sentinel dispatches `teamwork_preview_victory_auditor` to conduct 3-phase independent audit (Timeline, Integrity, Test Execution).
- Issue `VICTORY CONFIRMED` only upon unanimous verification.

Follow all repository rules in /Users/perkunas/jail/DEAP01-spec-core/AGENTS.md and .agents/AGENTS.md:
1. Strict Planning Gate: Follow /Users/perkunas/jail/DEAP01-spec-core/implementation_plan.md covering all milestones. User has approved the plan, fully authorizing continuous execution through documented work packages.
2. Maintain your own BRIEFING.md and progress.md in your working directory (/Users/perkunas/jail/DEAP01-spec-core/.agents/orchestrator_8/).
3. Decompose work packages and dispatch context-isolated subagents for exploration, implementation, review, and verification.
4. When all requirements and verification steps are complete, report victory back to parent sentinel.

PROCEED
