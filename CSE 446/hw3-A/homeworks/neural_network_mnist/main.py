# When taking sqrt for initialization you might want to use math package,
# since torch.sqrt requires a tensor, and math.sqrt is ok with integer
import math
from typing import List

import matplotlib.pyplot as plt
import torch
from torch.distributions import Uniform
from torch.nn import Module
from torch.nn.functional import cross_entropy, relu
from torch.nn.parameter import Parameter
from torch.optim import Adam
from torch.utils.data import DataLoader, TensorDataset

from utils import load_dataset, problem


class F1(Module):
    @problem.tag("hw3-A", start_line=1)
    def __init__(self, h: int, d: int, k: int):
        """Create a F1 model as described in pdf.

        Args:
            h (int): Hidden dimension.
            d (int): Input dimension/number of features.
            k (int): Output dimension/number of classes.
        """
        super().__init__()
        bound0 = 1 / math.sqrt(d)
        bound1 = 1 / math.sqrt(h)

        self.W0 = Parameter(Uniform(-bound0, bound0).sample((d, h)))  # shape (d, h)
        self.b0 = Parameter(torch.zeros(h))                           # shape (h,)
        self.W1 = Parameter(Uniform(-bound1, bound1).sample((h, k)))  # shape (h, k)
        self.b1 = Parameter(torch.zeros(k))

    @problem.tag("hw3-A")
    def forward(self, x: torch.Tensor) -> torch.Tensor:
        """
        Pass input through F1 model.

        It should perform operation:
        W_1(sigma(W_0*x + b_0)) + b_1

        Note that in this coding assignment, we use the same convention as previous
        assignments where a linear module is of the form xW + b. This differs from the 
        general forward pass operation defined above, which assumes the form Wx + b.
        When implementing the forward pass, make sure that the correct matrices and
        transpositions are used.

        Args:
            x (torch.Tensor): FloatTensor of shape (n, d). Input data.

        Returns:
            torch.Tensor: FloatTensor of shape (n, k). Prediction.
        """
        z0 = x @ self.W0 + self.b0       # shape: (n, h)
        a0 = relu(z0)
        logits = a0 @ self.W1 + self.b1  # shape: (n, k)
        return logits


class F2(Module):
    @problem.tag("hw3-A", start_line=1)
    def __init__(self, h0: int, h1: int, d: int, k: int):
        """Create a F2 model as described in pdf.

        Args:
            h0 (int): First hidden dimension (between first and second layer).
            h1 (int): Second hidden dimension (between second and third layer).
            d (int): Input dimension/number of features.
            k (int): Output dimension/number of classes.
        """
        super().__init__()
        bound0 = 1 / math.sqrt(d)
        bound1 = 1 / math.sqrt(h0)
        bound2 = 1 / math.sqrt(h1)

        self.W0 = Parameter(Uniform(-bound0, bound0).sample((d, h0)))
        self.b0 = Parameter(torch.zeros(h0))

        self.W1 = Parameter(Uniform(-bound1, bound1).sample((h0, h1)))
        self.b1 = Parameter(torch.zeros(h1))

        self.W2 = Parameter(Uniform(-bound2, bound2).sample((h1, k)))
        self.b2 = Parameter(torch.zeros(k))

    @problem.tag("hw3-A")
    def forward(self, x: torch.Tensor) -> torch.Tensor:
        """
        Pass input through F2 model.

        It should perform operation:
        W_2(sigma(W_1(sigma(W_0*x + b_0)) + b_1) + b_2)

        Note that in this coding assignment, we use the same convention as previous
        assignments where a linear module is of the form xW + b. This differs from the 
        general forward pass operation defined above, which assumes the form Wx + b.
        When implementing the forward pass, make sure that the correct matrices and
        transpositions are used.

        Args:
            x (torch.Tensor): FloatTensor of shape (n, d). Input data.

        Returns:
            torch.Tensor: FloatTensor of shape (n, k). Prediction.
        """
        z0 = x @ self.W0 + self.b0
        a0 = relu(z0)

        z1 = a0 @ self.W1 + self.b1
        a1 = relu(z1)

        logits = a1 @ self.W2 + self.b2
        return logits


@problem.tag("hw3-A")
def train(model: Module, optimizer: Adam, train_loader: DataLoader) -> List[float]:
    """
    Train a model until it reaches 99% accuracy on train set, and return list of training crossentropy losses for each epochs.

    Args:
        model (Module): Model to train. Either F1, or F2 in this problem.
        optimizer (Adam): Optimizer that will adjust parameters of the model.
        train_loader (DataLoader): DataLoader with training data.
            You can iterate over it like a list, and it will produce tuples (x, y),
            where x is FloatTensor of shape (n, d) and y is LongTensor of shape (n,).
            Note that y contains the classes as integers.

    Returns:
        List[float]: List containing average loss for each epoch.
    """
    losses = []
    accuracy = 0.0

    while accuracy < 0.99:
        total_loss = 0.0
        correct = 0
        total = 0

        for x_batch, y_batch in train_loader:
            optimizer.zero_grad()
            logits = model(x_batch)
            loss = cross_entropy(logits, y_batch)
            loss.backward()
            optimizer.step()

            total_loss += loss.item() * x_batch.size(0)

            predictions = torch.argmax(logits, dim=1)
            correct += (predictions == y_batch).sum().item()
            total += y_batch.size(0)

        epoch_loss = total_loss / total
        accuracy = correct / total
        losses.append(epoch_loss)
        print(f"Epoch {len(losses)} - Loss: {epoch_loss:.4f}, Accuracy: {accuracy:.4f}")

    return losses


@problem.tag("hw3-A", start_line=5)
def main():
    """
    Main function of this problem.
    For both F1 and F2 models it should:
        1. Train a model
        2. Plot per epoch losses
        3. Report accuracy and loss on test set
        4. Report total number of parameters for each network

    Note that we provided you with code that loads MNIST and changes x's and y's to correct type of tensors.
    We strongly advise that you use torch functionality such as datasets, but as mentioned in the pdf you cannot use anything from torch.nn other than what is imported here.
    """
    (x, y), (x_test, y_test) = load_dataset("mnist")
    x = torch.from_numpy(x).float()
    y = torch.from_numpy(y).long()
    x_test = torch.from_numpy(x_test).float()
    y_test = torch.from_numpy(y_test).long()
    
    batch_size = 64
    train_loader = DataLoader(TensorDataset(x, y), batch_size=batch_size, shuffle=True)

    # F1 model
    f1_model = F1(h=64, d=784, k=10)
    f1_optimizer = Adam(f1_model.parameters(), lr=1e-3)
    f1_losses = train(f1_model, f1_optimizer, train_loader)

    # Plot F1 loss
    plt.plot(f1_losses)
    plt.title("F1 Training Loss")
    plt.xlabel("Epoch")
    plt.ylabel("Loss")
    plt.grid()
    plt.show()

    f1_test_logits = f1_model(x_test)
    f1_test_loss = cross_entropy(f1_test_logits, y_test).item()
    f1_test_accuracy = (torch.argmax(f1_test_logits, dim=1) == y_test).float().mean().item()
    print(f"F1 Test Loss: {f1_test_loss:.4f}, Test Accuracy: {f1_test_accuracy:.4f}")
    print(f"F1 Num Params: {sum(p.numel() for p in f1_model.parameters())}")

    # F2 model
    f2_model = F2(h0=32, h1=32, d=784, k=10)
    f2_optimizer = Adam(f2_model.parameters(), lr=1e-3)
    f2_losses = train(f2_model, f2_optimizer, train_loader)

    # Plot F2 loss
    plt.plot(f2_losses)
    plt.title("F2 Training Loss")
    plt.xlabel("Epoch")
    plt.ylabel("Loss")
    plt.grid()
    plt.show()

    f2_test_logits = f2_model(x_test)
    f2_test_loss = cross_entropy(f2_test_logits, y_test).item()
    f2_test_accuracy = (torch.argmax(f2_test_logits, dim=1) == y_test).float().mean().item()
    print(f"F2 Test Loss: {f2_test_loss:.4f}, Test Accuracy: {f2_test_accuracy:.4f}")
    print(f"F2 Num Params: {sum(p.numel() for p in f2_model.parameters())}")


if __name__ == "__main__":
    main()
