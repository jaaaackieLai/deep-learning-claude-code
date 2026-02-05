# Peer Review Protocol

Adapted from the llm-council anonymized ranking stage. Each analyst reviews the other two analyses without knowing which specialist produced them, then provides quality assessments. This single round of peer review is faster than multi-round cross-examination while still catching blind spots and errors.

## Why Anonymize

- Prevents analysts from deferring to a "code expert" on code topics or a "theory expert" on theory topics
- Forces each reviewer to evaluate content on its merits
- Mirrors the llm-council insight: anonymized peer review produces more honest evaluations

## Process

### Step 1: Prepare Anonymized Analyses

For each analyst, prepare a review packet containing the OTHER TWO analyses with anonymized labels:

| Reviewer | Sees | Labels |
|----------|------|--------|
| Analyst A | B's analysis + C's analysis | "Analysis X" + "Analysis Y" |
| Analyst B | A's analysis + C's analysis | "Analysis X" + "Analysis Y" |
| Analyst C | A's analysis + B's analysis | "Analysis X" + "Analysis Y" |

Important: Randomize which analysis gets label X vs Y for each reviewer. This prevents positional bias.

### Step 2: Send Review Prompt

Use the following prompt template for each reviewer:

```
You are a peer reviewer evaluating two specialist analyses of a research paper.

The paper being analyzed: [paper title]

Below are two analyses produced by independent specialists. Your task is to evaluate each analysis for accuracy, completeness, clarity, and practical usefulness.

---

Analysis X:
[anonymized analysis content]

---

Analysis Y:
[anonymized analysis content]

---

For each analysis, provide:

1. **Strengths**: What does this analysis do well? What insights are particularly valuable?
2. **Weaknesses**: What is inaccurate, missing, or unclear?
3. **Suggestions**: Specific improvements that would make this analysis more useful.
4. **Missed Points**: Important aspects of the paper/code that this analysis fails to cover.

After evaluating both analyses individually, provide a comparative assessment.

IMPORTANT: End your review with a structured quality assessment in EXACTLY this format:

QUALITY ASSESSMENT:
Analysis X - Accuracy: [1-5] | Completeness: [1-5] | Clarity: [1-5] | Usefulness: [1-5]
Analysis Y - Accuracy: [1-5] | Completeness: [1-5] | Clarity: [1-5] | Usefulness: [1-5]

Where 1 = Poor, 2 = Below Average, 3 = Average, 4 = Good, 5 = Excellent
```

### Step 3: Launch Reviews in Parallel

All 3 reviewers run simultaneously. In Claude-only mode, use 3 parallel Task subagents. In multi-model mode, use the same model assignments as Phase 1.

### Step 4: Parse Quality Scores

Extract the `QUALITY ASSESSMENT:` section from each review. Parse the numeric scores for each dimension.

### Step 5: Calculate Aggregate Scores

For each original analysis, collect all peer review scores and compute:

```
Aggregate Score = average across all dimensions from all reviewers
```

Example calculation:

```
Analyst A's analysis was reviewed by B and C:
  B scored it: Accuracy=4, Completeness=4, Clarity=5, Usefulness=4
  C scored it: Accuracy=5, Completeness=3, Clarity=4, Usefulness=5

  Aggregate = (4+4+5+4+5+3+4+5) / 8 = 4.25
```

### Step 6: Identify Consensus and Disputes

Before passing to the chairman, identify:

- **Consensus points**: Where both reviewers agree an analysis is strong or weak
- **Disputed points**: Where reviewers disagree significantly (score difference >= 2 on any dimension)
- **Critical gaps**: Points flagged as "missed" by both reviewers

These annotations help the chairman prioritize during synthesis.

## Evaluation Criteria Definitions

| Criterion | 1 (Poor) | 3 (Average) | 5 (Excellent) |
|-----------|----------|-------------|----------------|
| **Accuracy** | Contains factual errors about the paper/code | Mostly correct with minor inaccuracies | Completely accurate, well-verified claims |
| **Completeness** | Misses major aspects within its scope | Covers main points, misses some details | Thorough coverage of all relevant aspects |
| **Clarity** | Confusing structure, jargon without explanation | Understandable but could be clearer | Clear, well-organized, accessible to target audience |
| **Usefulness** | Not actionable, too vague to apply | Somewhat helpful for understanding/usage | Directly enables understanding and practical application |

## Output Format

Each peer review should be structured as:

```markdown
# Peer Review

## Analysis X

### Strengths
[bullet points]

### Weaknesses
[bullet points]

### Suggestions
[numbered list of specific improvements]

### Missed Points
[bullet points]

## Analysis Y

### Strengths
[bullet points]

### Weaknesses
[bullet points]

### Suggestions
[numbered list of specific improvements]

### Missed Points
[bullet points]

## Comparative Assessment
[1-2 paragraphs comparing the two analyses]

QUALITY ASSESSMENT:
Analysis X - Accuracy: [1-5] | Completeness: [1-5] | Clarity: [1-5] | Usefulness: [1-5]
Analysis Y - Accuracy: [1-5] | Completeness: [1-5] | Clarity: [1-5] | Usefulness: [1-5]
```
