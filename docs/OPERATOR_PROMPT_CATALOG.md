# Standardized Operator Usage Prompt Catalog

| Attribute | Specification Detail |
| :--- | :--- |
| **Version** | 1.0.0 |
| **Date** | 2026-09-04 |

> **Document Identifier:** `DEAP-CATALOG-PROMPT-001`  
> **Status:** `APPROVED / PRODUCTION-GRADE`  
> **Classification:** `Standardized Operator Usage Prompt Catalog for Pipeline 1 & Pipeline 2`  
> **Target Frameworks:** `JARUS SORA v2.5` | `ASTM F3269-17 RTA` | `RTCA DO-178C` | `RTCA DO-365B DAA`  
> **Primary Technology Profile:** `DEAP Multi-Pipeline Architecture (Pipeline 1 Ingestion & Pipeline 2 Synthesis)`

---

## 1. Overview & Purpose

This catalog provides standardized, deterministic operator prompt templates for orchestrating **Pipeline 1 (Specification Ingestion & Refinement)** and **Pipeline 2 (Code & Verification Synthesis)** across the Digital Engineering Agent Platform (DEAP).

Every prompt template is structured to enforce:
- Context-isolated subagent dispatch (`TypeName: self`).
- Explicit repository role classification (`PLATFORM_PROFILE_TEMPLATE`).
- Mandatory pre-flight checklist verification (`rules/subagent-dispatch-standards.md`).
- Strict adherence to SysML v2 SSOT models and 3-Layer Definition of Done.
- Trailing `PROCEED` execution tokens.

---

## Pipeline 1: Specification Ingestion & Refinement

Pipeline 1 transforms normative standards, safety baselines, and SysML v2 models into structured, traceability-linked specifications (ConOps, Epics, Features, User Stories, and Use Cases).

### Worker 1A — Baseline Ingestion

**Purpose**: Ingests external domain standards, regulatory baselines, and upstream system architectures into raw SysML v2 AST representations.

**Operator Prompt Template**:
```text
Execute view_file on skills/spec-orchestrator/SKILL.md by exact path as your very first step before executing any file edits or commands, and strictly follow its instruction guidelines.

Repository Classification: PLATFORM_PROFILE_TEMPLATE
Role: Normative Research & Baseline Ingestion Worker
Subagent Type: spec_ingestion_worker
Target: <PATH_TO_NORMATIVE_STANDARDS_OR_SYSML_SOURCE>

Task: Execute Phase 0.5 and Phase 1 Baseline Ingestion:
1. Parse raw input specifications and identify all normative requirement tokens and regulatory clauses.
2. Ingest structural definitions into .pipeline/schema.sysml maintaining 100% AST fidelity.
3. Validate that no domain-specific hardcoded types pollute the core abstract grammar.
4. Generate baseline Epic and Feature candidate specifications in docs/epics/ and docs/features/.

Normative Pre-Flight Checklist:
- Read the SKILL.md instructions in full and follow them literally without summarizing.
- Deliver all three layers of the Evolved 3-Layer Definition of Done.
- Scope max 1 Epic or 1 Feature per dispatched micro-task subagent.
- File defects with both gh issue create and glab issue create format support.

PROCEED
```

### Worker 1B — Semantic Normalization

**Purpose**: Normalizes domain types, interfaces (ICDs), behavioral state machines, and mathematical KaTeX invariants across all ingested specifications.

**Operator Prompt Template**:
```text
Execute view_file on skills/spec-orchestrator/SKILL.md by exact path as your very first step before executing any file edits or commands, and strictly follow its instruction guidelines.

Repository Classification: PLATFORM_PROFILE_TEMPLATE
Role: Semantic Normalization Worker (Worker ICD)
Subagent Type: spec_normalization_worker
Target: docs/features/

Task: Execute Phase 1.5 and Phase 2 Semantic Normalization:
1. Normalize all logical interface definitions (ICDs) and data flow boundaries.
2. Verify all mathematical and physical formulas conform to LaTeX / KaTeX rendering standards.
3. Align all state transitions with deterministic SysML v2 state machine definitions.
4. Ensure all behavioral specifications include exhaustive pre/post conditions and invariant bounds.

Normative Pre-Flight Checklist:
- Read the SKILL.md instructions in full and follow them literally without summarizing.
- Deliver all three layers of the Evolved 3-Layer Definition of Done.
- Scope max 1 Feature or 1 User Story per dispatched micro-task subagent.
- File defects with both gh issue create and glab issue create format support.

PROCEED
```

### Worker 1C — Parity & Consistency Audit

**Purpose**: Executes adversarial parity audits, cross-reference validation, and SysML AST model completeness checks.

**Operator Prompt Template**:
```text
Execute view_file on skills/adversarial-code-auditor/SKILL.md by exact path as your very first step before executing any file edits or commands, and strictly follow its instruction guidelines.

Repository Classification: PLATFORM_PROFILE_TEMPLATE
Role: Adversarial Parity Auditor (Worker 1C)
Subagent Type: adversarial_auditor
Target: .pipeline/schema.sysml

Task: Execute Phase 3 Parity and Consistency Audit:
1. Run parity auditor CLI: PYTHONPATH=skills/spec-orchestrator/parity_auditor/src python3 -m parity_auditor.cli --workspace .
2. Verify 100% bidirectional traceability between SysML v2 models and markdown specifications.
3. Audit all Mermaid diagram syntax against rules/platform-independence.md.
4. Ensure zero broken references or unmapped dependencies across the specification backlog.

Normative Pre-Flight Checklist:
- Read the SKILL.md instructions in full and follow them literally without summarizing.
- Deliver all three layers of the Evolved 3-Layer Definition of Done.
- File defects with both gh issue create and glab issue create format support.

PROCEED
```

### Worker 1D — Test Oracle Synthesis

**Purpose**: Synthesizes formal verification test oracles, BDD acceptance scenarios, and validation vectors from verified specifications.

**Operator Prompt Template**:
```text
Execute view_file on skills/spec-orchestrator/SKILL.md by exact path as your very first step before executing any file edits or commands, and strictly follow its instruction guidelines.

Repository Classification: PLATFORM_PROFILE_TEMPLATE
Role: Test Oracle Synthesis Worker (Worker 1D)
Subagent Type: test_oracle_synthesizer
Target: docs/user-stories/

Task: Execute Phase 3.5 Test Oracle Synthesis:
1. Synthesize formal verification test matrices for all User Stories and Use Cases.
2. Generate BDD Gherkin test scenarios and safety boundary assertions.
3. Validate full witness coverage for all declared regulatory obligations (SORA, RTCA, ASTM).
4. Synchronize obligation witness registry in docs/research/OBLIGATION_WITNESS_REGISTRY.md.

Normative Pre-Flight Checklist:
- Read the SKILL.md instructions in full and follow them literally without summarizing.
- Deliver all three layers of the Evolved 3-Layer Definition of Done.
- File defects with both gh issue create and glab issue create format support.

PROCEED
```

---

## Pipeline 2: Code & Verification Synthesis

Pipeline 2 consumes verified specification artifacts and synthesizes production-grade code, unit/integration test suites, and compliance verification evidence.

### Synthesis Driver

**Purpose**: Executes strict TDD (RED-GREEN-REFACTOR) implementation against specification targets, achieving 100% test passing rates and zero static analysis defects.

**Operator Prompt Template**:
```text
Execute view_file on skills/feature-driven-implementation/SKILL.md by exact path as your very first step before executing any file edits or commands, and strictly follow its instruction guidelines.

Repository Classification: PLATFORM_PROFILE_TEMPLATE
Role: Feature Implementation Driver
Subagent Type: code_modifier_worker
Target: <PATH_TO_TARGET_SPEC_OR_CODE_MODULE>

Task: Execute Pipeline 2 Feature Implementation:
1. Follow strict TDD (RED-GREEN-REFACTOR) workflow.
2. Implement unit and regression tests in tests/ confirming initial RED state.
3. Write clean, production-grade implementation code transitioning tests to GREEN.
4. Run static analysis, linters, and full test suite confirming 100% pass rate.
5. Execute parity auditor gate before completion: PYTHONPATH=skills/spec-orchestrator/parity_auditor/src python3 -m parity_auditor.cli --workspace . --allow-missing-specs

Normative Pre-Flight Checklist:
- Read the SKILL.md instructions in full and follow them literally without summarizing.
- Deliver all three layers of the Evolved 3-Layer Definition of Done (DoD).
- Scope max 1 Feature micro-task per dispatch.
- File defects with both gh issue create and glab issue create format support.

PROCEED
```
