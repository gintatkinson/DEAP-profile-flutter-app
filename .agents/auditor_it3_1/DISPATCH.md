# Dispatch Task: Gate Iteration 3 — Forensic Integrity Auditor (auditor_it3_1)

## Role & Mission
You are the Forensic Integrity Auditor (`auditor_it3_1`). Your working directory is `/Users/perkunas/jail/DEAP01-spec-core/.agents/auditor_it3_1`.
Your mission is to perform an exhaustive, independent forensic integrity audit across all four repositories: `DEAP-uas-infrastructure-safety`, `/Users/perkunas/jail/uav-011`, `/Users/perkunas/jail/uav-009`, and `DEAP01-spec-core`.

## Mandatory Forensic Checks
1. Check 1: Anti-Facade / Anti-Mocking (`.pipeline/ACTIVE_RULES_BUNDLE.md`):
   - Compare SHA256 across all targets (must match `a99dad5c07c3eb570a2c99aa08ccd070b277f30f3d7eb57882d40c3ef668931d`, 151,317 bytes, 100% full text of all 20 rules).
   - Verify downstream README prompt catalogs mandate reading this file with zero isolated rule subsets.
2. Check 2: Commit Message Non-Closure Invariant:
   - Audit commit history across all 4 repositories for commits referencing `#368`.
   - Verify every commit strictly uses neutral citations `(refs #368)` or `(#368)`.
   - Verify ZERO auto-closing keywords (`fix`, `fixes`, `close`, `closes`, `resolve`, `resolves`).
3. Check 3: Clean Remote Tracking & Clean Landing Zones:
   - Verify clean landing zones in `DEAP-uas-infrastructure-safety` (`docs/epics/`, `docs/features/`, `docs/user-stories/`, `docs/use-cases/` contain strictly `.gitkeep`).
   - Run `git diff origin/main | wc -c` across `DEAP-uas-infrastructure-safety`, `uav-011`, and `uav-009`. Confirm it is EXACTLY 0 bytes across all three!
   - Run `python3 scripts/verify_downstream_baseline.py` in both `uav-011` and `uav-009`. Confirm exit code 0.
4. Render an objective verdict: `CLEAN` or `INTEGRITY VIOLATION`.

## Mandatory Integrity Warning
DO NOT CHEAT. All implementations must be genuine. Trust NOTHING — verify EVERYTHING. A CLEAN verdict means 100% conformance across all checks. Any failure requires an immediate INTEGRITY VIOLATION verdict.

## Output Report
Write your completion report in `/Users/perkunas/jail/DEAP01-spec-core/.agents/auditor_it3_1/handoff.md` and send a message to parent orchestrator.

## 2026-09-25T05:27:08Z
Execute `view_file` on `/Users/perkunas/jail/DEAP01-spec-core/skills/adversarial-code-auditor/SKILL.md` as your very first step before executing any file edits or commands, and strictly follow its formatting templates and instruction guidelines.

Repository Classification: UPSTREAM_SPEC_CORE_COMPILER
Primary Commercial Toolchain Integration Context: MATLAB / Simulink / Stateflow / Embedded Coder

You are the Forensic Integrity Auditor (auditor_it3_1). Your working directory is `/Users/perkunas/jail/DEAP01-spec-core/.agents/auditor_it3_1`.
Read your full dispatch instructions in `/Users/perkunas/jail/DEAP01-spec-core/.agents/auditor_it3_1/DISPATCH.md` and read `/Users/perkunas/jail/DEAP01-spec-core/.agents/ORIGINAL_REQUEST.md`.

Your task is to conduct an independent, exhaustive forensic integrity audit across all four repositories:
1. Check 1 (Anti-Facade / Anti-Mocking):
   - Compare SHA256 of `.pipeline/ACTIVE_RULES_BUNDLE.md` across all targets (must match `a99dad5c07c3eb570a2c99aa08ccd070b277f30f3d7eb57882d40c3ef668931d`, 151,317 bytes, 100% full text of all 20 rules).
   - Verify downstream README prompt catalogs mandate reading this file with zero isolated rule subsets.
2. Check 2 (Commit Message Non-Closure Invariant):
   - Audit commit history across all 4 repositories for commits referencing `#368`.
   - Verify every commit strictly uses neutral citations `(refs #368)` or `(#368)`.
   - Verify ZERO auto-closing keywords (`fix`, `fixes`, `close`, `closes`, `resolve`, `resolves`).
3. Check 3 (Clean Remote Tracking & Clean Landing Zones):
   - Verify clean landing zones in `DEAP-uas-infrastructure-safety` (`docs/epics/`, `docs/features/`, `docs/user-stories/`, `docs/use-cases/` contain strictly `.gitkeep`).
   - Run `git diff origin/main | wc -c` across `DEAP-uas-infrastructure-safety`, `uav-011`, and `uav-009`. Confirm it is EXACTLY 0 bytes across all three!
   - Run `python3 scripts/verify_downstream_baseline.py` in both `uav-011` and `uav-009`. Confirm exit code 0.
4. Render an objective verdict: `CLEAN` or `INTEGRITY VIOLATION`.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. Trust NOTHING — verify EVERYTHING. A CLEAN verdict means 100% conformance across all checks. Any failure requires an immediate INTEGRITY VIOLATION verdict.

Write your completion report in `/Users/perkunas/jail/DEAP01-spec-core/.agents/auditor_it3_1/handoff.md` and send a message to parent orchestrator.

PROCEED

