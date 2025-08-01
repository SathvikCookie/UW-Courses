if __name__ == "__main__":
    from layers import LinearLayer, ReLULayer, SigmoidLayer, SoftmaxLayer
    from losses import CrossEntropyLossLayer
    from optimizers import SGDOptimizer
    from train import plot_model_guesses, train
else:
    from .layers import LinearLayer, ReLULayer, SigmoidLayer, SoftmaxLayer
    from .optimizers import SGDOptimizer
    from .losses import CrossEntropyLossLayer
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
def crossentropy_parameter_search(
    dataset_train: TensorDataset, dataset_val: TensorDataset
) -> Dict[str, Any]:
    """
    Main subroutine of the CrossEntropy problem.
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
    NOTE: Each model should end with a Softmax layer due to CrossEntropyLossLayer requirement.

    Notes:
        - When choosing the number of epochs, consider effect of other hyperparameters on it.
            For example as learning rate gets smaller you will need more epochs to converge.

    Args:
        dataset_train (TensorDataset): Dataset for training.
        dataset_val (TensorDataset): Dataset for validation.

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
    train_loader = DataLoader(dataset_train, batch_size=32, shuffle=True, generator=RNG)
    val_loader = DataLoader(dataset_val, batch_size=32, shuffle=False, generator=RNG)
    
    results = {}
    input_size = 2
    output_size = 2
    learning_rate = 0.01
    epochs = 200
    
    # Model 1: Linear Model with Softmax
    model1 = nn.Sequential(
        nn.Linear(input_size, output_size),
        nn.Softmax(dim=1)
    )
    optimizer1 = torch.optim.SGD(model1.parameters(), lr=learning_rate)
    criterion = nn.CrossEntropyLoss()
    
    history1 = train(train_loader, model1, criterion, optimizer1, val_loader, epochs)
    results["Linear"] = {
        "train": history1["train"],
        "val": history1["val"],
        "model": model1
    }
    
    # Model 2: One hidden layer with Sigmoid + Softmax
    model2 = nn.Sequential(
        nn.Linear(input_size, 2),
        nn.Sigmoid(),
        nn.Linear(2, output_size),
        nn.Softmax(dim=1)
    )
    optimizer2 = torch.optim.SGD(model2.parameters(), lr=learning_rate)
    
    history2 = train(train_loader, model2, criterion, optimizer2, val_loader, epochs)
    results["One Hidden Sigmoid"] = {
        "train": history2["train"],
        "val": history2["val"],
        "model": model2
    }
    
    # Model 3: One hidden layer with ReLU + Softmax
    model3 = nn.Sequential(
        nn.Linear(input_size, 2),
        nn.ReLU(),
        nn.Linear(2, output_size),
        nn.Softmax(dim=1)
    )
    optimizer3 = torch.optim.SGD(model3.parameters(), lr=learning_rate)
    
    history3 = train(train_loader, model3, criterion, optimizer3, val_loader, epochs)
    results["One Hidden ReLU"] = {
        "train": history3["train"],
        "val": history3["val"],
        "model": model3
    }
    
    # Model 4: Two hidden layers with Sigmoid, ReLU + Softmax
    model4 = nn.Sequential(
        nn.Linear(input_size, 2),
        nn.Sigmoid(),
        nn.Linear(2, 2),
        nn.ReLU(),
        nn.Linear(2, output_size),
        nn.Softmax(dim=1)
    )
    optimizer4 = torch.optim.SGD(model4.parameters(), lr=learning_rate)
    
    history4 = train(train_loader, model4, criterion, optimizer4, val_loader, epochs)
    results["Two Hidden Sigmoid-ReLU"] = {
        "train": history4["train"],
        "val": history4["val"],
        "model": model4
    }
    
    # Model 5: Two hidden layers with ReLU, Sigmoid + Softmax
    model5 = nn.Sequential(
        nn.Linear(input_size, 2),
        nn.ReLU(),
        nn.Linear(2, 2),
        nn.Sigmoid(),
        nn.Linear(2, output_size),
        nn.Softmax(dim=1)
    )
    optimizer5 = torch.optim.SGD(model5.parameters(), lr=learning_rate)
    
    history5 = train(train_loader, model5, criterion, optimizer5, val_loader, epochs)
    results["Two Hidden ReLU-Sigmoid"] = {
        "train": history5["train"],
        "val": history5["val"],
        "model": model5
    }
    
    # Model 6: Two hidden layers with ReLU, ReLU + Softmax
    model6 = nn.Sequential(
        nn.Linear(input_size, 2),
        nn.ReLU(),
        nn.Linear(2, 2),
        nn.ReLU(),
        nn.Linear(2, output_size),
        nn.Softmax(dim=1)
    )
    optimizer6 = torch.optim.SGD(model6.parameters(), lr=learning_rate)
    
    history6 = train(train_loader, model6, criterion, optimizer6, val_loader, epochs)
    results["Two Hidden ReLU-ReLU"] = {
        "train": history6["train"],
        "val": history6["val"],
        "model": model6
    }
    
    return results


@problem.tag("hw3-A")
def accuracy_score(model, dataloader) -> float:
    """Calculates accuracy of model on dataloader. Returns it as a fraction.

    Args:
        model (nn.Module): Model to evaluate.
        dataloader (DataLoader): Dataloader for CrossEntropy.
            Each example is a tuple consiting of (observation, target).
            Observation is a 2-d vector of floats.
            Target is an integer representing a correct class to a corresponding observation.

    Returns:
        float: Vanilla python float resprenting accuracy of the model on given dataset/dataloader.
            In range [0, 1].

    Note:
        - For a single-element tensor you can use .item() to cast it to a float.
        - This is similar to MSE accuracy_score function,
            but there will be differences due to slightly different targets in dataloaders.
    """
    model.eval()
    correct = 0
    total = 0
    
    with torch.no_grad():
        for data, targets in dataloader:
            outputs = model(data)
            
            # Get predicted class (index of maximum output)
            predicted = torch.argmax(outputs, dim=1)
            
            # targets are already class indices for CrossEntropy
            total += targets.size(0)
            correct += (predicted == targets).sum().item()
    
    return correct / total


@problem.tag("hw3-A", start_line=7)
def main():
    """
    Main function of the Crossentropy problem.
    It should:
        1. Call crossentropy_parameter_search routine and get dictionary for each model architecture/configuration.
        2. Plot Train and Validation losses for each model all on single plot (it should be 12 lines total).
            x-axis should be epochs, y-axis should me Crossentropy loss, REMEMBER to add legend
        3. Choose and report the best model configuration based on validation losses.
            In particular you should choose a model that achieved the lowest validation loss at ANY point during the training.
        4. Plot best model guesses on test set (using plot_model_guesses function from train file)
        5. Report accuracy of the model on test set.

    Starter code loads dataset, converts it into PyTorch Datasets, and those into DataLoaders.
    You should use these dataloaders, for the best experience with PyTorch.
    """
    (x, y), (x_val, y_val), (x_test, y_test) = load_dataset("xor")

    dataset_train = TensorDataset(torch.from_numpy(x).float(), torch.from_numpy(y))
    dataset_val = TensorDataset(torch.from_numpy(x_val).float(), torch.from_numpy(y_val))
    dataset_test = TensorDataset(torch.from_numpy(x_test).float(), torch.from_numpy(y_test))

    ce_configs = crossentropy_parameter_search(dataset_train, dataset_val)
    
    # Plot training and validation losses
    plt.figure(figsize=(12, 8))
    
    for model_name, config in ce_configs.items():
        epochs = range(1, len(config["train"]) + 1)
        plt.plot(epochs, config["train"], label=f"{model_name} - Train", linestyle='-')
        plt.plot(epochs, config["val"], label=f"{model_name} - Val", linestyle='--')
    
    plt.xlabel("Epochs")
    plt.ylabel("CrossEntropy Loss")
    plt.title("CrossEntropy Loss vs Epochs for Different Model Architectures")
    plt.legend()
    plt.grid(True)
    plt.show()
    
    # Find best model based on minimum validation loss
    best_model_name = None
    best_val_loss = float('inf')
    
    for model_name, config in ce_configs.items():
        min_val_loss = min(config["val"])
        if min_val_loss < best_val_loss:
            best_val_loss = min_val_loss
            best_model_name = model_name
    
    print(f"Best model: {best_model_name}")
    print(f"Best validation loss: {best_val_loss:.6f}")
    
    # Plot best model guesses on test set
    test_loader = DataLoader(dataset_test, batch_size=len(dataset_test), shuffle=False)
    best_model = ce_configs[best_model_name]["model"]
    
    plot_model_guesses(test_loader, best_model, f"CrossEntropy - {best_model_name} - Test Set Predictions")
    
    # Report accuracy on test set
    test_accuracy = accuracy_score(best_model, test_loader)
    print(f"Test accuracy: {test_accuracy:.4f}")


if __name__ == "__main__":
    main()
