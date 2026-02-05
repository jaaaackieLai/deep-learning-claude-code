---
name: paper
description: Transform research papers and their code repositories into high-quality reusable skills through multi-agent council deliberation. Three specialist analysts independently examine the paper and code, then anonymously peer-review each other's work, and a chairman synthesizes the best content into structured skill files. Use when users want to package a paper with its implementation code, create a reference guide for a specific paper, or build a skill that captures a paper's problem, solution, and contributions. Triggers include requests like "package this paper as a skill", "create a skill from paper X and its code", or "analyze paper and code to make a reusable reference".
---

# Paper Council

Transform research papers and code repositories into high-quality reusable skills through multi-agent council deliberation.

## How It Works

Three specialist analysts independently examine the paper and code, then anonymously peer-review each other's work. A chairman synthesizes the highest-rated content into structured skill files. This catches blind spots and errors that a single-agent approach would miss.

```
Paper PDF + GitHub Repo
        |
  [Phase 0] Gather information
        |
  [Phase 1] 3 parallel specialist analyses
        |
  [Phase 2] 3 parallel anonymized peer reviews
        |
  [Phase 3] Chairman synthesis
        |
  [Phase 4] Write skill files
```

## Mode Selection

**Claude-only mode** (default): All agents run as Claude Task subagents. Simpler, no external dependencies.

**Multi-model mode** (user must request): Uses Claude, GPT, and Gemini for true model diversity. Requires `gpt_messages` and `gemini_messages` MCP servers. Better blind spot detection.

---

## Phase 0: Information Gathering

### Step 0.1: Collect Inputs

Collect from the user:
1. **Paper location**: Path to the PDF file
2. **Repository URL**: GitHub URL of the implementation code

Both inputs are required. If either is missing, request it from the user.

### Step 0.2: Read the Paper

Use the `/pdf` skill to read and extract the paper content:

```
/pdf <paper-path>
```

Store the extracted text as `paper_text` for use as shared context.

### Step 0.3: Clone and Explore Repository

```bash
git clone <github-url> ./paper_repos/<paper-name>
```

Explore the repository to build a structural overview:

- Use Glob to find Python files: `**/*.py`
- Use Glob to find config files: `**/*.yaml`, `**/*.yml`, `**/*.json`
- Read `README.md`, `requirements.txt`, `environment.yml`
- Identify model files, training scripts, data loaders, notebooks

Store the annotated directory listing as `repo_structure` for use as shared context.

### Step 0.4: Prepare Shared Context

Combine into a single context block:

```
SHARED CONTEXT:

=== PAPER CONTENT ===
[paper_text]

=== REPOSITORY STRUCTURE ===
[repo_structure]

=== KEY FILES ===
[contents of the 5-10 most important files, with paths]
```

---

## Phase 1: Independent Specialist Analysis

Launch 3 analysts in parallel. Each receives the shared context but a different system prompt.

See [references/analyst-roles.md](references/analyst-roles.md) for complete role definitions.

### Claude-only Mode

```
# Launch all 3 in parallel using Task tool
Task(subagent_type="general-purpose", prompt="[Analyst A system prompt]\n\n[shared context]")
Task(subagent_type="general-purpose", prompt="[Analyst B system prompt]\n\n[shared context]")
Task(subagent_type="general-purpose", prompt="[Analyst C system prompt]\n\n[shared context]")
```

### Multi-model Mode

```
# Analyst A: Claude (Task subagent)
Task(subagent_type="general-purpose", prompt="[Analyst A system prompt]\n\n[shared context]")

# Analyst B: GPT (via MCP)
gpt_messages(messages=[
  {role: "system", content: "[Analyst B system prompt]"},
  {role: "user", content: "[shared context]"}
])

# Analyst C: Gemini (via MCP)
gemini_messages(messages=[
  {role: "system", content: "[Analyst C system prompt]"},
  {role: "user", content: "[shared context]"}
])
```

Store the 3 analysis outputs as `analysis_A`, `analysis_B`, `analysis_C`.

---

## Phase 2: Anonymized Peer Review

Each analyst reviews the OTHER TWO analyses without knowing who produced them.

See [references/peer-review-protocol.md](references/peer-review-protocol.md) for the complete protocol.

### Step 2.1: Prepare Review Packets

For each reviewer, prepare a packet with the other two analyses anonymized:

| Reviewer | Receives | As |
|----------|----------|----|
| Analyst A | analysis_B + analysis_C | "Analysis X" + "Analysis Y" |
| Analyst B | analysis_A + analysis_C | "Analysis X" + "Analysis Y" |
| Analyst C | analysis_A + analysis_B | "Analysis X" + "Analysis Y" |

Randomize which analysis gets X vs Y for each reviewer.

### Step 2.2: Launch Reviews in Parallel

Use the review prompt template from [references/peer-review-protocol.md](references/peer-review-protocol.md). Launch all 3 reviews in parallel using the same model assignment as Phase 1.

### Step 2.3: Parse Quality Scores

Extract the `QUALITY ASSESSMENT:` section from each review. Calculate aggregate scores per the protocol.

### Step 2.4: Identify Consensus and Disputes

Note where reviewers agree (consensus) and disagree (disputes). Flag points marked as "missed" by multiple reviewers.

---

## Phase 3: Chairman Synthesis

A single chairman agent receives everything and produces the final skill files.

See [references/synthesis-guide.md](references/synthesis-guide.md) for complete instructions.

### Chairman Input

Provide the chairman with:

```
CHAIRMAN SYNTHESIS TASK:

You are the chairman of a paper analysis council. Synthesize the materials below
into 4 skill output files following the templates provided.

=== PAPER TITLE ===
[title]

=== SHARED CONTEXT ===
[paper_text + repo_structure]

=== SPECIALIST ANALYSES ===

Analyst A (Theory & Method) [Aggregate Score: X.XX]:
[analysis_A]

Analyst B (Literature & Concepts) [Aggregate Score: X.XX]:
[analysis_B]

Analyst C (Code & Practice) [Aggregate Score: X.XX]:
[analysis_C]

=== PEER REVIEWS ===

Review by Analyst A:
[review_A]

Review by Analyst B:
[review_B]

Review by Analyst C:
[review_C]

=== CONSENSUS AND DISPUTES ===
[consensus_and_disputes summary]

=== OUTPUT TEMPLATES ===
[contents of references/skill-output-templates.md]

=== SYNTHESIS GUIDE ===
[contents of references/synthesis-guide.md]

Generate the 4 files. Separate each file with a clear delimiter:
--- FILE: SKILL.md ---
--- FILE: references/paper_summary.md ---
--- FILE: references/key_concepts.md ---
--- FILE: references/code_guide.md ---
```

Launch as a single Task subagent (always Claude, even in multi-model mode):

```
Task(subagent_type="general-purpose", prompt="[chairman prompt above]")
```

---

## Phase 4: Write Skill Files

### Step 4.1: Parse Chairman Output

Split the chairman's response by the file delimiters to extract the 4 files.

### Step 4.2: Determine Skill Directory

Use the paper name (lowercase, hyphens) as the directory name:

```
skills/<paper-name>/
├── SKILL.md
└── references/
    ├── paper_summary.md
    ├── key_concepts.md
    └── code_guide.md
```

### Step 4.3: Write Files

Write each file to the skill directory. Verify that:
- YAML frontmatter in SKILL.md is valid
- All internal links between files are correct
- File paths in code_guide.md reference actual repository files

### Step 4.4: Report Results

Report to the user:
- Skill directory location
- Aggregate quality scores from peer review
- Any disputes or concerns flagged during review
- Suggestion to review the generated files

---

## Reference Files

| File | Purpose |
|------|---------|
| [analyst-roles.md](references/analyst-roles.md) | Specialist role definitions and prompt templates |
| [peer-review-protocol.md](references/peer-review-protocol.md) | Anonymized review process and scoring |
| [synthesis-guide.md](references/synthesis-guide.md) | Chairman instructions for final synthesis |
| [skill-output-templates.md](references/skill-output-templates.md) | Templates for the 4 generated skill files |
