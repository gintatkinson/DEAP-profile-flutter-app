# Adversarial Challenge & Verification Report (challenger_m1_7)

**Evaluator Role:** Adversarial Verifier 1 (`challenger_m1_7`)  
**Targets Audited:**
1. `uav-011` (`/Users/perkunas/jail/uav-011`)
2. `uav-009` (`/Users/perkunas/jail/uav-009`)
3. `DEAP-uas-infrastructure-safety` (`https://github.com/gintatkinson/DEAP-uas-infrastructure-safety.git`)

**Verdict:** `REQUEST_CHANGES`

---

## 1. Observation

### 1.1 Master Rule Set Inventory
- Master rules location: `/Users/perkunas/jail/DEAP01-spec-core/rules/*.md`.
- Total active markdown rules: Exactly 20 files (144,383 bytes aggregate body text):
  1. `behavioral-trigger-coverage.md` (3,036 bytes)
  2. `codebase-compliance.md` (6,219 bytes)
  3. `conops-mission-intent-integrity.md` (18,692 bytes)
  4. `constitution-first.md` (2,385 bytes)
  5. `document-references.md` (6,553 bytes)
  6. `domain-engineering-standards.md` (4,234 bytes)
  7. `dual-track-mbd-verification.md` (8,992 bytes)
  8. `latex-katex-integrity.md` (7,537 bytes)
  9. `no-browser-automation.md` (1,301 bytes)
  10. `platform-independence.md` (15,040 bytes)
  11. `role-boundary-lock.md` (3,267 bytes)
  12. `serial-execution.md` (863 bytes)
  13. `specification-metadata-integrity.md` (9,208 bytes)
  14. `subagent-dispatch-standards.md` (4,191 bytes)
  15. `sysml-ssot-completeness.md` (16,475 bytes)
  16. `tdd-mandate.md` (3,773 bytes)
  17. `tracker-source-of-truth.md` (9,331 bytes)
  18. `uml-model-integrity.md` (16,988 bytes)
  19. `user-authorization-lock.md` (6,036 bytes)
  20. `verification-required.md` (1,144 bytes)
- In addition, `rules/behavioral_triggers.json` (1,070 bytes) exists as a data fixture cited by `behavioral-trigger-coverage.md`.

### 1.2 Target 1: `uav-011` (`/Users/perkunas/jail/uav-011`)
- **Bundle Verification (`.pipeline/ACTIVE_RULES_BUNDLE.md`):**
  - File exists, size: 151,317 bytes (1,849 lines).
  - Rule count & body parity: 20/20 rules present verbatim. 100% byte-for-byte exact character match. Zero truncation, zero stubbing.
  - TOC and anchor integrity: 20 TOC links resolve to valid HTML anchors. All 4 alias anchors per rule (80 total) are declared and functional.
- **Prompt Catalog Leakage (`README.md`):**
  - References to `.pipeline/ACTIVE_RULES_BUNDLE.md`: 4 instances (lines 27, 73, 473, 505).
  - Bare `rules/` instructions: 0.
  - Isolated rule subset citations: 0.
  - Circular clone commands: 0.
- **Git Synchronization & Hygiene:**
  - Branch: `main`, tracking `origin/main` on GitLab (`https://gitlab.com/gintatkinson/uav-011.git`).
  - Latest commit: `078bbe8` (`feat(governance): bundle active governance rules into ACTIVE_RULES_BUNDLE.md (refs #368)`).
  - Neutral citation verified: contains `(refs #368)`, zero auto-closing keywords (`fixes`, `closes`, `resolves`).
  - `git diff origin/main`: completely empty. Working tree clean.
- **Conformance Gate:**
  - `python3 scripts/verify_downstream_baseline.py` exits 0 (all 30 baseline checks verified).

### 1.3 Target 2: `uav-009` (`/Users/perkunas/jail/uav-009`)
- **Bundle Verification (`.pipeline/ACTIVE_RULES_BUNDLE.md`):**
  - File exists, size: 151,317 bytes (1,849 lines).
  - Rule count & body parity: 20/20 rules present verbatim. 100% byte-for-byte exact character match. Zero truncation, zero stubbing.
  - TOC and anchor integrity: 20 TOC links resolve to valid HTML anchors. All 4 alias anchors per rule (80 total) are declared and functional.
- **Prompt Catalog Leakage (`README.md`):**
  - References to `.pipeline/ACTIVE_RULES_BUNDLE.md`: 4 instances (lines 27, 73, 473, 505).
  - Bare `rules/` instructions: 0.
  - Isolated rule subset citations: 0.
  - Circular clone commands: 0.
- **Git Synchronization & Hygiene:**
  - Branch: `main`, tracking `origin/main` on GitLab (`https://gitlab.com/gintatkinson/uav-009.git`).
  - Relevant commit: `1f23257` (`feat(governance): bundle active governance rules into ACTIVE_RULES_BUNDLE.md (refs #368)`).
  - Neutral citation verified: contains `(refs #368)`, zero auto-closing keywords.
  - `git diff origin/main -- . ':(exclude).agents'`: completely empty (tracked repository files clean and synchronized).
- **Conformance Gate:**
  - `python3 scripts/verify_downstream_baseline.py` exits 0 (all 30 baseline checks verified).

### 1.4 Target 3: `DEAP-uas-infrastructure-safety` (`https://github.com/gintatkinson/DEAP-uas-infrastructure-safety.git`)
- Cloned to fresh directory `/tmp/check_deap_uas_safety` at commit `c2980b8`.
- **Bundle Verification (`.pipeline/ACTIVE_RULES_BUNDLE.md`):**
  - File exists, size: 151,317 bytes (1,849 lines).
  - Rule count & body parity: 20/20 rules present verbatim. 100% byte-for-byte exact character match. Zero truncation, zero stubbing.
  - TOC and anchor integrity: 20 TOC links resolve to valid HTML anchors. All 4 alias anchors per rule (80 total) are declared and functional.
- **Prompt Catalog Leakage (`README.md`): FAIL**
  - **Defect 1 (Isolated Rule Leakage in Operator Prompt Catalog):**
    `README.md:495`:
    ```text
    Governance Preamble & Execution Directive:
    Adopt the feature-driven-implementation skill by reading `.pipeline/constitution.md`, `rules/dual-track-mbd-verification.md`, and `docs/architecture/blueprints/SYSML_SSOT_BIDIRECTIONAL_SYNCHRONIZATION_ARCHITECTURE.md`.
    ```
    This directs autonomous subagents to ingest an isolated rule file (`rules/dual-track-mbd-verification.md`) rather than the mandatory consolidated bundle (`.pipeline/ACTIVE_RULES_BUNDLE.md`).
  - **Defect 2 (Isolated Rule Inconsistency in Section 2):**
    `README.md:28`:
    ```text
    - `rules/` & `skills/`: Platform engineering rules and agent workflow skills (including SysML v2 SSOT completeness in `rules/sysml-ssot-completeness.md`).
    ```
    This singles out `rules/sysml-ssot-completeness.md`, contradicting the single-manifest governance architecture.
  - **Defect 3 (Missing Bundle Entry in Section 2 Overview):**
    `README.md:27`:
    ```text
    - `.pipeline/`: Constitution (`constitution.md`), domain specifications, and execution profiles (`profiles/ros2_cpp.md`, `profiles/px4_module.md`).
    ```
    Unlike `uav-011` and `uav-009`, this line fails to document `ACTIVE_RULES_BUNDLE.md` in the pipeline structure overview.
  - **Root Cause in `scripts/install_pipeline.sh:636-640`:**
    ```bash
    elif [ "$TARGET_ROLE" = "DOMAIN_DISTRIBUTION_TEMPLATE" ]; then
      if ! grep -qE "Customer Project Onboarding|\.tmp-pipeline" "$TARGET_DIR/README.md" || \
         ! grep -qE "DOMAIN_DISTRIBUTION_TEMPLATE" "$TARGET_DIR/README.md"; then
        SHOULD_SCAFFOLD_README=true
      fi
    ```
    When `install_pipeline.sh` was run against `DEAP-uas-infrastructure-safety`, `README.md` already contained `Customer Project Onboarding` and `DOMAIN_DISTRIBUTION_TEMPLATE`. The condition did not check whether `ACTIVE_RULES_BUNDLE.md` was present in `README.md`. As a result, `SHOULD_SCAFFOLD_README` remained `false`, and `install_pipeline.sh` skipped updating `README.md`. Worker `worker_m1_7` only manually patched line 63 of `README.md`, leaving lines 27, 28, and 495 stale.

---

## 2. Logic Chain

1. **Issue #368 Goal:** Eliminate token-conservation shortcuts and rule omissions by providing a single consolidated governance manifest (`.pipeline/ACTIVE_RULES_BUNDLE.md`) and ensuring that operator prompt catalogs across all tiers direct autonomous agents to ingest that bundle in a single read.
2. **Empirical Evidence on Rule Bundling:**
   - In all three repositories (`uav-011`, `uav-009`, and `DEAP-uas-infrastructure-safety`), `.pipeline/ACTIVE_RULES_BUNDLE.md` was compiled and verified to contain 100% of all 20 active markdown rule files.
   - Byte-level comparison confirmed zero truncation and zero stubbing.
   - TOC anchor resolution was verified: all 20 entries point to existing HTML anchor tags with 4 alias slugs each.
3. **Empirical Evidence on Customer Workspaces:**
   - `uav-011` and `uav-009` successfully regenerated their README files during installation.
   - Their prompt catalogs in Sections 3.3 and 4 exclusively direct agents to `.pipeline/ACTIVE_RULES_BUNDLE.md`, contain zero bare `rules/` instructions, and contain zero circular clone commands.
4. **Empirical Evidence on Domain Distribution Template:**
   - In `DEAP-uas-infrastructure-safety`, `README.md` at line 495 still instructs subagents:
     `Adopt the feature-driven-implementation skill by reading .pipeline/constitution.md, rules/dual-track-mbd-verification.md, and ...`
   - This directly violates Check 3 ("Search `README.md` across all target repos to ensure there are no lingering bare `rules/` instructions or instructions pointing to isolated rule subsets").
   - Furthermore, the root cause lies in `scripts/install_pipeline.sh`'s `SHOULD_SCAFFOLD_README` gate for `DOMAIN_DISTRIBUTION_TEMPLATE`, which fails to trigger README updates on existing domain distribution templates that lack `ACTIVE_RULES_BUNDLE.md` in their prompt catalog.
5. **Conclusion from Logic Chain:**
   Because prompt catalog leakage exists in a production target repository (`DEAP-uas-infrastructure-safety`), the overall task cannot be approved until this leakage and the installer update trigger are corrected and propagated.

---

## 3. Caveats

- `DEAP01-spec-core/README.md` also contains legacy references to `rules/dual-track-mbd-verification.md` at line 1025 and bare `rules/` references at lines 301, 311, and 326. While `DEAP01-spec-core` is the upstream compiler (not a customer workspace or domain template), maintainers should consider updating compiler prompt templates to reference `.pipeline/ACTIVE_RULES_BUNDLE.md` for consistency once compiled upstream.
- Worker `worker_m1_7` stated in its handoff that the bundle contained "21 governance rules (20 markdown rule files + behavioral_triggers.json)". In fact, `install_pipeline.sh` bundles only `*.md` files (20 rules); `behavioral_triggers.json` is a referenced data fixture. This discrepancy was audited and confirmed harmless to bundle completeness since all 20 markdown rules are present.
- In `uav-009`, dirty files exist under `.agents/orchestrator_4/` due to a concurrent user story orchestration subagent session. These are uncommitted agent metadata only; all repository source files, specs, and rules are cleanly committed and pushed to `origin/main`.

---

## 4. Conclusion & Verdict

**VERDICT: REQUEST_CHANGES**

### Required Remediations Before Approval:
1. **Update `scripts/install_pipeline.sh`:**
   In line 636-640, update the `SHOULD_SCAFFOLD_README` check for `DOMAIN_DISTRIBUTION_TEMPLATE` to also detect missing `ACTIVE_RULES_BUNDLE.md` or lingering `rules/dual-track-mbd-verification.md`:
   ```bash
   elif [ "$TARGET_ROLE" = "DOMAIN_DISTRIBUTION_TEMPLATE" ]; then
     if ! grep -qE "Customer Project Onboarding|\.tmp-pipeline" "$TARGET_DIR/README.md" || \
        ! grep -qE "DOMAIN_DISTRIBUTION_TEMPLATE" "$TARGET_DIR/README.md" || \
        ! grep -qE "ACTIVE_RULES_BUNDLE\.md" "$TARGET_DIR/README.md" || \
        grep -qE "rules/dual-track-mbd-verification\.md" "$TARGET_DIR/README.md"; then
       SHOULD_SCAFFOLD_README=true
     fi
   ```
2. **Re-scaffold and Synchronize `DEAP-uas-infrastructure-safety`:**
   - Run `install_pipeline.sh` against `DEAP-uas-infrastructure-safety` with the updated installer (or overwrite `README.md` with the clean domain template scaffolding).
   - Verify that `README.md` line 495 references `.pipeline/ACTIVE_RULES_BUNDLE.md` instead of `rules/dual-track-mbd-verification.md`.
   - Verify that line 28 does not single out `rules/sysml-ssot-completeness.md` and line 27 includes `ACTIVE_RULES_BUNDLE.md`.
   - Commit with neutral citation `feat(governance): eliminate prompt catalog leakage in README.md (refs #368)` and push to `origin/main` on GitHub.
3. **Re-verify `git diff origin/main` is clean on GitHub for `DEAP-uas-infrastructure-safety`.**

---

## 5. Verification Method

To independently reproduce and verify this finding:

```bash
# 1. Clone DEAP-uas-infrastructure-safety
rm -rf /tmp/reproduce_leakage && git clone --depth 1 https://github.com/gintatkinson/DEAP-uas-infrastructure-safety.git /tmp/reproduce_leakage

# 2. Check for isolated rule prompt leakage in README.md
grep -n "rules/dual-track-mbd-verification.md" /tmp/reproduce_leakage/README.md
# Expected finding: Line 495 leaks 'rules/dual-track-mbd-verification.md'

# 3. Check for single-rule highlight in Section 2
grep -n "rules/sysml-ssot-completeness.md" /tmp/reproduce_leakage/README.md
# Expected finding: Line 28 leaks 'rules/sysml-ssot-completeness.md'

# 4. Check for rule bundle completeness across all targets
python3 -c "
import glob, os
rules = glob.glob('/Users/perkunas/jail/DEAP01-spec-core/rules/*.md')
for repo in ['/Users/perkunas/jail/uav-011', '/Users/perkunas/jail/uav-009', '/tmp/reproduce_leakage']:
    bundle = open(f'{repo}/.pipeline/ACTIVE_RULES_BUNDLE.md').read()
    missing = [os.path.basename(r) for r in rules if open(r).read() not in bundle]
    print(f'{repo} missing rules:', missing)
"
# Result: All repos have 0 missing rules (100% parity)
```
