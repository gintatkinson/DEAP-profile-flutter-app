## 2026-09-25T00:25:00Z

Execute `view_file` on `/Users/perkunas/jail/DEAP01-spec-core/skills/feature-driven-implementation/SKILL.md` as your very first step before executing any file edits or commands, and strictly follow its formatting templates and instruction guidelines.

Repository Classification: UPSTREAM_SPEC_CORE_COMPILER
Primary Commercial Toolchain Integration Context: MATLAB / Simulink / Stateflow / Embedded Coder

You are the Comprehensive Pipeline Remediation Worker (worker_remediation_all). Your working directory is `/Users/perkunas/jail/DEAP01-spec-core/.agents/worker_remediation_all`.
Read your full dispatch instructions in `/Users/perkunas/jail/DEAP01-spec-core/.agents/worker_remediation_all/DISPATCH.md` and read `/Users/perkunas/jail/DEAP01-spec-core/.agents/ORIGINAL_REQUEST.md`.

Your task is to fix the review findings identified by reviewer_m1_7 and challenger_m1_7, and propagate the verified fixes across DEAP01-spec-core, DEAP-uas-infrastructure-safety, and uav-011.

Detailed Requirements:
1. Fix `scripts/install_pipeline.sh`:
   a) In-place README upgrade detection (around lines 636-646):
      In both `DOMAIN_DISTRIBUTION_TEMPLATE` and `DOWNSTREAM_CUSTOMER_PROJECT` checks, set `SHOULD_SCAFFOLD_README=true` if:
      `! grep -q "ACTIVE_RULES_BUNDLE.md" "$TARGET_DIR/README.md" || grep -q "rules/dual-track-mbd-verification.md" "$TARGET_DIR/README.md"`
   b) Domain README generator (`scaffold_domain_template_readme` around lines 530-610):
      - In Section 2, ensure `.pipeline/` lists `ACTIVE_RULES_BUNDLE.md`, and `rules/` does not single out `rules/sysml-ssot-completeness.md`.
      - In Section 4.5.1 (Worker 2A prompt) and Section 4.5.2 (Worker 2B prompt): mandate reading `.pipeline/ACTIVE_RULES_BUNDLE.md` and purge isolated rule citation `rules/dual-track-mbd-verification.md`.
   c) Customer README generator (`scaffold_customer_project_readme` around lines 768-770):
      - Strip any redundant trailing ` -- Downstream Cyber-Physical Infrastructure Safety Project` from `$DOMAIN_PROJECT_NAME` so the title is clean: `# $DOMAIN_PROJECT_NAME -- Downstream Cyber-Physical Infrastructure Safety Project` without duplication.
2. Run test suites in `DEAP01-spec-core`:
   - `python3 -m unittest tests/test_readme_scaffolding.py` (ensure all tests pass, update or add tests for the new upgrade detection and domain template prompts).
   - `python3 scripts/verify_downstream_baseline.py --no-domain`.
3. Commit and push in `DEAP01-spec-core`:
   - `git add scripts/install_pipeline.sh tests/test_readme_scaffolding.py`
   - `git commit -m "feat(installer): fix in-place README upgrade detection and eliminate isolated rule citations (refs #368)"`
   - `git push origin main`
   - Verify `git diff origin/main` is 0 bytes.
4. Re-propagate to `DEAP-uas-infrastructure-safety`:
   - In a scratch directory outside workspace (e.g. `/tmp/scratch_deap_uas_remediation`):
     - Clone `https://github.com/gintatkinson/DEAP-uas-infrastructure-safety.git`.
     - Run `/Users/perkunas/jail/DEAP01-spec-core/scripts/install_pipeline.sh . --role DOMAIN_DISTRIBUTION_TEMPLATE --domain-url https://github.com/gintatkinson/DEAP-uas-infrastructure-safety.git`.
     - Verify `README.md` Section 2, Section 4.5.1, Section 4.5.2 now mandate `.pipeline/ACTIVE_RULES_BUNDLE.md` and contain ZERO isolated rule references (`rules/dual-track-mbd-verification.md`, `rules/sysml-ssot-completeness.md`).
     - Verify clean landing zones (`docs/epics/`, `docs/features/`, `docs/user-stories/`, `docs/use-cases/` have only `.gitkeep`).
     - Commit: `feat(governance): update prompt catalog to mandate ACTIVE_RULES_BUNDLE.md (refs #368)`
     - Push to `origin/main` on GitHub (`git push origin main`).
     - Verify `git diff origin/main` is 0 bytes.
     - Remove scratch directory.
5. Re-propagate to `uav-011`:
   - Run `/Users/perkunas/jail/DEAP01-spec-core/scripts/install_pipeline.sh /Users/perkunas/jail/uav-011 --provider gitlab`.
   - Verify `README.md` line 1 title has no duplicate suffix.
   - Run `python3 scripts/verify_downstream_baseline.py` in `/Users/perkunas/jail/uav-011`.
   - Commit: `feat(governance): sanitize README title and refresh pipeline (refs #368)`.
   - Push to GitLab `origin/main` (`git push origin main`).
   - Verify `git diff origin/main` is 0 bytes.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected. Commit messages referencing Issue #368 MUST use neutral citations: `(#368)` or `(refs #368)`, never auto-closing keywords like `fixes #368`.

Write your completion report in `/Users/perkunas/jail/DEAP01-spec-core/.agents/worker_remediation_all/handoff.md` and send a message to parent orchestrator.

PROCEED
