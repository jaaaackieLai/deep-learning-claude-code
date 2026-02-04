# Logical Fallacy Identification

## Overview

Detect and name logical errors in scientific arguments and claims. Fallacies are errors in reasoning that invalidate arguments, even if conclusions happen to be true.

## When to Apply

- Evaluating scientific claims
- Reviewing discussion/conclusion sections
- Assessing popular science communication
- Identifying flawed reasoning

## Common Fallacies in Science

### 1. Causation Fallacies

**Post hoc ergo propter hoc** ("After this, therefore because of this")
- Error: B followed A, so A caused B
- Example: "Crime dropped after we installed cameras, so cameras reduced crime"
- Problem: Ignores other factors, temporal trends, regression to mean

**Correlation = Causation**
- Error: Association mistaken for causation
- Example: "Ice cream sales correlate with drowning, so ice cream causes drowning"
- Problem: Confounding (both increase in summer)

**Reverse Causation**
- Error: Mistaking effect for cause
- Example: "Depression causes social isolation" (or does isolation cause depression?)
- Problem: Directionality unclear without temporal precedence

**Single Cause Fallacy**
- Error: Attributing complex outcomes to one factor
- Example: "Obesity is caused by sugar consumption"
- Problem: Multifactorial causation ignored

### 2. Generalization Fallacies

**Hasty Generalization**
- Error: Broad conclusions from small or unrepresentative samples
- Example: "Our study of 30 college students shows that all people..."
- Problem: Small, non-representative sample

**Anecdotal Fallacy**
- Error: Personal stories as proof
- Example: "My uncle smoked and lived to 90, so smoking isn't harmful"
- Problem: Individual cases don't establish general patterns

**Cherry-Picking**
- Error: Selecting only supporting evidence
- Example: Citing 3 studies that support claim, ignoring 20 that don't
- Problem: Selection bias in evidence presentation

**Ecological Fallacy**
- Error: Group patterns applied to individuals
- Example: "This country has high average income, so everyone there is wealthy"
- Problem: Group-level data ≠ individual-level predictions

### 3. Authority and Source Fallacies

**Appeal to Authority**
- Error: "Expert said it, so it's true" (without evidence)
- Valid: Expert opinion as evidence (but not proof)
- Invalid: Expert opinion as substitute for evidence
- Example: "Nobel laureate says X, therefore X is true"

**Ad Hominem**
- Error: Attacking person, not argument
- Example: "This researcher is funded by industry, so findings are wrong"
- Valid concern: Conflicts of interest (but evidence stands or falls on merits)

**Genetic Fallacy**
- Error: Judging by origin, not merits
- Example: "This study comes from a low-tier journal, so it's wrong"
- Problem: Origin ≠ quality (though they correlate)

**Appeal to Nature**
- Error: "Natural = good/safe"
- Example: "This supplement is natural, so it's safe"
- Problem: Many natural things are harmful (arsenic, hemlock)

### 4. Statistical Fallacies

**Base Rate Neglect**
- Error: Ignoring prior probability
- Example: "Positive test means 90% chance of disease" (ignoring 1% base rate)
- Problem: P(disease|test+) ≠ P(test+|disease)

**Texas Sharpshooter**
- Error: Finding patterns in random data
- Example: "This gene is associated with 10 diseases" (tested 10,000 genes)
- Problem: Multiple comparisons create false positives

**Multiple Comparisons** (as fallacy in interpretation)
- Error: Not correcting for multiple tests
- Example: "We found significant effects for 3 of 50 outcomes"
- Problem: Expect 2.5 false positives at α=.05

**Prosecutor's Fallacy**
- Error: Confusing P(E|H) with P(H|E)
- Example: "1 in million chance of this match, so 99.9999% guilty"
- Problem: Ignores prior probability of guilt

### 5. Structural Fallacies

**False Dichotomy**
- Error: "Either A or B" when more options exist
- Example: "Either genes or environment cause behavior"
- Problem: Gene-environment interaction exists

**Moving Goalposts**
- Error: Changing evidence standards after they're met
- Example: "Show me evidence... okay, that's not enough... show me more..."
- Problem: Unfalsifiable position

**Begging the Question** (Circular Reasoning)
- Error: Conclusion assumed in premises
- Example: "This study is reliable because it uses reliable methods"
- Problem: No independent support

**Straw Man**
- Error: Misrepresenting arguments to attack them
- Example: "Evolutionary theory claims humans came from monkeys"
- Problem: Attacking misrepresentation, not actual position

### 6. Science-Specific Fallacies

**Galileo Gambit**
- Error: "They laughed at Galileo, so my fringe idea is correct"
- Reality: They also laughed at countless wrong ideas
- Problem: Being ridiculed ≠ being right

**Argument from Ignorance**
- Error: "Not proven false, so true" (or vice versa)
- Example: "We can't rule out this hypothesis, so it must be true"
- Problem: Burden of proof on claimant

**Nirvana Fallacy**
- Error: Rejecting imperfect solutions because they're imperfect
- Example: "This vaccine is only 90% effective, so it's useless"
- Problem: Perfect shouldn't be enemy of good

**Unfalsifiability**
- Error: Making untestable claims
- Example: "This effect exists but can't be measured"
- Problem: Science requires testable predictions

## When Identifying Fallacies

**Do:**
- Name the specific fallacy
- Explain why the reasoning is flawed
- Identify what evidence would be needed for valid inference
- Note that fallacious reasoning doesn't prove conclusion false

**Don't:**
- Use fallacy identification as rhetorical weapon
- Assume fallacious argument = false conclusion
- Ignore the substance by focusing only on form
- Commit fallacy fallacy (assuming fallacious argument = wrong conclusion)

## Providing Feedback

**Structure:**

1. **Quote**: Cite the problematic statement
2. **Fallacy**: Name the specific fallacy
3. **Explanation**: Explain why it's fallacious
4. **Valid Alternative**: Show what valid reasoning would look like

**Example:**
> **Claim**: "We found significant effects in 3 of 20 analyses, proving our hypothesis."
>
> **Fallacy**: Multiple comparisons fallacy combined with cherry-picking.
>
> **Explanation**: With 20 tests at α=.05, we expect 1 false positive even if all nulls are true. Highlighting only the 3 "significant" results without correction inflates Type I error.
>
> **Valid approach**: Pre-specify primary outcome, apply correction (e.g., Bonferroni), or distinguish confirmatory from exploratory findings.

## Remember

- Fallacious reasoning invalidates the argument, not necessarily the conclusion
- Conclusions can be true despite flawed reasoning
- Focus on improving reasoning, not attacking conclusions
- Distinguish between formal fallacies (logical structure) and informal (content)

## Reference

For comprehensive fallacy catalog, see: [Logical Fallacies](../references/logical_fallacies.md)

---

**Related Guides:**
- [Claim Evaluation](claim-evaluation.md) - Assessing claim validity
- [Statistical Evaluation](statistical-evaluation.md) - Statistical reasoning
- [Evidence Assessment](evidence-assessment.md) - Weighing evidence strength
