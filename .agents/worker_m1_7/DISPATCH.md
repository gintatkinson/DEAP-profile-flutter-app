## 2026-09-24T23:45:00Z

Execute `view_file` on `/Users/perkunas/jail/DEAP01-spec-core/skills/feature-driven-implementation/SKILL.md` as your very first step before executing any file edits or commands, and strictly follow its formatting templates and instruction guidelines.

Repository Classification: UPSTREAM_SPEC_CORE_COMPILER
Primary Commercial Toolchain Integration Context: MATLAB / Simulink / Stateflow / Embedded Coder

You are the Domain Template Propagation Worker (worker_m1_7). Your working directory is `/Users/perkunas/jail/DEAP01-spec-core/.agents/worker_m1_7`.
Your task is to propagate updated DEAP pipeline tooling and active governance rule bundle to the Domain Distribution Template (`DEAP-uas-infrastructure-safety`).

Scope & Instructions:
1. In a temporary scratch directory outside the workspace (e.g. `/tmp/scratch_deap_uas_safety`):
   - Ensure the directory is clean (`rm -rf /tmp/scratch_deap_uas_safety && mkdir -p /tmp/scratch_deap_uas_safety`).
   - Clone `https://github.com/gintatkinson/DEAP-uas-infrastructure-safety.git` into `/tmp/scratch_deap_uas_safety`.
2. Inside `/tmp/scratch_deap_uas_safety`:
   - Execute `/Users/perkunas/jail/DEAP01-spec-core/scripts/install_pipeline.sh . --role DOMAIN_DISTRIBUTION_TEMPLATE --domain-url https://github.com/gintatkinson/DEAP-uas-infrastructure-safety.git`.
3. Verification checks inside `/tmp/scratch_deap_uas_safety`:
   - Verify `.pipeline/ACTIVE_RULES_BUNDLE.md` exists and is compiled with 100% of active rules from `/Users/perkunas/jail/DEAP01-spec-core/rules/*.md` (verify rule count and TOC).
   - Verify clean landing zone invariant: `schema/`, `docs/epics/`, `docs/features/`, `docs/user-stories/`, and `docs/use-cases/` contain only `.gitkeep`.
   - Verify `README.md` contains the canonical non-circular onboarding command:
     `git clone https://github.com/gintatkinson/DEAP-uas-infrastructure-safety.git ./.tmp-pipeline && bash ./.tmp-pipeline/scripts/install_pipeline.sh . && rm -rf ./.tmp-pipeline`
   - Run `python3 scripts/verify_downstream_baseline.py` inside `/tmp/scratch_deap_uas_safety` if present, ensuring baseline checks pass.
4. Git commit and push:
   - Check `git status` and `git diff`.
   - Stage all updated files (`git add -A`).
   - Commit: `git commit -m "feat(governance): bundle active governance rules into ACTIVE_RULES_BUNDLE.md (refs #368)"`.
   - Push to `origin/main` on GitHub (`git push origin main`).
   - Verify `git diff origin/main` is completely empty.
5. Cleanup:
   - Remove scratch directory `/tmp/scratch_deap_uas_safety` after confirming clean push.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected. Commit messages referencing Issue #368 MUST use neutral citations: `(#368)` or `(refs #368)`, never auto-closing keywords like `fixes #368`.

Write your completion report in `/Users/perkunas/jail/DEAP01-spec-core/.agents/worker_m1_7/handoff.md`, detailing all executed commands, verification results, git commit hash, and push confirmation. Send a message to parent orchestrator when complete.

PROCEED
