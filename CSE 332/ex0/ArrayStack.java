public class ArrayStack<T> implements MyStack<T> {
    int front = 0;
    int size = 0;
    T[] stack;

    // Constructor
    public ArrayStack() {
        stack = (T[]) (new Object[10]);
    }

    // Adds an item into the stack
    public void push(T item) {
        if (size == stack.length) {
            resize();
        }

        front = (front + 1) % stack.length;
        stack[front] = item;
        size++;
    }

    // Removes and returns the most recently added item from the stack
    // throws an IllegalStateException if the stack is empty
    public T pop() {
        if (size == 0) {
            throw new IllegalStateException("The stack is empty!");
        }

        T first = stack[front];
        
        front = front - 1;
        if (front == -1) {
            front = stack.length - 1;
        }
        size--;

        return first;
    }

    // Returns the most recently added item in the stack
    // throws an IllegalStateException if the stack is empty
    public T peek() {
        if (size == 0) {
            throw new IllegalStateException("The stack is empty!");
        }

        return stack[front];
    }

    // Returns the number of items in the stack
    public int size(){
        return size;
    }

    // Returns a boolean indicating whether the stack has items
    public boolean isEmpty() {
        return size == 0;
    }

    public void resize() {
        T[] temp = (T[]) (new Object[stack.length * 2]);

        for (int i = 0; i < size; i++) {
            temp[i] = stack[(front - size + 1 + i + stack.length) % stack.length];
        }

        front = size - 1;
        stack = temp;
    }
}
