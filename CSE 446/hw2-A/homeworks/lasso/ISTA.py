from typing import Optional, Tuple

import matplotlib.pyplot as plt
import numpy as np

from utils import problem


@problem.tag("hw2-A")
def step(X, y, weight, bias, _lambda, eta):
    """Single step in ISTA algorithm.
    It should update every entry in weight, and then return an updated version of weight along with calculated bias on input weight!

    Args:
        X (np.ndarray): An (n x d) matrix, with n observations each with d features.
        y (np.ndarray): An (n, ) array, with n observations of targets.
        weight (np.ndarray): An (d,) array. Weight returned from the step before.
        bias (float): Bias returned from the step before.
        _lambda (float): Regularization constant. Determines when weight is updated to 0, and when to other values.
        eta (float): Step-size. Determines how far the ISTA iteration moves for each step.

    Returns:
        Tuple[np.ndarray, float]: Tuple with 2 entries. First represents updated weight vector, second represents bias.
    """
    # Calculate the predictions with current weights and bias
    predictions = X @ weight + bias
    residuals = predictions - y
    
    # Update bias according to the algorithm
    # The algorithm uses the sum (not the mean) of residuals
    new_bias = bias - 2 * eta * np.sum(residuals)
    
    # Initialize the new weights array
    new_weight = np.zeros_like(weight)
    
    # Update each weight and apply soft thresholding
    for k in range(len(weight)):
        # Calculate gradient for feature k (sum, not mean)
        grad_k = 2 * np.sum(X[:, k] * residuals)
        w_k_temp = weight[k] - eta * grad_k
        
        # Apply soft thresholding
        if w_k_temp < -2 * eta * _lambda:
            new_weight[k] = w_k_temp + 2 * eta * _lambda
        elif w_k_temp > 2 * eta * _lambda:
            new_weight[k] = w_k_temp - 2 * eta * _lambda
        else:
            new_weight[k] = 0
    
    return new_weight, new_bias

@problem.tag("hw2-A")
def loss(
    X: np.ndarray, y: np.ndarray, weight: np.ndarray, bias: float, _lambda: float
) -> float:
    """L-1 (Lasso) regularized SSE loss.

    Args:
        X (np.ndarray): An (n x d) matrix, with n observations each with d features.
        y (np.ndarray): An (n, ) array, with n observations of targets.
        weight (np.ndarray): An (d,) array. Currently predicted weights.
        bias (float): Currently predicted bias.
        _lambda (float): Regularization constant. Should be used along with L1 norm of weight.

    Returns:
        float: value of the loss function
    """
    # Calculate predictions
    predictions = X @ weight + bias
    
    # Calculate SSE loss
    sse_loss = np.sum((predictions - y) ** 2)
    
    # Calculate L1 regularization term
    regularization = _lambda * np.sum(np.abs(weight))
    
    # Total loss
    total_loss = sse_loss + regularization
    
    return total_loss


@problem.tag("hw2-A", start_line=5)
def train(
    X: np.ndarray,
    y: np.ndarray,
    _lambda: float = 0.01,
    eta: float = 0.00001,
    convergence_delta: float = 1e-4,
    start_weight: np.ndarray = None,
    start_bias: float = None,
    max_iterations: int = 10000  # Add maximum iterations
) -> Tuple[np.ndarray, float]:
    """Trains a model and returns predicted weight and bias.

    Args:
        X (np.ndarray): An (n x d) matrix, with n observations each with d features.
        y (np.ndarray): An (n, ) array, with n observations of targets.
        _lambda (float): Regularization constant. Should be used for both step and loss.
        eta (float): Step size.
        convergence_delta (float, optional): Defines when to stop training algorithm.
            The smaller the value the longer algorithm will train.
            Defaults to 1e-4.
        start_weight (np.ndarray, optional): Weight for hot-starting model.
            If None, defaults to array of zeros. Defaults to None.
            It can be useful when testing for multiple values of lambda.
        start_bias (float, optional): Bias for hot-starting model.
            If None, defaults to zero. Defaults to None.
            It can be useful when testing for multiple values of lambda.
        max_iterations (int, optional): Maximum number of iterations. Defaults to 10000.

    Returns:
        Tuple[np.ndarray, float]: A tuple with first item being array of shape (d,) representing predicted weights,
            and second item being a float representing the bias.
    """
    # Initialize weights and bias if not provided
    if start_weight is None:
        start_weight = np.zeros(X.shape[1])
        start_bias = 0
    
    # Initialize variables
    weight = np.copy(start_weight)
    bias = start_bias
    
    # Keep track of old weights for convergence check
    old_w = None
    old_b = None
    
    # Training loop
    while True:
        # Store old weights
        old_w = np.copy(weight)
        old_b = bias
        
        # Update weights using ISTA step
        weight, bias = step(X, y, weight, bias, _lambda, eta)
        
        # Check convergence
        if convergence_criterion(weight, old_w, bias, old_b, convergence_delta):
            break
    
    return weight, bias


@problem.tag("hw2-A")
def convergence_criterion(
    weight: np.ndarray, old_w: np.ndarray, bias: float, old_b: float, convergence_delta: float
) -> bool:
    """Function determining whether weight and bias has converged or not.
    It should calculate the maximum absolute change between weight and old_w vector, and compare it to convergence delta.
    It should also calculate the maximum absolute change between the bias and old_b, and compare it to convergence delta.

    Args:
        weight (np.ndarray): Weight from current iteration of gradient descent.
        old_w (np.ndarray): Weight from previous iteration of gradient descent.
        bias (float): Bias from current iteration of gradient descent.
        old_b (float): Bias from previous iteration of gradient descent.
        convergence_delta (float): Aggressiveness of the check.

    Returns:
        bool: False, if weight and bias has not converged yet. True otherwise.
    """
    # Calculate maximum absolute change in weights
    max_weight_change = np.max(np.abs(weight - old_w))
    
    # Calculate absolute change in bias
    bias_change = np.abs(bias - old_b)
    
    # Check if both are below threshold
    return max_weight_change < convergence_delta and bias_change < convergence_delta


@problem.tag("hw2-A")
def main():
    """
    Use all of the functions above to make plots.
    """
    # Set random seed for reproducibility
    np.random.seed(42)
    
    # Parameters
    n = 500  # number of samples
    d = 1000  # number of features
    k = 100   # number of relevant features
    sigma = 1  # noise level
    
    # Generate true weights
    true_w = np.zeros(d)
    for j in range(k):
        true_w[j] = (j + 1) / k
    
    # Generate features X
    X = np.random.randn(n, d)
    
    # Standardize features
    X = (X - np.mean(X, axis=0)) / np.std(X, axis=0)
    
    # Generate response y = Xw + noise
    noise = np.random.normal(0, sigma, n)
    y = X @ true_w + noise
    
    # Calculate lambda_max using Equation (1)
    lambda_max = 2 * np.max(np.abs(X.T @ (y - np.mean(y))))
    
    # Initialize variables to store results
    lambdas = []
    num_nonzeros = []
    fdrs = []
    tprs = []
    
    # Start with lambda_max and decrease
    _lambda = lambda_max
    w_prev = None
    b_prev = None
    
    while _lambda >= 0.01:
        lambdas.append(_lambda)
        
        # Train model with current lambda
        w, b = train(X, y, _lambda=_lambda, eta=0.00001, convergence_delta=1e-4,
                    start_weight=w_prev, start_bias=b_prev)
        
        # Use trained weights for next iteration
        w_prev = w
        b_prev = b
        
        # Count non-zeros
        nonzero_indices = np.where(np.abs(w) > 1e-6)[0]
        num_nonzero = len(nonzero_indices)
        num_nonzeros.append(num_nonzero)
        
        # Calculate FDR and TPR
        # True positives: non-zero weights that should be non-zero (indices < k)
        tp = sum(idx < k for idx in nonzero_indices)
        # False positives: non-zero weights that should be zero (indices >= k)
        fp = num_nonzero - tp
        
        # Calculate FDR and TPR
        fdr = fp / max(num_nonzero, 1)  # Avoid division by zero
        tpr = tp / k
        
        fdrs.append(fdr)
        tprs.append(tpr)
        
        # Reduce lambda for next iteration
        _lambda /= 2
    
    # Plot 1: Number of non-zeros vs lambda
    plt.figure(figsize=(10, 6))
    plt.plot(lambdas, num_nonzeros, marker='o')
    plt.xscale('log')
    plt.xlabel('Lambda (log scale)')
    plt.ylabel('Number of non-zero weights')
    plt.title('Number of non-zero weights vs Lambda')
    plt.grid(True)
    plt.savefig('plot1_nonzeros_vs_lambda.png')
    plt.close()
    
    # Plot 2: FDR vs TPR
    plt.figure(figsize=(10, 6))
    plt.scatter(fdrs, tprs, c=lambdas, cmap='viridis', marker='o')
    plt.colorbar(label='Lambda value')
    plt.xlabel('False Discovery Rate (FDR)')
    plt.ylabel('True Positive Rate (TPR)')
    plt.title('TPR vs FDR for different Lambda values')
    plt.grid(True)
    plt.savefig('plot2_tpr_vs_fdr.png')
    plt.close()


if __name__ == "__main__":
    main()
