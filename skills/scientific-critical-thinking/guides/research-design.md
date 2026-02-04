# Research Design Guidance

## Overview

Provide constructive guidance for planning rigorous studies. Good design prevents problems that no amount of analysis can fix.

## When to Apply

- Helping design new experiments
- Planning research projects
- Reviewing research proposals
- Improving study protocols

## Design Process

### 1. Research Question Refinement

**FINER criteria** for good research questions:
- **Feasible**: Can it be done with available resources?
- **Interesting**: Does it matter?
- **Novel**: Does it fill a gap?
- **Ethical**: Can it be conducted ethically?
- **Relevant**: Will results be useful?

**Make it specific:**
- Vague: "Does exercise improve health?"
- Specific: "Does 30 minutes of aerobic exercise 3x/week for 12 weeks reduce systolic blood pressure in adults with hypertension?"

**Ensure falsifiability:**
- Must be possible to prove wrong
- Predictions must be testable
- Outcome criteria must be measurable

**PICO framework** (for intervention questions):
- **P**opulation: Who?
- **I**ntervention: What treatment?
- **C**omparison: Compared to what?
- **O**utcome: Measuring what?

### 2. Design Selection

**Match design to question:**

**Causal questions** → Experimental designs
- RCTs (gold standard)
- Quasi-experimental (when randomization impossible)
- Natural experiments (exploit natural variation)

**Associational questions** → Observational designs
- Cohort (follow over time)
- Case-control (compare cases to controls)
- Cross-sectional (snapshot in time)

**Descriptive questions** → Surveys, case series
- Prevalence studies
- Case reports

**Design choices:**
- **Between-subjects**: Different participants in each condition (simpler, need more participants)
- **Within-subjects**: Same participants in all conditions (more powerful, order effects)
- **Mixed designs**: Combination (flexible, complex)

**Factorial designs** for multiple factors:
- Test multiple variables simultaneously
- Examine interactions
- More efficient than separate studies

### 3. Bias Minimization Strategy

**By design:**

**Randomization**
- Purpose: Eliminate systematic group differences
- Method: Random sequence generation + allocation concealment
- Check: Compare baseline characteristics

**Blinding**
- Participants: Prevent placebo effects, response bias
- Providers: Prevent differential treatment
- Assessors: Prevent detection bias
- Double-blind: Participants + providers
- Triple-blind: Add data analysts

**Control groups**
- Placebo control: Isolate treatment effect from placebo effect
- Active control: Compare to standard treatment
- Wait-list control: Everyone gets treatment eventually
- No-treatment control: Natural course

**Confound control**
- Randomization: Distributes confounds randomly
- Matching: Match participants on confounders
- Stratification: Randomize within strata
- Restriction: Limit to homogeneous sample
- Statistical adjustment: Control in analysis

### 4. Sample Planning

**Power analysis (a priori):**
1. Specify expected effect size (from literature or pilot)
2. Set desired power (typically .80)
3. Set alpha level (typically .05)
4. Calculate required sample size

**Account for attrition:**
- Estimate dropout rate from similar studies
- Inflate sample size accordingly
- Example: Need n=100, expect 20% dropout → recruit 125

**Inclusion/exclusion criteria:**
- Clear, objective, justified
- Balance homogeneity (internal validity) with representativeness (external validity)
- Document rationale

**Sampling strategy:**
- Random sampling: Everyone has equal probability
- Stratified: Random within subgroups
- Cluster: Sample groups, then individuals
- Convenience: Easiest to access (weakest)

### 5. Measurement Strategy

**Instrument selection:**
- Use validated instruments when available
- Report psychometric properties (reliability, validity)
- Cite validation studies

**Reliability** (consistency):
- Test-retest: Stable over time?
- Internal consistency: Items measure same construct? (Cronbach's α > .70)
- Inter-rater: Different raters agree? (κ > .70)

**Validity** (accuracy):
- Content: Covers domain?
- Criterion: Predicts relevant outcome?
- Construct: Measures intended construct?
- Discriminant: Doesn't measure unintended constructs?

**Measurement approaches:**
- Objective when possible (biomarkers, behavioral observations)
- Subjective with acknowledged limitations (self-report, ratings)
- Multiple measures (triangulation)
- Primary outcome clearly designated

### 6. Analysis Planning

**Pre-specify:**
- All hypotheses (primary and secondary)
- Primary outcome
- Statistical tests
- Subgroup analyses (with interaction tests)
- Handling of missing data
- Sensitivity analyses

**Statistical considerations:**
- Check assumptions before analysis
- Plan diagnostic tests
- Specify effect sizes and CIs
- Plan for multiple comparison correction
- Consider intention-to-treat vs. per-protocol

**Analysis plan should include:**
- Sample description
- Primary analysis
- Secondary analyses
- Exploratory analyses (clearly labeled)
- Sensitivity analyses
- Missing data handling

### 7. Transparency and Rigor

**Pre-registration:**
- Register study before data collection (ClinicalTrials.gov, OSF)
- Specify hypotheses, methods, analyses
- Prevents HARKing and p-hacking
- Increases credibility

**Reporting guidelines:**
- CONSORT (RCTs)
- STROBE (observational)
- PRISMA (systematic reviews)
- STARD (diagnostic accuracy)

**Open science practices:**
- Share data when possible
- Share code for reproducibility
- Pre-print for rapid dissemination
- Report all outcomes (not just significant)

## Common Design Pitfalls to Avoid

1. **Underpowered studies**: Do power analysis first
2. **Poorly defined outcomes**: Operationalize clearly
3. **Confounding**: Identify and control
4. **Measurement error**: Use validated instruments
5. **Attrition**: Minimize and account for dropout
6. **HARKing**: Pre-specify hypotheses
7. **P-hacking**: Pre-specify analyses
8. **Selective reporting**: Report all planned analyses

## Providing Guidance

**Structure:**

1. **Question Assessment**: Is question clear, specific, answerable?
2. **Design Recommendation**: Which design best answers question?
3. **Bias Prevention**: How to minimize key biases?
4. **Sample Planning**: What sample size and strategy?
5. **Measurement**: Which instruments and procedures?
6. **Analysis Plan**: Pre-specify analyses
7. **Transparency**: Pre-registration and reporting

**Example:**
> **Question**: Clear and specific. PICO well-defined.
>
> **Design**: Recommend parallel-group RCT. Randomization feasible and ethical. Blinding possible for outcome assessors.
>
> **Bias prevention**: Random sequence generation via computer. Allocation concealment via sealed envelopes. Blinded outcome assessment.
>
> **Sample**: Power analysis shows n=120 (60/group) for 80% power to detect d=0.5 at α=.05. Account for 20% attrition → recruit 150.
>
> **Measurement**: Use validated XYZ scale (α=.89, validity established). Measure at baseline, 4, 8, 12 weeks.
>
> **Analysis**: Pre-specify linear mixed model with time × group interaction. Intention-to-treat primary analysis. Per-protocol sensitivity analysis.
>
> **Transparency**: Register at ClinicalTrials.gov before enrollment. Follow CONSORT reporting.

## Reference

For comprehensive design checklist, see: [Experimental Design](../references/experimental_design.md)

---

**Related Guides:**
- [Methodology Critique](methodology-critique.md) - Evaluating designs
- [Bias Detection](bias-detection.md) - Identifying biases to prevent
- [Statistical Evaluation](statistical-evaluation.md) - Planning analyses
