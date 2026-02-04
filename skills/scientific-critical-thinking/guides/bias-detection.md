# Bias Detection

## Overview

Identify and evaluate potential sources of bias that could distort findings. Bias can enter at multiple stages: design, sampling, measurement, analysis, and reporting.

## When to Apply

- Reviewing published research
- Designing new studies
- Interpreting conflicting evidence
- Assessing research quality

## Systematic Bias Review

### 1. Cognitive Biases (Researcher)

**Confirmation bias**: Are only supporting findings highlighted?
- Look for: Selective emphasis on confirmatory results
- Check: Are disconfirming results discussed fairly?

**HARKing** (Hypothesizing After Results are Known): Were hypotheses stated a priori or formed after seeing results?
- Look for: Preregistration or analysis plans
- Red flag: Hypotheses that perfectly match results

**Publication bias**: Are negative results missing from literature?
- Look for: Systematic reviews noting missing studies
- Check: Funnel plot asymmetry in meta-analyses

**Cherry-picking**: Is evidence selectively reported?
- Look for: All outcomes from registration reported
- Red flag: Switched or missing outcomes

**Detection:**
- Check for preregistration and analysis plan transparency
- Compare registered vs. reported outcomes
- Review supplementary materials for unreported analyses

### 2. Selection Biases

**Sampling bias**: Is sample representative of target population?
- Assess: Recruitment methods and inclusion criteria
- Red flag: Convenience sampling for population claims

**Volunteer bias**: Do participants self-select in systematic ways?
- Consider: Who volunteers vs. who doesn't
- Impact: Volunteers may be more motivated, healthier, or different

**Attrition bias**: Is dropout differential between groups?
- Check: Dropout rates and reasons by group
- Red flag: >20% dropout or differential dropout

**Survivorship bias**: Are only "survivors" visible in sample?
- Consider: What missing cases would look like
- Example: Success stories without failures

**Assessment:**
- Examine participant flow diagrams (CONSORT)
- Compare baseline characteristics across groups
- Analyze missing data patterns
- Consider intention-to-treat vs. per-protocol analyses

### 3. Measurement Biases

**Observer bias**: Could expectations influence observations?
- Risk: Subjective measurements, unblinded assessors
- Mitigation: Blinding, objective measures, standardization

**Recall bias**: Are retrospective reports systematically inaccurate?
- Risk: Long recall periods, differential memory
- Mitigation: Prospective measurement, validation

**Social desirability**: Are responses biased toward acceptability?
- Risk: Sensitive topics, face-to-face interviews
- Mitigation: Anonymous surveys, indirect measures

**Instrument bias**: Do measurement tools systematically err?
- Risk: Uncalibrated equipment, unvalidated scales
- Mitigation: Calibration, validation studies

**Evaluation:**
- Check blinding of outcome assessors
- Review validation evidence for instruments
- Assess measurement objectivity

### 4. Analysis Biases

**P-hacking**: Were multiple analyses conducted until significance emerged?
- Look for: Many analyses, focus on p < .05
- Red flag: Suspicious clustering just below .05

**Outcome switching**: Were non-significant outcomes replaced with significant ones?
- Compare: Registered vs. reported outcomes
- Red flag: Primary outcome changes

**Selective reporting**: Are all planned analyses reported?
- Check: Supplementary materials, protocols
- Red flag: Mentioned but unreported analyses

**Subgroup fishing**: Were subgroup analyses conducted without correction?
- Look for: Multiple subgroups, post-hoc analyses
- Red flag: Subgroup claims without interaction tests

**Detection:**
- Check study registration (ClinicalTrials.gov, OSF)
- Compare protocol to published report
- Look for analysis plan transparency

### 5. Confounding

**What is confounding?**
Variables that affect both exposure and outcome, creating spurious associations.

**Assessment questions:**
- What variables could affect both exposure and outcome?
- Were confounders measured and controlled (statistically or by design)?
- Could unmeasured confounding explain findings?
- Are there plausible alternative explanations?

**Control methods:**
- **By design**: Randomization, matching, restriction
- **By analysis**: Regression adjustment, stratification, propensity scores

**Red flags:**
- Observational studies without confounder control
- Claims of causation without addressing confounding
- Measured confounders not controlled in analysis

## Bias Risk Assessment Tools

### Cochrane Risk of Bias (RCTs)
- Random sequence generation
- Allocation concealment
- Blinding of participants and personnel
- Blinding of outcome assessment
- Incomplete outcome data
- Selective reporting

### Newcastle-Ottawa Scale (Observational)
- Selection of cohorts
- Comparability of cohorts
- Assessment of outcome

### GRADE Approach
Rate down for:
- Risk of bias (study limitations)
- Inconsistency
- Indirectness
- Imprecision
- Publication bias

## Providing Feedback

**Structure:**

1. **Bias Identified**: Name the specific bias
2. **Evidence**: Point to specific indicators
3. **Impact**: Assess how it affects conclusions
4. **Mitigation**: Suggest how to reduce or account for it

**Example:**
> "Selection bias is present due to convenience sampling (Methods, p.3). Participants were recruited from a university population, which may systematically differ from the general population in age, education, and health. This limits generalizability to broader populations. Future studies should consider random or stratified sampling to improve representativeness."

## Reference

For comprehensive bias taxonomy, see: [Common Biases](../references/common_biases.md)

---

**Related Guides:**
- [Methodology Critique](methodology-critique.md) - Overall design evaluation
- [Research Design](research-design.md) - Designing to minimize bias
- [Statistical Evaluation](statistical-evaluation.md) - Analysis bias detection
