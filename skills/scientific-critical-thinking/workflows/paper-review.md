# Paper Review Workflow

## Overview

Complete workflow for systematically reviewing scientific papers with critical evaluation.

## Workflow Steps

### Phase 1: Initial Assessment (10-15 minutes)

**1. Read Abstract and Conclusions**
- What is being claimed?
- What evidence is provided?
- Does it match your research question?

**2. Skim Methods**
- What design?
- Sample size adequate?
- Major red flags?

**3. Decision Point**
- Continue with full review?
- Sufficient quality and relevance?

---

### Phase 2: Detailed Reading (30-60 minutes)

**4. Introduction Review**
- Is rationale clear?
- Is gap in literature identified?
- Are hypotheses/aims specific and testable?

**5. Methods Deep Dive**

Use: [Methodology Critique Guide](../guides/methodology-critique.md)

Check:
- [ ] Study design appropriate for research question
- [ ] Sample size justified (power analysis?)
- [ ] Randomization (if applicable) properly described
- [ ] Blinding implemented where feasible
- [ ] Measurements validated and reliable
- [ ] Statistical analysis plan appropriate

Use: [Bias Detection Guide](../guides/bias-detection.md)

Look for:
- [ ] Selection bias (sampling, attrition)
- [ ] Measurement bias (observer, recall, instrument)
- [ ] Analysis bias (p-hacking, selective reporting)
- [ ] Confounding addressed

**6. Results Analysis**

Use: [Statistical Evaluation Guide](../guides/statistical-evaluation.md)

Verify:
- [ ] Sample characteristics described (Table 1)
- [ ] Attrition reported (CONSORT diagram)
- [ ] Statistical tests appropriate
- [ ] Assumptions checked
- [ ] Multiple comparisons handled
- [ ] Effect sizes and CIs reported
- [ ] P-values interpreted correctly
- [ ] Missing data handled appropriately

---

### Phase 3: Critical Evaluation (20-30 minutes)

**7. Discussion/Conclusions Assessment**

Use: [Claim Evaluation Guide](../guides/claim-evaluation.md)

Check:
- [ ] Do conclusions follow from results?
- [ ] Is claim strength proportional to evidence?
- [ ] Are limitations acknowledged?
- [ ] Are alternative explanations addressed?
- [ ] Is generalization justified?

Use: [Fallacy Identification Guide](../guides/fallacy-identification.md)

Watch for:
- Correlation → causation errors
- Overgeneralization
- Cherry-picking evidence
- Ignoring contradictory findings

**8. Overall Evidence Quality**

Use: [Evidence Assessment Guide](../guides/evidence-assessment.md)

Rate using GRADE or similar:
- Risk of bias: Low / Unclear / High
- Consistency: (if multiple outcomes)
- Directness: Direct / Indirect
- Precision: Adequate / Wide CIs
- Publication bias: Unlikely / Suspected

Overall quality: High / Moderate / Low / Very Low

---

### Phase 4: Synthesis (15-20 minutes)

**9. Prepare Summary**

**Strengths:**
- What was done well?
- What are the contributions?

**Weaknesses:**
- Critical issues (threaten main conclusions)
- Important issues (affect interpretation)
- Minor issues (worth noting)

**Overall Assessment:**
- What can be concluded?
- What cannot be concluded?
- How confident are we?

**Recommendations:**
- For this study: How to improve
- For future research: What's needed next

---

## Quick Reference Checklist

### Methods Quality
- [ ] Design matches research question
- [ ] Sample size adequate
- [ ] Randomization (if RCT) properly implemented
- [ ] Blinding where feasible
- [ ] Valid measurements
- [ ] Confounders controlled
- [ ] Statistical plan appropriate

### Results Integrity
- [ ] Complete reporting (no selective reporting)
- [ ] Effect sizes and CIs provided
- [ ] Multiple comparisons addressed
- [ ] Assumptions checked
- [ ] Missing data handled
- [ ] Tables/figures match text

### Conclusions Validity
- [ ] Supported by results
- [ ] Proportional to evidence
- [ ] Limitations acknowledged
- [ ] Generalization justified
- [ ] Alternative explanations considered

### Red Flags
- [ ] No power analysis with small sample
- [ ] High/differential attrition (>20%)
- [ ] Unvalidated measures
- [ ] P-hacking indicators (many tests, p~.05)
- [ ] Outcome switching (registration ≠ report)
- [ ] Limitations dismissed or ignored
- [ ] Conflicts of interest not disclosed

---

## Output Template

```markdown
## Paper Review: [Title]

**Citation**: [Full citation]

**Research Question**: [PICO format if applicable]

**Study Design**: [Type, brief description]

### Strengths
1. [Strength 1]
2. [Strength 2]
3. [Strength 3]

### Critical Issues
1. [Issue threatening validity of main conclusions]

### Important Issues
1. [Issue affecting interpretation but not fatally]
2. [Another important issue]

### Minor Issues
1. [Worth noting but doesn't change conclusions]

### Statistical/Methodological Comments
- [Specific statistical or methodological points]

### Overall Assessment
**Evidence Quality**: [High/Moderate/Low/Very Low]

**Main Conclusions Supported**: [Yes/Partially/No]

**Confidence in Findings**: [High/Moderate/Low/Very Low]

**Summary**: [2-3 sentences on what can be concluded and key limitations]

### Recommendations
**For Authors**: [Suggestions for improvement]

**For Future Research**: [What studies are needed next]

```

---

## Time Estimates

- **Quick review** (check relevance): 10-15 min
- **Standard review** (full critical appraisal): 60-90 min
- **Detailed review** (for meta-analysis or guideline): 2-3 hours

---

## Related Resources

**Guides:**
- [Methodology Critique](../guides/methodology-critique.md)
- [Bias Detection](../guides/bias-detection.md)
- [Statistical Evaluation](../guides/statistical-evaluation.md)
- [Evidence Assessment](../guides/evidence-assessment.md)
- [Claim Evaluation](../guides/claim-evaluation.md)

**References:**
- [Scientific Method](../references/scientific_method.md)
- [Common Biases](../references/common_biases.md)
- [Statistical Pitfalls](../references/statistical_pitfalls.md)
- [Evidence Hierarchy](../references/evidence_hierarchy.md)
