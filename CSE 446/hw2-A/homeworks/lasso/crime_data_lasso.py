if __name__ == "__main__":
    from ISTA import train  # type: ignore
else:
    from .ISTA import train

import matplotlib.pyplot as plt
import numpy as np

from utils import load_dataset, problem


@problem.tag("hw2-A", start_line=3)
def main():
    # Load the crime dataset
    df_train, df_test = load_dataset("crime")
    
    # Extract target variable (crime rate) and features
    y_train = df_train['ViolentCrimesPerPop'].values
    X_train = df_train.drop('ViolentCrimesPerPop', axis=1).values
    
    y_test = df_test['ViolentCrimesPerPop'].values
    X_test = df_test.drop('ViolentCrimesPerPop', axis=1).values
    
    # Get feature names for later analysis
    feature_names = df_train.drop('ViolentCrimesPerPop', axis=1).columns
    
    # Calculate lambda_max using Equation (1)
    lambda_max = 2 * np.max(np.abs(X_train.T @ (y_train - np.mean(y_train))))
    
    # Initialize variables to store results
    lambdas = []
    num_nonzeros = []
    train_errors = []
    test_errors = []
    all_weights = []  # Store all weights for each lambda
    
    # To track regularization paths for specific features
    feature_indices = {
        'agePct12t29': np.where(feature_names == 'agePct12t29')[0][0],
        'pctWSocSec': np.where(feature_names == 'pctWSocSec')[0][0],
        'pctUrban': np.where(feature_names == 'pctUrban')[0][0],
        'agePct65up': np.where(feature_names == 'agePct65up')[0][0],
        'householdsize': np.where(feature_names == 'householdsize')[0][0]
    }
    
    reg_paths = {name: [] for name in feature_indices.keys()}
    
    # Start with lambda_max and decrease
    _lambda = lambda_max
    w_prev = None
    b_prev = None
    
    # Add lambda = 30 explicitly to the sequence
    lambda_sequence = []
    while _lambda >= 0.01:
        lambda_sequence.append(_lambda)
        _lambda /= 2
    
    # Add lambda = 30 to the sequence and sort
    lambda_sequence.append(30.0)
    lambda_sequence.sort(reverse=True)
    
    # Now run the algorithm with the updated sequence
    for _lambda in lambda_sequence:
        print(f"Training with lambda = {_lambda}")
        
        # Train model with current lambda
        w, b = train(X_train, y_train, _lambda=_lambda, eta=0.00001, convergence_delta=1e-4,
                    start_weight=w_prev, start_bias=b_prev)
        
        # Use trained weights for next iteration
        w_prev = w
        b_prev = b
        
        # Store current weights
        all_weights.append(w.copy())
        lambdas.append(_lambda)
        
        # Count non-zeros
        num_nonzero = np.sum(np.abs(w) > 1e-6)
        num_nonzeros.append(num_nonzero)
        
        # Calculate squared errors
        train_pred = X_train @ w + b
        test_pred = X_test @ w + b
        
        train_error = np.mean((train_pred - y_train) ** 2)
        test_error = np.mean((test_pred - y_test) ** 2)
        
        train_errors.append(train_error)
        test_errors.append(test_error)
        
        # Record weights for specific features
        for name, idx in feature_indices.items():
            reg_paths[name].append(w[idx])
    
    # [Plot code remains the same]
    
    # Find lambda = 30 results
    lambda_30_idx = lambda_sequence.index(30.0)
    lambda_30_weights = all_weights[lambda_30_idx]
    
    print(f"For lambda = 30:")
    # Find features with largest positive and negative weights
    sorted_indices = np.argsort(lambda_30_weights)
    most_negative_idx = sorted_indices[0]
    most_positive_idx = sorted_indices[-1]
    
    print(f"Feature with largest positive coefficient: {feature_names[most_positive_idx]}")
    print(f"Value: {lambda_30_weights[most_positive_idx]}")
    print(f"Feature with largest negative coefficient: {feature_names[most_negative_idx]}")
    print(f"Value: {lambda_30_weights[most_negative_idx]}")
    
    # Write results to a file for reference
    with open('lambda_30_results.txt', 'w') as f:
        f.write(f"For lambda = 30:\n")
        f.write(f"Feature with largest positive coefficient: {feature_names[most_positive_idx]}\n")
        f.write(f"Value: {lambda_30_weights[most_positive_idx]}\n")
        f.write(f"Feature with largest negative coefficient: {feature_names[most_negative_idx]}\n")
        f.write(f"Value: {lambda_30_weights[most_negative_idx]}\n")

if __name__ == "__main__":
    main()