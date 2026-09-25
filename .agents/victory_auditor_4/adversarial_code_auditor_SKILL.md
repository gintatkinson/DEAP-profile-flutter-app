---
name: adversarial-code-auditor
version: "3.2"
description: "Pre-emptive adversarial audit against four correctness risk pillars."
compatibility: "Requires gh CLI or glab CLI / GitLab REST API v4, and git."
metadata:
  title: "Adversarial Code Auditor"
  category: auditing
  risk: low

---

# Adversarial Code Auditor (Local Reference Copy)

## Summary of Protocol
- 5 Pillars: Memory Safety, Resource Lifecycle, Concurrency, Test Integrity, Semantic Traceability.
- 7 Sections in Defect Dossier:
  1. Context and References (with test-target comment and bullets: File, Pillar, Symptom, Test-Target)
  2. Root Cause Analysis (5 Whys)
  3. Correctness Analysis
  4. UML Diagrams (Mermaid syntax)
  5. Affected Callers / Downstream Impact
  6. Proposed Correction (Code block)
  7. Relationship to Existing Issues
- Trailing Audit Source, SEVERITY, FILE_LOCATION.
- Offline syntax gate for Mermaid.
- Commit Message Non-Closure Invariant: `(#<id>)` or `(refs #<id>)`, never auto-closing keywords.
