## 2026-09-25T00:17:00Z

Execute `view_file` on `/Users/perkunas/jail/DEAP01-spec-core/skills/adversarial-code-auditor/SKILL.md` as your very first step before executing any file edits or commands, and strictly follow its formatting templates and instruction guidelines.

Repository Classification: UPSTREAM_SPEC_CORE_COMPILER
Primary Commercial Toolchain Integration Context: MATLAB / Simulink / Stateflow / Embedded Coder

You are Code Reviewer 2 (reviewer_m2_7). Your working directory is `/Users/perkunas/jail/DEAP01-spec-core/.agents/reviewer_m2_7`.
Read your full dispatch instructions in `/Users/perkunas/jail/DEAP01-spec-core/.agents/reviewer_m2_7/DISPATCH.md` and read `/Users/perkunas/jail/DEAP01-spec-core/.agents/ORIGINAL_REQUEST.md`.

Your task is to independently review invariants, non-circularity, and baseline verification across all three downstream targets:
1. `DEAP-uas-infrastructure-safety` (`https://github.com/gintatkinson/DEAP-uas-infrastructure-safety.git`)
2. `uav-011` (`/Users/perkunas/jail/uav-011`)
3. `uav-009` (`/Users/perkunas/jail/uav-009`)

Detailed Review Scope:
1. Domain Distribution Template Clean Landing Zone Invariant:
   - Verify that `DEAP-uas-infrastructure-safety` landing zones (`docs/epics/`, `docs/features/`, `docs/user-stories/`, `docs/use-cases/`) maintain only `.gitkeep`.
   - Verify that the documented customer onboarding command in `DEAP-uas-infrastructure-safety/README.md` uses its own remote URL (`git clone https://github.com/gintatkinson/DEAP-uas-infrastructure-safety.git ./.tmp-pipeline ...`) and operates cleanly in the customer repo.
2. Non-circular Customer READMEs:
   - Verify that `/Users/perkunas/jail/uav-011/README.md` and `/Users/perkunas/jail/uav-009/README.md` contain zero circular clone commands (no instructions telling customers to clone uav-011 or uav-009 to install pipelines into themselves).
3. Baseline Conformance Verification:
   - Run `python3 scripts/verify_downstream_baseline.py` in `/Users/perkunas/jail/uav-011` and `/Users/perkunas/jail/uav-009`. Confirm all baseline checks pass cleanly with exit code 0.
4. Render an objective verdict: `APPROVE` or `REQUEST_CHANGES`.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected. Commit messages referencing Issue #368 MUST use neutral citations: `(#368)` or `(refs #368)`, never auto-closing keywords like `fixes #368`.

Write your completion report in `/Users/perkunas/jail/DEAP01-spec-core/.agents/reviewer_m2_7/handoff.md`, detailing your findings, verification evidence, and explicit verdict (`APPROVE` or `REQUEST_CHANGES`). Send a message to parent orchestrator when complete.

PROCEED
