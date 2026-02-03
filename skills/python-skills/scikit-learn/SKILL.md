---
name: scikit-learn
description: Use when building classification or regression models, performing clustering or dimensionality reduction, evaluating model performance, tuning hyperparameters, preprocessing data, building ML pipelines, or implementing classical machine learning workflows
---

# Scikit-learn

Industry-standard Python library for classical machine learning: classification, regression, clustering, dimensionality reduction, and preprocessing.

## When to Use

- Building classification or regression models
- Clustering or dimensionality reduction
- Preprocessing and transforming data
- Model evaluation with cross-validation
- Hyperparameter tuning
- Creating production-ready ML pipelines
- Comparing different algorithms
- Working with structured (tabular) or text data

## Quick Start

```python
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report

# Split data
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, stratify=y, random_state=42
)

# Preprocess
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Train
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train_scaled, y_train)

# Evaluate
y_pred = model.predict(X_test_scaled)
print(classification_report(y_test, y_pred))
```

## Core Capabilities

### 1. Supervised Learning
Classification and regression algorithms.
- **Linear**: Logistic Regression, Linear Regression, Ridge, Lasso
- **Tree-based**: Decision Trees, Random Forest, Gradient Boosting
- **SVM**: Support Vector Machines with various kernels
- **Others**: Naive Bayes, KNN, Neural Networks

**Reference:** `references/supervised_learning.md`

### 2. Unsupervised Learning
Clustering and dimensionality reduction.
- **Clustering**: K-Means, DBSCAN, Agglomerative, Gaussian Mixture
- **Dimensionality Reduction**: PCA, t-SNE, UMAP, NMF

**Reference:** `references/unsupervised_learning.md`

### 3. Model Evaluation
Cross-validation, hyperparameter tuning, metrics.
- **Cross-validation**: KFold, StratifiedKFold, TimeSeriesSplit
- **Tuning**: GridSearchCV, RandomizedSearchCV
- **Metrics**: Accuracy, precision, recall, F1, ROC AUC, MSE, R²

**Reference:** `references/model_evaluation.md`

### 4. Preprocessing
Transform data for machine learning.
- **Scaling**: StandardScaler, MinMaxScaler, RobustScaler
- **Encoding**: OneHotEncoder, OrdinalEncoder
- **Imputation**: SimpleImputer, KNNImputer, IterativeImputer
- **Feature Engineering**: PolynomialFeatures, Feature Selection

**Reference:** `references/preprocessing.md`

### 5. Pipelines
Build reproducible ML workflows.
- **Pipeline**: Chain transformers and estimators
- **ColumnTransformer**: Different preprocessing per column
- **FeatureUnion**: Combine transformers in parallel

**Reference:** `references/pipelines_and_composition.md`

## Complete Pipeline Example

```python
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.impute import SimpleImputer
from sklearn.ensemble import GradientBoostingClassifier

# Define transformers
numeric_transformer = Pipeline([
    ('imputer', SimpleImputer(strategy='median')),
    ('scaler', StandardScaler())
])

categorical_transformer = Pipeline([
    ('imputer', SimpleImputer(strategy='most_frequent')),
    ('onehot', OneHotEncoder(handle_unknown='ignore'))
])

# Combine
preprocessor = ColumnTransformer([
    ('num', numeric_transformer, numeric_features),
    ('cat', categorical_transformer, categorical_features)
])

# Full pipeline
model = Pipeline([
    ('preprocessor', preprocessor),
    ('classifier', GradientBoostingClassifier(random_state=42))
])

model.fit(X_train, y_train)
```

## Best Practices

1. **Always use pipelines** - Prevent data leakage, ensure consistency
2. **Fit on training data only** - Never fit on test data
3. **Use stratified splitting** - Preserve class distribution
4. **Set random state** - Ensure reproducibility
5. **Choose appropriate metrics** - Accuracy for balanced, ROC AUC for imbalanced
6. **Scale when needed** - SVM, KNN, Neural Networks require scaling

## Scripts

- **`scripts/classification_pipeline.py`** - Complete classification workflow
- **`scripts/clustering_analysis.py`** - Clustering with algorithm comparison

## References

- **`references/quick_reference.md`** - Common patterns and cheat sheets
- **`references/supervised_learning.md`** - All classification/regression algorithms
- **`references/unsupervised_learning.md`** - Clustering and dimensionality reduction
- **`references/model_evaluation.md`** - Cross-validation and tuning
- **`references/preprocessing.md`** - Feature scaling and encoding
- **`references/pipelines_and_composition.md`** - End-to-end pipeline patterns
