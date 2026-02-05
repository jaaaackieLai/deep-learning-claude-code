# Synthesis Guide

Instructions for the chairman agent that synthesizes all analyses and peer reviews into the final skill output files.

## Chairman Role

You are the chairman of an academic paper council. You have received:

1. **Shared context**: Paper content and repository structure
2. **Three specialist analyses**: Theory & Method (A), Literature & Concepts (B), Code & Practice (C)
3. **Three peer reviews**: Each analyst's anonymized review of the other two
4. **Aggregate quality scores**: Numeric scores for each analysis across accuracy, completeness, clarity, and usefulness

Your task: synthesize all of this into 4 high-quality skill output files that enable readers to quickly understand and apply the paper's methods.

## Synthesis Strategy

### Prioritization

Use aggregate scores to weight contributions:

- **Highest-scored content first**: Start with the analysis that received the highest aggregate scores. Its content forms the backbone of each output file.
- **Incorporate improvement suggestions**: Where peer reviewers flagged weaknesses or missing points, fill gaps using content from other analyses or your own knowledge.
- **Resolve conflicts**: When analysts disagree (e.g., about the novelty of a contribution), note both perspectives. If peer reviews sided with one view, favor that view.

### Conflict Resolution Rules

1. **Factual claims**: If two analysts agree and one disagrees, go with the majority. If peer reviews flag the disagreement, note the uncertainty.
2. **Subjective assessments** (novelty, importance): Present the range of views. Use language like "While the methodology is rigorous (Analyst A), the novelty is incremental relative to [prior work] (Analyst B)."
3. **Code vs. paper discrepancies**: Always flag these explicitly. If Analyst C found that code differs from the paper, this must appear in the code guide.

### Content Mapping

Map analyst outputs to skill files:

| Skill File | Primary Source | Supporting Sources |
|------------|---------------|-------------------|
| `SKILL.md` | All three (summary level) | Peer review consensus points |
| `paper_summary.md` | Analyst A (Theory & Method) | Analyst B (context and novelty) |
| `key_concepts.md` | Analyst B (Literature & Concepts) | Analyst A (math formulations) |
| `code_guide.md` | Analyst C (Code & Practice) | Analyst A (methodology for code-paper alignment) |

## Output Specification

Generate exactly 4 files following the templates in [skill-output-templates.md](skill-output-templates.md).

### File 1: SKILL.md

The entry point. Must be concise (under 80 lines). Contains:
- YAML frontmatter with name and description
- 1-2 sentence problem/solution/contribution summaries
- Top 3-5 key concepts (one line each)
- Quick start commands
- Links to the 3 reference files

### File 2: references/paper_summary.md

Comprehensive paper analysis. Primary source is Analyst A, enriched with:
- Related work context from Analyst B
- Practical implications from Analyst C
- Corrections from peer reviews

### File 3: references/key_concepts.md

Concept reference. Primary source is Analyst B, enriched with:
- Mathematical formulations from Analyst A
- Code-level concept mapping from Analyst C
- Terminology corrections from peer reviews

### File 4: references/code_guide.md

Practical usage guide. Primary source is Analyst C, enriched with:
- Paper-code alignment notes from Analyst A
- Context for why certain design choices were made (from Analyst B)
- Setup/troubleshooting improvements from peer reviews

## Quality Checklist

Before finalizing, verify each output file against this checklist:

### SKILL.md
- [ ] YAML frontmatter has correct name and description
- [ ] Problem/solution/contribution summaries are accurate and concise
- [ ] Key concepts match what is in key_concepts.md
- [ ] Quick start commands match what is in code_guide.md
- [ ] All reference file links are correct

### paper_summary.md
- [ ] Problem statement clearly explains the gap
- [ ] Solution description matches the paper (not overclaimed)
- [ ] Contributions are supported by experimental evidence
- [ ] Experimental results include concrete numbers
- [ ] Limitations are acknowledged

### key_concepts.md
- [ ] All key terms are defined before first use
- [ ] Mathematical notation is consistent with the paper
- [ ] Concepts are explained at appropriate depth
- [ ] Relationships to prior work are accurate

### code_guide.md
- [ ] Setup instructions are testable (concrete commands)
- [ ] File paths and line numbers reference actual repository files
- [ ] Code snippets are syntactically correct
- [ ] Paper-code discrepancies are flagged
- [ ] Troubleshooting covers common issues

## Writing Guidelines

- Write for the target audience: deep learning researchers who have not read the paper
- Use progressive disclosure: essential information first, details in subsections
- Prefer concrete examples over abstract descriptions
- When citing the paper, reference specific sections, figures, or tables
- When citing code, reference specific files and line numbers
- Keep language direct and technical -- avoid filler phrases
