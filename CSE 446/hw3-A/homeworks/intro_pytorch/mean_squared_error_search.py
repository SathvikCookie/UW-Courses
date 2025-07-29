if __name__ == "__main__":
    from layers import LinearLayer, ReLULayer, SigmoidLayer
    from losses import MSELossLayer
    from optimizers import SGDOptimizer
    from train import plot_model_guesses, train
else:
    from .layers import LinearLayer, ReLULayer, SigmoidLayer
    from .optimizers import SGDOptimizer
    from .losses import MSELossLayer
    from .train import plot_model_guesses, train


from typing import Any, Dict

import numpy as np
import torch
from matplotlib import pyplot as plt
from torch import nn
from torch.utils.data import DataLoader, TensorDataset

from utils import load_dataset, problem

RNG = torch.Generator()
RNG.manual_seed(446)


@problem.tag("hw3-A")
def accuracy_score(model: nn.Module, dataloader: DataLoader) -> float:
    """Calculates accuracy of model on dataloader. Returns it as a fraction.

    Args:
        model (nn.Module): Model to evaluate.
        dataloader (DataLoader): Dataloader for MSE.
            Each example is a tuple consiting of (observation, target).
            Observation is a 2-d vector of floats.
            Target is also a 2-d vector of floats, but specifically with one being 1.0, while other is 0.0.
            Index of 1.0 in target corresponds to the true class.

    Returns:
        float: Vanilla python float resprenting accuracy of the model on given dataset/dataloader.
            In range [0, 1].

    Note:
        - For a single-element tensor you can use .item() to cast it to a float.
        - This is similar to CrossEntropy accuracy_score function,
            but there will be differences due to slightly different targets in dataloaders.
    """
    model.eval()
    correct = 0
    total = 0
    
    with torch.no_grad():
        for data, targets in dataloader:
            # Ensure both data and targets are float32
            data = data.float()
            targets = targets.float()
            
            outputs = model(data)
            
            # Get predicted class (index of maximum output)
            predicted = torch.argmax(outputs, dim=1)
            
            # Get true class (index of 1.0 in one-hot encoded target)
            true_class = torch.argmax(targets, dim=1)
            
            total += targets.size(0)
            correct += (predicted == true_class).sum().item()
    
    return correct / total


@problem.tag("hw3-A")
def mse_parameter_search(
    dataset_train: TensorDataset, dataset_val: TensorDataset
) -> Dict[str, Any]:
    """
    Main subroutine of the MSE problem.
    It's goal is to perform a search over hyperparameters, and return a dictionary containing training history of models, as well as models themselves.

    Models to check (please try them in this order):
        - Linear Regression Model
        - Network with one hidden layer of size 2 and sigmoid activation function after the hidden layer
        - Network with one hidden layer of size 2 and ReLU activation function after the hidden layer
        - Network with two hidden layers (each with size 2)
            and Sigmoid, ReLU activation function after corresponding hidden layers
        - Network with two hidden layers (each with size 2)
            and ReLU, Sigmoid activation function after corresponding hidden layers
        - Network with two hidden layers (each with size 2)
            and ReLU activation function after each hidden layer

    Notes:
        - When choosing the number of epochs, consider effect of other hyperparameters on it.
            For example as learning rate gets smaller you will need more epochs to converge.

    Args:
        dataset_train (TensorDataset): Training dataset.
        dataset_val (TensorDataset): Validation dataset.

    Returns:
        Dict[str, Any]: Dictionary/Map containing history of training of all models.
            You are free to employ any structure of this dictionary, but we suggest the following:
            {
                name_of_model: {
                    "train": Per epoch losses of model on train set,
                    "val": Per epoch losses of model on validation set,
                    "model": Actual PyTorch model (type: nn.Module),
                }
            }
    """
    # Create data loaders
    train_loader = DataLoader(dataset_train, batch_size=32, shuffle=True, generator=RNG)
    val_loader = DataLoader(dataset_val, batch_size=32, shuffle=False, generator=RNG)
    
    results = {}
    input_size = 2
    output_size = 2
    learning_rate = 0.01
    epochs = 200
    criterion = nn.MSELoss()
    
    # Model 1: Linear Regression Model
    model1 = nn.Sequential(
        nn.Linear(input_size, output_size)
    )
    optimizer1 = torch.optim.SGD(model1.parameters(), lr=learning_rate)
    
    history1 = train(train_loader, model1, criterion, optimizer1, val_loader, epochs)
    results["Linear"] = {
        "train": history1["train"],
        "val": history1["val"],
        "model": model1
    }
    
    # Model 2: One hidden layer with Sigmoid
    model2 = nn.Sequential(
        nn.Linear(input_size, 2),
        nn.Sigmoid(),
        nn.Linear(2, output_size)
    )
    optimizer2 = torch.optim.SGD(model2.parameters(), lr=learning_rate)
    
    history2 = train(train_loader, model2, criterion, optimizer2, val_loader, epochs)
    results["One Hidden Sigmoid"] = {
        "train": history2["train"],
        "val": history2["val"],
        "model": model2
    }
    
    # Model 3: One hidden layer with ReLU
    model3 = nn.Sequential(
        nn.Linear(input_size, 2),
        nn.ReLU(),
        nn.Linear(2, output_size)
    )
    optimizer3 = torch.optim.SGD(model3.parameters(), lr=learning_rate)
    
    history3 = train(train_loader, model3, criterion, optimizer3, val_loader, epochs)
    results["One Hidden ReLU"] = {
        "train": history3["train"],
        "val": history3["val"],
        "model": model3
    }
    
    # Model 4: Two hidden layers with Sigmoid, ReLU
    model4 = nn.Sequential(
        nn.Linear(input_size, 2),
        nn.Sigmoid(),
        nn.Linear(2, 2),
        nn.ReLU(),
        nn.Linear(2, output_size)
    )
    optimizer4 = torch.optim.SGD(model4.parameters(), lr=learning_rate)
    
    history4 = train(train_loader, model4, criterion, optimizer4, val_loader, epochs)
    results["Two Hidden Sigmoid-ReLU"] = {
        "train": history4["train"],
        "val": history4["val"],
        "model": model4
    }
    
    # Model 5: Two hidden layers with ReLU, Sigmoid
    model5 = nn.Sequential(
        nn.Linear(input_size, 2),
        nn.ReLU(),
        nn.Linear(2, 2),
        nn.Sigmoid(),
        nn.Linear(2, output_size)
    )
    optimizer5 = torch.optim.SGD(model5.parameters(), lr=learning_rate)
    
    history5 = train(train_loader, model5, criterion, optimizer5, val_loader, epochs)
    results["Two Hidden ReLU-Sigmoid"] = {
        "train": history5["train"],
        "val": history5["val"],
        "model": model5
    }
    
    # Model 6: Two hidden layers with ReLU, ReLU
    model6 = nn.Sequential(
        nn.Linear(input_size, 2),
        nn.ReLU(),
        nn.Linear(2, 2),
        nn.ReLU(),
        nn.Linear(2, output_size)
    )
    optimizer6 = torch.optim.SGD(model6.parameters(), lr=learning_rate)
    
    history6 = train(train_loader, model6, criterion, optimizer6, val_loader, epochs)
    results["Two Hidden ReLU-ReLU"] = {
        "train": history6["train"],
        "val": history6["val"],
        "model": model6
    }
    
    return results


@problem.tag("hw3-A", start_line=11)
def main():
    """
    Main function of the MSE problem.
    It should:
        1. Call mse_parameter_search routine and get dictionary for each model architecture/configuration.
        2. Plot Train and Validation losses for each model all on single plot (it should be 12 lines total).
            x-axis should be epochs, y-axis should me MSE loss, REMEMBER to add legend
        3. Choose and report the best model configuration based on validation losses.
            In particular you should choose a model that achieved the lowest validation loss at ANY point during the training.
        4. Plot best model guesses on test set (using plot_model_guesses function from train file)
        5. Report accuracy of the model on test set.

    Starter code loads dataset, converts it into PyTorch Datasets, and those into DataLoaders.
    You should use these dataloaders, for the best experience with PyTorch.
    """
    (x, y), (x_val, y_val), (x_test, y_test) = load_dataset("xor")

    # Convert to float32 tensors explicitly
    dataset_train = TensorDataset(
        torch.from_numpy(x).float(), 
        torch.from_numpy(to_one_hot(y)).float()
    )
    dataset_val = TensorDataset(
        torch.from_numpy(x_val).float(), 
        torch.from_numpy(to_one_hot(y_val)).float()
    )
    dataset_test = TensorDataset(
        torch.from_numpy(x_test).float(), 
        torch.from_numpy(to_one_hot(y_test)).float()
    )

    mse_configs = mse_parameter_search(dataset_train, dataset_val)
    
    # Plot training and validation losses
    plt.figure(figsize=(12, 8))
    
    for model_name, config in mse_configs.items():
        epochs = range(1, len(config["train"]) + 1)
        plt.plot(epochs, config["train"], label=f"{model_name} - Train", linestyle='-')
        plt.plot(epochs, config["val"], label=f"{model_name} - Val", linestyle='--')
    
    plt.xlabel("Epochs")
    plt.ylabel("MSE Loss")
    plt.title("MSE Loss vs Epochs for Different Model Architectures")
    plt.legend()
    plt.grid(True)
    plt.show()
    
    # Find best model based on minimum validation loss
    best_model_name = None
    best_val_loss = float('inf')
    
    for model_name, config in mse_configs.items():
        min_val_loss = min(config["val"])
        if min_val_loss < best_val_loss:
            best_val_loss = min_val_loss
            best_model_name = model_name
    
    print(f"Best model: {best_model_name}")
    print(f"Best validation loss: {best_val_loss:.6f}")
    
    # Plot best model guesses on test set
    test_loader = DataLoader(dataset_test, batch_size=len(dataset_test), shuffle=False)
    best_model = mse_configs[best_model_name]["model"]
    
    plot_model_guesses(test_loader, best_model, f"MSE - {best_model_name} - Test Set Predictions")
    
    # Report accuracy on test set
    test_accuracy = accuracy_score(best_model, test_loader)
    print(f"Test accuracy: {test_accuracy:.4f}")


def to_one_hot(a: np.ndarray) -> np.ndarray:
    """Helper function. Converts data from categorical to one-hot encoded.

    Args:
        a (np.ndarray): Input array of integers with shape (n,).

    Returns:
        np.ndarray: Array with shape (n, c), where c is maximal element of a.
            Each element of a, has a corresponding one-hot encoded vector of length c.
    """
    r = np.zeros((len(a), 2), dtype=np.float32)  # Explicitly use float32
    r[np.arange(len(a)), a] = 1
    return r


if __name__ == "__main__":
    main()