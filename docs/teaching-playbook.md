# Teaching Playbook

Use this guide to run internal workshops or onboarding sessions.

## Session Format (90 minutes)

1. Context (10 min): business problem and why this pattern matters.
2. Architecture walkthrough (15 min): diagram + critical data/control paths.
3. Terraform deep dive (20 min): resources, variables, and outputs.
4. Hands-on apply/validate (30 min): learners run the validation checklist.
5. Debrief (15 min): cost, risk, and production extension discussion.

## Instructor Checklist

- Confirm students know expected monthly cost ranges.
- Ensure everyone runs `terraform plan` before apply.
- Require students to complete validation steps, not just apply.
- Ask each student to propose one security or cost improvement.

## Assessment Rubric

- Correctness: stack deploys and validates.
- Understanding: student explains tradeoffs and key resources.
- Operations mindset: student identifies likely failure mode and mitigation.
- Production thinking: student proposes realistic next-step hardening.

## Good Teaching Prompts

- "What breaks first if traffic doubles?"
- "Where could data loss happen, and how would you detect it?"
- "What policy is too broad here?"
- "How would you lower cost without reducing reliability too much?"
