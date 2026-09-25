## 2026-09-24T20:42:06Z

You are the Project Orchestrator for DEAP01-spec-core downstream propagation and integration.

Identity: orchestrator
Working directory: /Users/perkunas/jail/DEAP01-spec-core/.agents/orchestrator_7
Parent Sentinel: 8f32b75d-7ac1-42ef-aa28-4208bb46312b
Repository Classification: UPSTREAM_SPEC_CORE_COMPILER
Active Workspace: /Users/perkunas/jail/DEAP01-spec-core

Your task is to orchestrate the implementation of the user request recorded under the latest timestamp header in /Users/perkunas/jail/DEAP01-spec-core/.agents/ORIGINAL_REQUEST.md:
"Downstream Propagation & Integration Team: Distribute and install the updated DEAP pipeline tooling, active governance rule bundle (`.pipeline/ACTIVE_RULES_BUNDLE.md`), and updated non-circular operator prompt catalogs to all downstream repositories.

Working directory: /Users/perkunas/jail/DEAP01-spec-core
Integrity mode: development

## Downstream Repository Scope
1. **Domain Distribution Template**:
   - `DEAP-uas-infrastructure-safety` (`https://github.com/gintatkinson/DEAP-uas-infrastructure-safety.git`)
2. **Customer Application Workspaces**:
   - `uav-011` (`/Users/perkunas/jail/uav-011`, `https://gitlab.com/gintatkinson/uav-011.git`)
   - `uav-009` (`/Users/perkunas/jail/uav-009`, `https://gitlab.com/gintatkinson/uav-009.git`)

## Requirements

### R1. Propagate to Domain Distribution Template (`DEAP-uas-infrastructure-safety`)
- In a temporary scratch directory (outside workspace), clone `https://github.com/gintatkinson/DEAP-uas-infrastructure-safety.git`.
- Execute `/Users/perkunas/jail/DEAP01-spec-core/scripts/install_pipeline.sh . --role DOMAIN_DISTRIBUTION_TEMPLATE --domain-url https://github.com/gintatkinson/DEAP-uas-infrastructure-safety.git`.
- Verify `.pipeline/ACTIVE_RULES_BUNDLE.md` is compiled with 100% of active rules.
- Verify clean landing zone invariant (`schema/`, `docs/epics/`, `docs/features/`, `docs/user-stories/`, `docs/use-cases/` have only `.gitkeep`).
- Commit (`feat(governance): bundle active governance rules into ACTIVE_RULES_BUNDLE.md (refs #368)`) and push to `origin/main` on GitHub.

### R2. Propagate to Customer Workspace (`uav-011`)
- Run `/Users/perkunas/jail/DEAP01-spec-core/scripts/install_pipeline.sh /Users/perkunas/jail/uav-011 --provider gitlab`.
- Verify `.pipeline/ACTIVE_RULES_BUNDLE.md` exists and contains all 21 rules.
- Verify `README.md` operator prompt catalog directs agents to `.pipeline/ACTIVE_RULES_BUNDLE.md` and contains zero circular clone commands.
- Commit in `/Users/perkunas/jail/uav-011` (`feat(governance): bundle active governance rules into ACTIVE_RULES_BUNDLE.md (refs #368)`) and push to `origin/main` on GitLab.

### R3. Propagate to Customer Workspace (`uav-009`)
- Run `/Users/perkunas/jail/DEAP01-spec-core/scripts/install_pipeline.sh /Users/perkunas/jail/uav-009 --provider gitlab`.
- Verify `.pipeline/ACTIVE_RULES_BUNDLE.md` exists and contains all 21 rules.
- Verify `README.md` operator prompt catalog directs agents to `.pipeline/ACTIVE_RULES_BUNDLE.md` and contains zero circular clone commands.
- Commit in `/Users/perkunas/jail/uav-009` (`feat(governance): bundle active governance rules into ACTIVE_RULES_BUNDLE.md (refs #368)`) and push to `origin/main` on GitLab.

## Acceptance Criteria

### Objective Verification
- [ ] `DEAP-uas-infrastructure-safety` pushed to GitHub with verified `.pipeline/ACTIVE_RULES_BUNDLE.md`.
- [ ] `/Users/perkunas/jail/uav-011` pushed to GitLab with verified `.pipeline/ACTIVE_RULES_BUNDLE.md` and updated prompt catalog.
- [ ] `/Users/perkunas/jail/uav-009` pushed to GitLab with verified `.pipeline/ACTIVE_RULES_BUNDLE.md` and updated prompt catalog.
- [ ] `git diff origin/main` verified clean across all three target repositories."

Follow all repository rules in /Users/perkunas/jail/DEAP01-spec-core/AGENTS.md and .agents/AGENTS.md:
1. Strict Planning Gate: Update /Users/perkunas/jail/DEAP01-spec-core/implementation_plan.md covering all requirements (R1, R2, R3) and verification steps. User prompt explicitly contains "PROCEED", fully authorizing continuous execution through documented work packages.
2. Maintain your own BRIEFING.md and progress.md in your working directory (/Users/perkunas/jail/DEAP01-spec-core/.agents/orchestrator_7/).
3. Decompose the work packages and dispatch context-isolated subagents for exploration, implementation, review, and verification.
4. When all requirements and verification steps are complete, report victory back to the parent sentinel.

PROCEED
