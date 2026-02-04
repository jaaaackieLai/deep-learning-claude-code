# Claim Verification Workflow

## Overview

Systematic approach to evaluating scientific claims and statements encountered in papers, media, or presentations.

## Workflow Steps

### Phase 1: Claim Analysis (5-10 minutes)

**1. Extract and Clarify the Claim**

Use: [Claim Evaluation Guide](../guides/claim-evaluation.md)

- [ ] State claim explicitly
- [ ] Identify claim type (causal, associational, descriptive)
- [ ] Note claim strength (proven, likely, suggested, possible)
- [ ] Identify scope (population, conditions, outcomes)

**Example transformation:**
- Original: "This vitamin boosts immunity"
- Clarified: "Oral supplementation with vitamin D (50,000 IU weekly) reduces risk of respiratory infections in adults with vitamin D deficiency"

**2. Identify Implicit Assumptions**
- What must be true for claim to be valid?
- What is implied but not stated?
- Are there hidden premises?

---

### Phase 2: Evidence Assessment (15-30 minutes)

**3. Find the Evidence**

Locate supporting evidence:
- [ ] Primary research cited?
- [ ] Published in peer-reviewed journal?
- [ ] Preprint or unpublished?
- [ ] Secondary sources (reviews, media)?

**4. Evaluate Evidence Quality**

Use: [Evidence Assessment Guide](../guides/evidence-assessment.md)

For each supporting study:
- **Study design**: RCT / Cohort / Case-control / Cross-sectional / Other
- **Sample size**: Adequate? Powered?
- **Quality**: High / Moderate / Low / Very Low
- **Risk of bias**: Low / Unclear / High

Use: [Methodology Critique Guide](../guides/methodology-critique.md)

Check:
- [ ] Design appropriate for claim type
- [ ] Sample representative
- [ ] Measurements valid
- [ ] Analysis appropriate
- [ ] Results support claim

Use: [Bias Detection Guide](../guides/bias-detection.md)

Look for:
- [ ] Selection bias
- [ ] Measurement bias
- [ ] Confounding
- [ ] Publication bias
- [ ] Conflicts of interest

**5. Statistical Evaluation**

Use: [Statistical Evaluation Guide](../guides/statistical-evaluation.md)

- [ ] Sample size adequate (power analysis?)
- [ ] Statistical tests appropriate
- [ ] Effect size reported and meaningful
- [ ] Confidence intervals provided
- [ ] P-values interpreted correctly
- [ ] Multiple comparisons addressed

---

### Phase 3: Logical Analysis (10-15 minutes)

**6. Check Logical Connection**

Use: [Claim Evaluation Guide](../guides/claim-evaluation.md)

- [ ] Do data support conclusion?
- [ ] Are there logical leaps?
- [ ] Is evidence direct or indirect?
- [ ] Are alternative explanations ruled out?

**Common disconnects:**
- Correlation → Causation
- Laboratory → Real-world
- Animal model → Human
- Surrogate → Clinical outcome
- Sample → Population

**7. Identify Logical Fallacies**

Use: [Fallacy Identification Guide](../guides/fallacy-identification.md)

Check for:
- [ ] Post hoc ergo propter hoc (temporal → causal)
- [ ] Hasty generalization (small sample → broad claim)
- [ ] Cherry-picking (selective evidence)
- [ ] Appeal to authority without evidence
- [ ] Correlation = causation
- [ ] Anecdotal evidence as proof

---

### Phase 4: Context Evaluation (10-15 minutes)

**8. Check Proportionality**

Is claim strength proportional to evidence?

| Evidence Strength | Appropriate Claim Language |
|-------------------|---------------------------|
| Multiple high-quality RCTs | "Evidence demonstrates..." |
| Single well-designed study | "This study found..." "Suggests..." |
| Preliminary evidence | "May..." "Possible..." |
| Weak/inconsistent evidence | "Unclear..." "Mixed evidence..." |

**Red flags:**
- "Proves" (rarely justified)
- "Definitely" (overly confident)
- "Clearly" (often overstated)
- Ignoring limitations
- Dismissing uncertainty

**9. Assess Generalization**

- [ ] Population: Does sample represent claimed population?
- [ ] Setting: Do lab conditions match real-world?
- [ ] Time: Short-term findings → long-term claims?
- [ ] Outcome: Surrogate → clinical outcomes?

**10. Review Broader Evidence**

- [ ] Is this consistent with existing evidence?
- [ ] Are there contradictory studies?
- [ ] What do systematic reviews say?
- [ ] Is there publication bias (only positive studies)?

---

### Phase 5: Synthesis (5-10 minutes)

**11. Determine Verdict**

**Claim is:**
- ☑ **Well-Supported**: Strong evidence, appropriate language, limitations acknowledged
- ☐ **Partially Supported**: Some evidence, overclaimed, or limitations not fully acknowledged
- ☐ **Poorly Supported**: Weak evidence, serious overclaiming, or major logical flaws
- ☐ **Not Supported**: Evidence doesn't support claim or evidence is absent

**12. Formulate Revised Claim**

If original claim is poorly supported, what would be appropriate?

Template:
> **Original claim**: [Quote original]
>
> **Evidence**: [Summarize supporting evidence]
>
> **Issues**: [List main problems]
>
> **Revised claim**: [Appropriate claim given evidence]

---

## Quick Reference Checklist

### Claim Analysis
- [ ] Claim stated explicitly
- [ ] Claim type identified
- [ ] Claim strength noted
- [ ] Assumptions identified

### Evidence Quality
- [ ] Primary sources located
- [ ] Study design appropriate
- [ ] Sample size adequate
- [ ] Low risk of bias
- [ ] Statistical analysis sound

### Logical Validity
- [ ] Data support conclusion
- [ ] No major logical leaps
- [ ] Alternative explanations addressed
- [ ] No obvious fallacies

### Proportionality
- [ ] Language matches evidence strength
- [ ] Limitations acknowledged
- [ ] Generalization justified
- [ ] Uncertainty noted

### Context
- [ ] Consistent with broader evidence
- [ ] Contradictory evidence addressed
- [ ] Conflicts of interest disclosed

---

## Output Template

```markdown
## Claim Verification: [Claim]

**Original Claim**: "[Quote exactly]"

**Source**: [Where claim appeared]

### Claim Analysis
**Type**: [Causal / Associational / Descriptive / etc.]

**Strength**: [Proven / Demonstrated / Suggested / Possible / etc.]

**Scope**: [Population, conditions, outcomes]

### Evidence Summary
**Primary Evidence**:
1. [Study 1]: Design, sample, findings, quality
2. [Study 2]: Design, sample, findings, quality

**Quality Rating**: [High / Moderate / Low / Very Low]

### Issues Identified
**Critical Issues**:
- [Issue threatening claim validity]

**Important Issues**:
- [Issue affecting interpretation]

**Logical Fallacies**:
- [Any fallacies identified]

### Verdict
☑ Well-Supported / ☐ Partially Supported / ☐ Poorly Supported / ☐ Not Supported

**Justification**: [2-3 sentences explaining verdict]

### Revised Claim (if needed)
"[More appropriate claim given evidence]"

### Confidence Level
[High / Moderate / Low / Very Low] confidence in [supporting / refuting] original claim.

### Additional Context
- [Broader evidence landscape]
- [Contradictory findings if any]
- [Gaps in evidence]

```

---

## Examples

### Example 1: Well-Supported Claim

**Claim**: "Meta-analyses show that CBT reduces depressive symptoms in adults with major depression"

**Verdict**: ☑ Well-Supported
- Multiple high-quality meta-analyses
- Large combined sample sizes
- Consistent moderate effect sizes (d ≈ 0.6-0.8)
- Appropriate hedging language
- Limitations typically acknowledged

---

### Example 2: Overclaimed

**Original**: "This study proves coffee prevents Alzheimer's"

**Evidence**: Single observational cohort study, n=500, showed association between coffee consumption and lower dementia risk over 10 years

**Issues**:
- "Proves" too strong (single study)
- Observational (confounding possible)
- "Prevents" implies causation (only association shown)

**Revised**: "One observational study (n=500) found an association between higher coffee consumption and lower risk of dementia over 10 years. However, observational design cannot establish causation, and confounding by lifestyle factors is possible."

---

### Example 3: Poorly Supported

**Claim**: "Homeopathy is effective for treating chronic pain"

**Evidence**: Mostly low-quality studies, high risk of bias, inconsistent results. High-quality systematic reviews show no effect beyond placebo.

**Verdict**: ☐ Not Supported
- Higher-quality evidence shows no effect
- Implausible mechanism
- Likely due to placebo and regression to mean

---

## Time Estimates

- **Quick check** (is claim plausible?): 5-10 min
- **Standard verification** (locate and assess evidence): 30-45 min
- **Thorough verification** (comprehensive evidence review): 1-2 hours

---

## Related Resources

**Guides:**
- [Claim Evaluation](../guides/claim-evaluation.md)
- [Evidence Assessment](../guides/evidence-assessment.md)
- [Fallacy Identification](../guides/fallacy-identification.md)
- [Methodology Critique](../guides/methodology-critique.md)
- [Bias Detection](../guides/bias-detection.md)
- [Statistical Evaluation](../guides/statistical-evaluation.md)

**References:**
- [Evidence Hierarchy](../references/evidence_hierarchy.md)
- [Logical Fallacies](../references/logical_fallacies.md)
- [Common Biases](../references/common_biases.md)
