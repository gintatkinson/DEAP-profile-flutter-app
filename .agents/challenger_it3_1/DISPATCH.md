# Dispatch Task: Gate Iteration 3 — Adversarial Verifier 1 (challenger_it3_1)

## Role & Mission
You are Adversarial Verifier 1 (`challenger_it3_1`). Your working directory is `/Users/perkunas/jail/DEAP01-spec-core/.agents/challenger_it3_1`.
Your mission is to perform adversarial stress-testing on prompt catalog leakage, rule bundle completeness (SHA256 identical), and in-place upgrade detection.

## Verification Scope
1. `DEAP-uas-infrastructure-safety`:
   - Inspect remote `README.md` on `origin/main` commit `06f9e7d`.
   - Run adversarial grep check for `rules/dual-track-mbd-verification.md` and `rules/sysml-ssot-completeness.md`. Confirm ZERO leakage!
   - Verify that Sections 4.5.1 and 4.5.2 explicitly instruct agents to execute `view_file` on `.pipeline/ACTIVE_RULES_BUNDLE.md`.
2. Rule Bundle Integrity:
   - Compare SHA256 of `.pipeline/ACTIVE_RULES_BUNDLE.md` across `DEAP-uas-infrastructure-safety`, `/Users/perkunas/jail/uav-011`, and `/Users/perkunas/jail/uav-009`. Confirm they are byte-for-byte identical (151,317 bytes).
3. Upstream `DEAP01-spec-core/scripts/install_pipeline.sh`:
   - Verify lines 636-655 include tests for `ACTIVE_RULES_BUNDLE.md` and legacy rule references in `SHOULD_SCAFFOLD_README`.
   - Run `python3 -m unittest tests/test_readme_scaffolding.py` to confirm all 27 tests pass.
4. Render an objective verdict: `APPROVE` or `REQUEST_CHANGES`.

## Mandatory Integrity Warning
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A forensic auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected. Commit messages referencing Issue #368 MUST use neutral citations: `(#368)` or `(refs #368)`, never auto-closing keywords like `fixes #368`.

## Output Report
Write your completion report in `/Users/perkunas/jail/DEAP01-spec-core/.agents/challenger_it3_1/handoff.md` and send a message to parent orchestrator.

## 2026-09-25T08:27:08Z
Execute `view_file` on `/Users/perkunas/jail/DEAP01-spec-core/skills/adversarial-code-auditor/SKILL.md` as your very first step before executing any file edits or commands, and strictly follow its formatting templates and instruction guidelines.

Repository Classification: UPSTREAM_SPEC_CORE_COMPILER
Primary Commercial Toolchain Integration Context: MATLAB / Simulink / Stateflow / Embedded Coder

You are Adversarial Verifier 1 (challenger_it3_1). Your working directory is `/Users/perkunas/jail/DEAP01-spec-core/.agents/challenger_it3_1`.
Read your full dispatch instructions in `/Users/perkunas/jail/DEAP01-spec-core/.agents/challenger_it3_1/DISPATCH.md` and read `/Users/perkunas/jail/DEAP01-spec-core/.agents/ORIGINAL_REQUEST.md`.

Your task is to re-challenge prompt catalog leakage, rule bundle completeness, and in-place upgrade detection:
1. `DEAP-uas-infrastructure-safety`:
   - Inspect remote `README.md` (on `origin/main` commit `06f9e7d`).
   - Run adversarial grep check for `rules/dual-track-mbd-verification.md` and `rules/sysml-ssot-completeness.md`. Confirm ZERO leakage!
   - Verify that Sections 4.5.1 and 4.5.2 explicitly instruct agents to execute `view_file` on `.pipeline/ACTIVE_RULES_BUNDLE.md`.
2. Rule Bundle Integrity:
   - Compare SHA256 of `.pipeline/ACTIVE_RULES_BUNDLE.md` across `DEAP-uas-infrastructure-safety`, `/Users/perkunas/jail/uav-011`, and `/Users/perkunas/jail/uav-009`. Confirm byte-for-byte identical (151,317 bytes).
3. Upstream `DEAP01-spec-core/scripts/install_pipeline.sh`:
   - Verify lines 636-655 include tests for `ACTIVE_RULES_BUNDLE.md` and legacy rule references in `SHOULD_SCAFFOLD_README`.
   - Run `python3 -m unittest tests/test_readme_scaffolding.py` to confirm all 27 tests pass.
4. Render an objective verdict: `APPROVE` or `REQUEST_CHANGES`.

