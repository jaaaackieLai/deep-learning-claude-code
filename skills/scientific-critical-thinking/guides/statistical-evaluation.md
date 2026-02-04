# Statistical Analysis Evaluation

## Overview

Critically assess statistical methods, interpretation, and reporting. Statistical analysis is the foundation for quantitative claims, and errors here can invalidate conclusions.

## When to Apply

- Reviewing quantitative research
- Evaluating data-driven claims
- Assessing clinical trial results
- Reviewing meta-analyses

## Statistical Review Checklist

### 1. Sample Size and Power

**Questions:**
- Was a priori power analysis conducted?
- Is sample adequate for detecting meaningful effects?
- Is the study underpowered?
- Do significant results from small samples raise flags for inflated effect sizes?

**What to check:**
- Power analysis reported in methods
- Sample size justification
- Achieved power (post-hoc)
- Effect sizes consistent with sample size

**Red flags:**
- No power analysis
- Very small samples (n < 30) claiming significant effects
- Large samples finding trivial but "significant" effects
- Underpowered studies claiming "no effect"

### 2. Statistical Tests

**Appropriateness:**
- Are tests appropriate for data type and distribution?
- Were test assumptions checked and met?
- Are parametric tests justified, or should non-parametric alternatives be used?
- Is the analysis matched to study design (e.g., paired vs. independent)?

**Common assumptions to check:**
- Normality (for parametric tests)
- Homogeneity of variance
- Independence of observations
- Linearity (for regression)

**Red flags:**
- No mention of assumption checking
- Obvious violations (e.g., Likert scales treated as continuous)
- Wrong test for design (e.g., unpaired test for paired data)

### 3. Multiple Comparisons

**The problem:**
Testing multiple hypotheses inflates Type I error rate. With 20 tests at α=.05, expect 1 false positive even if all nulls are true.

**Assessment:**
- Were multiple hypotheses tested?
- Was correction applied (Bonferroni, FDR, Holm, etc.)?
- Are primary outcomes distinguished from secondary/exploratory?
- Could findings be false positives from multiple testing?

**Corrections:**
- Bonferroni: Most conservative, divides α by number of tests
- False Discovery Rate (FDR): Controls proportion of false positives
- Holm-Bonferroni: Sequential method, less conservative
- Pre-specify primary outcome: Limits need for correction

**Red flags:**
- Many tests, no correction
- All p-values just below .05
- No distinction between primary and exploratory

### 4. P-Value Interpretation

**Correct interpretation:**
P-value is the probability of observing data this extreme (or more extreme) if the null hypothesis is true. It is NOT:
- The probability the null is true
- The probability the alternative is false
- The probability results are due to chance
- A measure of effect size or importance

**Common errors:**
- "p < .05 proves the effect exists"
- "p > .05 proves there is no effect"
- "p = .049 is meaningful, p = .051 is meaningless"
- Conflating statistical significance with practical importance

**What to check:**
- Are exact p-values reported, or only "p < .05"?
- Is non-significance incorrectly interpreted as "no effect"?
- Is statistical significance conflated with practical importance?
- Is there suspicious clustering just below .05?

### 5. Effect Sizes and Confidence Intervals

**Why they matter:**
Effect sizes show magnitude; confidence intervals show precision. Both are more informative than p-values alone.

**Assessment:**
- Are effect sizes reported alongside significance?
- Are confidence intervals provided?
- Is the effect size meaningful in practical terms?
- Are standardized effect sizes interpreted with field-specific context?

**Common effect sizes:**
- Cohen's d (mean differences)
- Correlation coefficients (r, R²)
- Odds ratios, risk ratios
- Eta-squared, omega-squared (ANOVA)

**Interpretation:**
- Small, medium, large depend on field
- Wide CIs indicate uncertainty
- CIs excluding zero/one indicate significance
- Practical vs. statistical significance

**Red flags:**
- No effect sizes reported
- No confidence intervals
- Tiny effects treated as important
- Large effects dismissed as "not significant"

### 6. Missing Data

**Questions:**
- How much data is missing?
- Is missing data mechanism considered (MCAR, MAR, MNAR)?
- How is missing data handled?
- Could missing data bias results?

**Missing data mechanisms:**
- **MCAR** (Missing Completely at Random): Missingness unrelated to any variable
- **MAR** (Missing at Random): Missingness related to observed variables
- **MNAR** (Missing Not at Random): Missingness related to unobserved values

**Handling methods:**
- **Listwise deletion**: Complete cases only (loses power, biased if not MCAR)
- **Pairwise deletion**: Use all available data (inconsistent samples)
- **Imputation**: Replace missing values (simple or multiple imputation)
- **Maximum likelihood**: Model missing data (e.g., FIML)

**Red flags:**
- >10% missing, no discussion
- Listwise deletion with MAR/MNAR data
- Single imputation without uncertainty quantification

### 7. Regression and Modeling

**Common issues:**
- **Overfitting**: Too many predictors, no cross-validation
- **Extrapolation**: Predictions outside data range
- **Multicollinearity**: Highly correlated predictors
- **Assumption violations**: Non-linearity, heteroscedasticity

**Assessment:**
- Is the model overfitted (predictors/observations ratio)?
- Are predictions made outside the data range?
- Are multicollinearity issues addressed (VIF)?
- Are model assumptions checked (residual plots)?

**Red flags:**
- More predictors than observations/10
- R² = .99 (suspiciously perfect fit)
- No cross-validation or out-of-sample testing
- No diagnostic plots

### 8. Common Statistical Pitfalls

**Correlation ≠ Causation**
- Correlation shows association, not causation
- Need: temporal precedence, mechanism, ruling out confounds

**Regression to the Mean**
- Extreme values tend toward average on retest
- Can create illusion of treatment effect

**Base Rate Neglect**
- Ignoring prior probability
- Example: Rare disease, positive test doesn't mean you have it

**Texas Sharpshooter Fallacy**
- Finding patterns in random data
- Drawing target around bullet holes after shooting

**Simpson's Paradox**
- Trend reverses when data aggregated vs. disaggregated
- Confounding by subgroups

## Providing Feedback

**Structure:**

1. **Issue Identification**: Name the statistical problem
2. **Evidence**: Point to specific results or tables
3. **Impact**: Explain how it affects conclusions
4. **Recommendation**: Suggest correct approach

**Example:**
> "Multiple comparison issue: Table 2 reports 15 pairwise comparisons with no correction for multiple testing. At α=.05, we expect 0.75 false positives even if all nulls are true. The three 'significant' findings (p=.042, .037, .048) may be false positives. Recommend: Apply Holm-Bonferroni correction or pre-specify primary comparisons."

## Reference

For detailed statistical pitfalls, see: [Statistical Pitfalls](../references/statistical_pitfalls.md)

---

**Related Guides:**
- [Methodology Critique](methodology-critique.md) - Overall design evaluation
- [Evidence Assessment](evidence-assessment.md) - Weighing evidence strength
- [Research Design](research-design.md) - Planning statistical analyses
