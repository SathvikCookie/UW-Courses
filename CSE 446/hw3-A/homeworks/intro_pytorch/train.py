from typing import Dict, List, Optional

import numpy as np
import torch
from matplotlib import pyplot as plt
from torch import nn, optim
from torch.utils.data import DataLoader

from utils import problem


@problem.tag("hw3-A")
def train(
    train_loader: DataLoader,
    model: nn.Module,
    criterion: nn.Module,
    optimizer: optim.Optimizer,
    val_loader: Optional[DataLoader] = None,
    epochs: int = 100,
) -> Dict[str, List[float]]:
    """Performs training of a provided model and provided dataset.

    Args:
        train_loader (DataLoader): DataLoader for training set.
        model (nn.Module): Model to train.
        criterion (nn.Module): Callable instance of loss function, that can be used to calculate loss for each batch.
        optimizer (optim.Optimizer): Optimizer used for updating parameters of the model.
        val_loader (Optional[DataLoader], optional): DataLoader for validation set.
            If defined, if should be used to calculate loss on validation set, after each epoch.
            Defaults to None.
        epochs (int, optional): Number of epochs (passes through dataset/dataloader) to train for.
            Defaults to 100.

    Returns:
        Dict[str, List[float]]: Dictionary with history of training.
            It should have have two keys: "train" and "val",
            each pointing to a list of floats representing loss at each epoch for corresponding dataset.
            If val_loader is undefined, "val" can point at an empty list.

    Note:
        - Calculating training loss might expensive if you do it seperately from training a model.
            Using a running loss approach is advised.
            In this case you will just use the loss that you called .backward() on add sum them up across batches.
            Then you can divide by length of train_loader, and you will have an average loss for each batch.
        - You will be iterating over multiple models in main function.
            Make sure the optimizer is defined for proper model.
        - Make use of pytorch documentation: https://pytorch.org/docs/stable/index.html
            You might find some examples/tutorials useful.
            Also make sure to check out torch.no_grad function. It might be useful!
        - Make sure to load the model parameters corresponding to model with the best validation loss (if val_loader is provided).
            You might want to look into state_dict: https://pytorch.org/tutorials/beginner/saving_loading_models.html
    """
    history = {"train": [], "val": []}
    best_val_loss = float('inf')
    best_model_state = None
    
    for epoch in range(epochs):
        print("Training epoch " + str(epoch))
        # Training phase
        model.train()
        running_train_loss = 0.0
        num_train_batches = 0
        
        for batch_data, batch_targets in train_loader:
            # Zero gradients
            optimizer.zero_grad()
            
            # Forward pass
            outputs = model(batch_data)
            loss = criterion(outputs, batch_targets)
            
            # Backward pass and optimization
            loss.backward()
            optimizer.step()
            
            # Accumulate loss
            running_train_loss += loss.item()
            num_train_batches += 1
        
        # Calculate average training loss for this epoch
        avg_train_loss = running_train_loss / num_train_batches
        history["train"].append(avg_train_loss)
        
        # Validation phase
        if val_loader is not None:
            model.eval()
            running_val_loss = 0.0
            num_val_batches = 0
            
            with torch.no_grad():
                for batch_data, batch_targets in val_loader:
                    outputs = model(batch_data)
                    loss = criterion(outputs, batch_targets)
                    running_val_loss += loss.item()
                    num_val_batches += 1
            
            # Calculate average validation loss for this epoch
            avg_val_loss = running_val_loss / num_val_batches
            history["val"].append(avg_val_loss)
            
            # Save best model state
            if avg_val_loss < best_val_loss:
                best_val_loss = avg_val_loss
                best_model_state = model.state_dict().copy()
        else:
            history["val"] = []
    
    # Load best model parameters if validation was performed
    if val_loader is not None and best_model_state is not None:
        model.load_state_dict(best_model_state)
    
    return history


def plot_model_guesses(
    dataloader: DataLoader, model: nn.Module, title: Optional[str] = None
):
    """Helper function!
    Given data and model plots model predictions, and groups them into:
        - True positives
        - False positives
        - True negatives
        - False negatives

    Args:
        dataloader (DataLoader): Data to plot.
        model (nn.Module): Model to make predictions.
        title (Optional[str], optional): Optional title of the plot.
            Might be useful for distinguishing between MSE and CrossEntropy.
            Defaults to None.
    """
    with torch.no_grad():
        list_xs = []
        list_ys_pred = []
        list_ys_batch = []
        for x_batch, y_batch in dataloader:
            y_pred = model(x_batch)
            list_xs.extend(x_batch.numpy())
            list_ys_batch.extend(y_batch.numpy())
            list_ys_pred.extend(torch.argmax(y_pred, dim=1).numpy())

        xs = np.array(list_xs)
        ys_pred = np.array(list_ys_pred)
        ys_batch = np.array(list_ys_batch)

        # True positive
        if len(ys_batch.shape) == 2 and ys_batch.shape[1] == 2:
            # MSE fix
            ys_batch = np.argmax(ys_batch, axis=1)
        idxs = np.logical_and(ys_batch, ys_pred)
        plt.scatter(
            xs[idxs, 0], xs[idxs, 1], marker="o", c="green", label="True Positive"
        )
        # False positive
        idxs = np.logical_and(1 - ys_batch, ys_pred)
        plt.scatter(
            xs[idxs, 0], xs[idxs, 1], marker="o", c="red", label="False Positive"
        )
        # True negative
        idxs = np.logical_and(1 - ys_batch, 1 - ys_pred)
        plt.scatter(
            xs[idxs, 0], xs[idxs, 1], marker="x", c="green", label="True Negative"
        )
        # False negative
        idxs = np.logical_and(ys_batch, 1 - ys_pred)
        plt.scatter(
            xs[idxs, 0], xs[idxs, 1], marker="x", c="red", label="False Negative"
        )

        if title:
            plt.title(title)
        plt.xlabel("x0")
        plt.ylabel("x1")
        plt.legend()
        plt.show()
