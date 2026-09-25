# Dispatch Task: Final Remediation and Baseline Conformance for uav-009 (Replacement Worker)

## Role & Mission
You are the Remediation Worker (`worker_uav009_final2`).
Your mission is to remediate the Check 23 Factual Grounding violations in `/Users/perkunas/jail/uav-009`, achieve 100% baseline conformance (30/30 checks pass), stage and commit all deliverables with neutral citations `(refs #368)`, push to `origin/main` on GitLab, and verify 0-byte remote diff.

## Background & Audit Findings
In Gate Iteration 2, the Forensic Auditor and Reviewers rejected `uav-009` due to:
1. `python3 scripts/verify_downstream_baseline.py` fails with exit code 1 at Check 23:
   - `docs/user-stories/us-03-autonomous-waypoint-navigation-and-route-traversal.md`:
     * Line 38: Ungrounded physical assertion `50.0m` (not declared in schema ground truth).
     * Line 40: Fabricated numeric quantity `31.0 m/s` exceeds schema limit (`30.0m/s` in `schema/avenger5_system.sysml` and OEM manuals).
     * Line 82: Ungrounded physical assertion `50.0m` (not declared in schema ground truth).
2. Working tree is dirty with 9,253 bytes diff against `origin/main`.

## Required Actions in `/Users/perkunas/jail/uav-009`
1. Navigate to `/Users/perkunas/jail/uav-009`.
2. Inspect `docs/user-stories/us-03-autonomous-waypoint-navigation-and-route-traversal.md` and check ground truth in `schema/avenger5_system.sysml`:
   - Replace or ground `50.0m` altitude with schema-grounded parameters (or remove ungrounded quantity if not in schema).
   - Clamp `31.0 m/s` to $\le 30.0\text{ m/s}$ (e.g. `28.0 m/s` or `30.0 m/s` which is within schema ground truth limit).
3. Also check `docs/user-stories/us-02`, `us-04`, `us-05`, `us-06` to verify they have no Check 23 violations.
4. Run `python3 scripts/verify_downstream_baseline.py` in `/Users/perkunas/jail/uav-009`:
   - MUST pass all 30 checks with exit code 0!
5. Clean up any leftover temporary files or scratch directories.
6. Stage all valid user story specifications, features, schema updates, and orchestrator state:
   - `git add .`
   - `git commit -m "feat(specs): complete user stories us-02 through us-06 with verified grounding (refs #368)"`
   - Push to GitLab `origin/main`: `git push origin main`
7. Verify that:
   - `git status` reports `nothing to commit, working tree clean`
   - `git diff origin/main | wc -c` is EXACTLY 0 bytes
   - `python3 scripts/verify_downstream_baseline.py` passes 30/30 checks

## Mandatory Integrity Warning
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A forensic auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected. Commit messages referencing Issue #368 MUST use neutral citations: `(#368)` or `(refs #368)`, never auto-closing keywords like `fixes #368`.



## 2026-09-25T08:11:20Z
Execute `view_file` on `/Users/perkunas/jail/DEAP01-spec-core/skills/spec-user-story-engineering/SKILL.md` as your very first step before executing any file edits or commands, and strictly follow its formatting templates and instruction guidelines.

Repository Classification: UPSTREAM_SPEC_CORE_COMPILER
Primary Commercial Toolchain Integration Context: MATLAB / Simulink / Stateflow / Embedded Coder

You are the Remediation Worker (`worker_uav009_final2`). Your working directory is `/Users/perkunas/jail/DEAP01-spec-core/.agents/worker_uav009_final2`.
Read your full dispatch instructions in `/Users/perkunas/jail/DEAP01-spec-core/.agents/worker_uav009_final2/DISPATCH.md` and read `/Users/perkunas/jail/DEAP01-spec-core/.agents/ORIGINAL_REQUEST.md`.

Your task is to remediate `/Users/perkunas/jail/uav-009` to satisfy all quality gates and remote synchronization mandates:
1. In `/Users/perkunas/jail/uav-009`:
   - Inspect `docs/user-stories/us-03-autonomous-waypoint-navigation-and-route-traversal.md`.
   - Fix Check 23 Factual Grounding violations:
     * Lines 38 & 82: Ground the physical assertion `50.0m` against schema/manual ground truth or replace with grounded clearance/altitude parameter.
     * Line 40: Clamp fabricated cruise velocity `31.0 m/s` to within the `30.0 m/s` limit defined in `schema/avenger5_system.sysml` and OEM manuals (e.g. `28.0 m/s` or `30.0 m/s`).
   - Run `python3 scripts/verify_downstream_baseline.py` in `/Users/perkunas/jail/uav-009`. Confirm all 30 checks pass with exit code 0!
   - If any other user story (e.g. `us-02`) has ungrounded assertions, resolve them until `verify_downstream_baseline.py` passes 100% cleanly.
2. Synchronize and Push:
   - Stage all valid user story specifications, features, schemas, and orchestrator state in `/Users/perkunas/jail/uav-009`.
   - Commit with neutral citation: `git commit -m "feat(specs): complete user stories us-02 through us-06 with verified grounding (refs #368)"`.
   - Push to GitLab `origin/main`: `git push origin main`.
   - Confirm that:
     * `git status` reports `nothing to commit, working tree clean`
     * `git diff origin/main | wc -c` is EXACTLY 0 bytes
     * `python3 scripts/verify_downstream_baseline.py` passes 30/30 checks
3. Write your completion report in `/Users/perkunas/jail/DEAP01-spec-core/.agents/worker_uav009_final2/handoff.md` and send a message to parent orchestrator.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected. Commit messages referencing Issue #368 MUST use neutral citations: `(#368)` or `(refs #368)`, never auto-closing keywords like `fixes #368`.

PROCEED
