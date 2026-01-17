# Housing Price Prediction - MATLAB Project

## Overview

This MATLAB project performs comprehensive housing price prediction and analysis using multiple linear regression. The project includes two main scripts:

- `housing_predict.m`: Complete housing price prediction model with data preprocessing, training, evaluation, and visualization
- `graphtest.m`: Simple sine wave plotting demonstration

## Table of Contents

- [Requirements](#requirements)
- [Dataset Description](#dataset-description)
- [Installation](#installation)
- [Usage](#usage)
- [Script Details](#script-details)
- [Model Performance](#model-performance)
- [Troubleshooting](#troubleshooting)

## Requirements

### Software

- **MATLAB** R2016b or later (recommended: R2019a or later)
- Required Toolboxes:
  - Statistics and Machine Learning Toolbox
  - (Optional) Curve Fitting Toolbox

### Hardware

- Minimum 4GB RAM
- Any modern processor (Intel i3 or equivalent)

## Dataset Description

The project uses a housing dataset (`Housing.csv`) located in the `archive/` folder with the following features:

### Variables

| Variable Name      | Type        | Description                   | Values                               |
| ------------------ | ----------- | ----------------------------- | ------------------------------------ |
| `price`            | Numeric     | Target variable - House price | Continuous value                     |
| `area`             | Numeric     | Living area in square feet    | Continuous value                     |
| `bedrooms`         | Numeric     | Number of bedrooms            | Integer (1-6)                        |
| `bathrooms`        | Numeric     | Number of bathrooms           | Integer (1-4)                        |
| `stories`          | Numeric     | Number of floors/stories      | Integer (1-4)                        |
| `mainroad`         | Categorical | Access to main road           | yes/no                               |
| `guestroom`        | Categorical | Has guest room                | yes/no                               |
| `basement`         | Categorical | Has basement                  | yes/no                               |
| `hotwaterheating`  | Categorical | Has hot water heating         | yes/no                               |
| `airconditioning`  | Categorical | Has air conditioning          | yes/no                               |
| `parking`          | Numeric     | Number of parking spaces      | Integer (0-3)                        |
| `prefarea`         | Categorical | Located in preferred area     | yes/no                               |
| `furnishingstatus` | Categorical | Furnishing status             | furnished/semi-furnished/unfurnished |

**Dataset Size**: 545 housing records with 13 variables

## Installation

1. **Clone or Download** this repository to your local machine
2. **Ensure the file structure** is maintained:
   ```
   1_housing/
   ├── housing_predict.m
   ├── graphtest.m
   ├── README.md
   └── archive/
       └── Housing.csv
   ```
3. **Open MATLAB** and navigate to the project directory:
   ```matlab
   cd 'c:\1_research\13_matlab\1_housing'
   ```

## Usage

### Method 1: Running the Main Housing Prediction Script

1. **Launch MATLAB** and navigate to the project folder
2. **Run the script** by typing in the Command Window:
   ```matlab
   housing_predict
   ```
3. The script will automatically:
   - Search for `Housing.csv` in the current directory
   - If not found, a file selection dialog will appear
   - Process the data and build the regression model
   - Display results and generate visualizations

### Method 2: Step-by-Step Execution

You can also run the script section by section using MATLAB's cell mode:

1. Open `housing_predict.m` in the MATLAB Editor
2. Click on any section (marked with `%%`)
3. Press `Ctrl+Enter` (Windows) or `Cmd+Enter` (Mac) to execute that section

### Method 3: Running the Simple Graph Test

To test basic MATLAB plotting functionality:

```matlab
graphtest
```

This will create a simple sine wave plot.

## Script Details

### housing_predict.m - Main Analysis Pipeline

#### Section 1: Initialization and Data Loading

```matlab
%% 1. initialization and data load
```

- Clears workspace and closes all figures
- Loads `Housing.csv` using `readtable()`
- Implements robust file-finding mechanism with GUI fallback
- Validates data integrity (checks for minimum column count)
- Preserves original variable names to handle special characters

**Key Features**:

- Automatic file search with user-friendly file picker dialog
- Error handling for missing or corrupted files
- Data validation checks

#### Section 2: Variable Name Normalization

```matlab
%% 2. variable normalization
```

- Converts all variable names to lowercase
- Removes special characters (parentheses, spaces, etc.)
- Automatically identifies the target variable `price`
- If `price` is not found, uses the first column as target

**Why This Matters**: Different CSV formats may have variations in column naming (e.g., "Price", "price", "Price(USD)"). This normalization ensures robust handling.

#### Section 3: Data Preprocessing

```matlab
%% 3. data preprocessing
```

- **Categorical to Numeric Conversion**:
  - Binary variables (`mainroad`, `guestroom`, `basement`, etc.): `'yes'` → `1`, `'no'` → `0`
  - Multi-class variable (`furnishingstatus`): Converts to numeric codes using MATLAB's `categorical()` function

**Variables Processed**:

- `mainroad`, `guestroom`, `basement`, `hotwaterheating`
- `airconditioning`, `prefarea` (binary encoding)
- `furnishingstatus` (categorical encoding)

#### Section 4: Correlation Analysis

```matlab
%% 4. Correlation heatmap between variables
```

- Generates a correlation matrix for all numeric variables
- Creates an interactive heatmap visualization
- Helps identify multicollinearity and feature relationships

**Interpretation**:

- Values close to +1: Strong positive correlation
- Values close to -1: Strong negative correlation
- Values near 0: Weak or no correlation

#### Section 5: Multiple Linear Regression

```matlab
%% 5. multi regression model
```

- **Data Splitting**: 80% training, 20% testing (using `cvpartition`)
- **Model Training**: Uses `fitlm()` with explicit `ResponseVar` specification
- Avoids formula parsing errors by using structured options

**Regression Equation**:
The model estimates:
$$\text{Price} = \beta_0 + \beta_1 \cdot \text{area} + \beta_2 \cdot \text{bedrooms} + \ldots + \epsilon$$

#### Section 6: Model Performance Evaluation

```matlab
%% 6. model performance evaluation
```

Calculates key metrics:

- **R-Squared (R²)**: Proportion of variance explained (0 to 1, higher is better)
- **RMSE (Root Mean Squared Error)**: Average prediction error in price units

**Formulas**:

- $\text{RMSE} = \sqrt{\frac{1}{n} \sum_{i=1}^{n} (y_i - \hat{y}_i)^2}$
- $R^2 = 1 - \frac{\text{SS}_{\text{res}}}{\text{SS}_{\text{tot}}}$

#### Section 7: Visualization

```matlab
%% 7. result visualization
```

Creates a two-panel figure:

**Subplot 1: Actual vs Predicted**

- Scatter plot comparing true prices vs model predictions
- Red dashed line represents perfect prediction
- Points close to the line indicate good predictions

**Subplot 2: Residual Plot**

- Shows prediction errors (residuals) as stem plot
- Helps identify systematic prediction biases
- Ideally should be randomly distributed around zero

### graphtest.m - Simple Plotting Demo

Creates a sine wave with offset:

- Generates x values from 0 to 10 with 0.1 step
- Computes $y = \sin(x) + 0.5$
- Plots with red line, grid, and labels

**Purpose**: Test basic MATLAB graphics functionality

## Model Performance

### Expected Output

When you run `housing_predict.m`, you should see:

```
--- Raw Data Loaded ---
(First 3 rows of the dataset displayed)

>> target variable "price" was found.

--- Training Regression Model ---
(Linear regression model summary with coefficients)

>>> [Model Performance] <<<
1. R-Squared (Test) : 0.XXXX
2. RMSE             : XXXXXX.XX
```

### Typical Performance Metrics

Based on the housing dataset:

- **R-Squared**: Typically 0.65-0.75 (65-75% of price variance explained)
- **RMSE**: Approximately 1,000,000-1,500,000 (depends on price scale)

### Interpreting Coefficients

The model summary shows which features most strongly affect price:

- **Positive coefficients**: Increase in feature → increase in price (e.g., area, bathrooms)
- **Negative coefficients**: Increase in feature → decrease in price (rare in this dataset)
- **p-values < 0.05**: Statistically significant predictors

## Visualizations

The script generates two figures:

### Figure 1: Correlation Heatmap

- **Size**: Full matrix of all variables
- **Color coding**:
  - Dark red: Strong positive correlation
  - Dark blue: Strong negative correlation
  - White/Light: Weak correlation
- **Use**: Identify which features are related to price

### Figure 2: Regression Results (2 subplots)

**Top Panel**: Actual vs Predicted Prices

- Each blue point represents one house
- Perfect predictions lie on the red diagonal line
- Spread indicates prediction uncertainty

**Bottom Panel**: Residuals

- Black vertical lines show error for each prediction
- Positive values: Model underpredicted (actual > predicted)
- Negative values: Model overpredicted (actual < predicted)
- Random scatter = good model; patterns = model bias

## Troubleshooting

### Common Issues and Solutions

#### Issue 1: "File not found" Error

**Problem**: MATLAB cannot locate `Housing.csv`

**Solution**:

1. Verify the file exists in `archive/` folder
2. Check file name spelling (case-sensitive on some systems)
3. Use the file picker dialog that appears automatically
4. Manually specify path:
   ```matlab
   filename = 'archive\Housing.csv';
   ```

#### Issue 2: "Unable to understand formula" Error

**Problem**: Older MATLAB versions may not support formula syntax

**Solution**: The script already uses the safe `'ResponseVar'` method. If still failing:

1. Update MATLAB to R2019a or later
2. Manually specify predictors:
   ```matlab
   X = train_data{:, setdiff(train_data.Properties.VariableNames, {target_var})};
   y = train_data.(target_var);
   mdl = fitlm(X, y);
   ```

#### Issue 3: "Undefined function 'fitlm'" Error

**Problem**: Statistics and Machine Learning Toolbox not installed

**Solution**:

1. Check installed toolboxes: `ver`
2. Install via MATLAB Add-On Explorer
3. Alternative: Use basic `regress()` function (less features)

#### Issue 4: Categorical Variables Not Converting

**Problem**: Binary variables still showing as text

**Solution**: The script handles this automatically, but verify:

```matlab
% Check data types
summary(data)

% Manual conversion if needed
data.mainroad = double(strcmp(data.mainroad, 'yes'));
```

#### Issue 5: Poor Model Performance (Low R²)

**Problem**: R-Squared below 0.5

**Possible Causes**:

1. **Data quality**: Missing values or outliers
2. **Feature engineering needed**: Try polynomial features or interactions
3. **Non-linear relationships**: Consider other models (e.g., regression trees)

**Diagnostic Steps**:

```matlab
% Check for missing values
sum(ismissing(data), 1)

% Check for outliers
boxplot(data.price)

% Try log transformation for price
data.log_price = log(data.price);
```

#### Issue 6: Figures Not Appearing

**Problem**: Scripts run but no plots visible

**Solution**:

```matlab
% Ensure figures aren't hidden
shg  % Show most recent graph

% Check if figures were closed
set(0, 'DefaultFigureVisible', 'on')

% Redock figures if needed
set(0, 'DefaultFigureWindowStyle', 'docked')
```

## Advanced Usage

### Customizing the Model

#### Adding Feature Interactions

```matlab
% Create interaction term: area × bedrooms
train_data.area_bed = train_data.area .* train_data.bedrooms;
test_data.area_bed = test_data.area .* test_data.bedrooms;
```

#### Using Polynomial Features

```matlab
% Fit quadratic model
mdl = fitlm(train_data, 'poly2', 'ResponseVar', target_var);
```

#### Cross-Validation

```matlab
% K-fold cross-validation (10 folds)
cv = cvpartition(height(data), 'KFold', 10);
mse_cv = zeros(10, 1);

for i = 1:10
    train_idx = training(cv, i);
    test_idx = test(cv, i);

    mdl_temp = fitlm(data(train_idx, :), 'ResponseVar', target_var);
    pred_temp = predict(mdl_temp, data(test_idx, :));
    mse_cv(i) = mean((data.(target_var)(test_idx) - pred_temp).^2);
end

fprintf('Average CV RMSE: %.2f\n', sqrt(mean(mse_cv)));
```

### Exporting Results

#### Save Model

```matlab
save('housing_model.mat', 'mdl');
```

#### Export Predictions

```matlab
results = table(y_true, y_pred, y_true - y_pred, ...
    'VariableNames', {'Actual', 'Predicted', 'Residual'});
writetable(results, 'predictions.csv');
```

#### Save Figures

```matlab
% High-resolution PNG
saveas(gcf, 'correlation_heatmap.png');

% Vector graphics (publication quality)
saveas(gcf, 'regression_results.svg');
```

## Code Structure Best Practices

This project demonstrates several MATLAB best practices:

1. **Modular Sections**: Code divided into logical sections with `%%`
2. **Robust Error Handling**: File validation and user fallbacks
3. **Variable Name Safety**: Automated normalization for compatibility
4. **Data Validation**: Type checking and conversion
5. **Comprehensive Visualization**: Multiple complementary plots
6. **Performance Metrics**: Quantitative evaluation with R² and RMSE

## Further Reading

### MATLAB Documentation

- [fitlm() - Linear Regression](https://www.mathworks.com/help/stats/fitlm.html)
- [cvpartition() - Cross-Validation](https://www.mathworks.com/help/stats/cvpartition.html)
- [heatmap() - Visualization](https://www.mathworks.com/help/matlab/ref/heatmap.html)

### Statistical Concepts

- **Multiple Linear Regression**: Understanding coefficients and p-values
- **Cross-Validation**: Techniques for model validation
- **Residual Analysis**: Diagnosing model assumptions

### Potential Extensions

1. **Feature Engineering**: Create derived variables (price per sq ft, room ratios)
2. **Model Comparison**: Try decision trees, SVMs, or neural networks
3. **Regularization**: Apply Ridge or Lasso regression for feature selection
4. **Time Series**: If date information available, analyze price trends
5. **Geographic Analysis**: If location data available, spatial patterns

## License

This project is provided for educational and research purposes.

## Author

Created by seonwoo kang

## Version History

- **v1.0** (2026-01-15): Initial release with robust error handling and comprehensive documentation

---

**Last Updated**: January 15, 2026

For questions or issues, please ensure your MATLAB version supports all required functions and toolboxes.
