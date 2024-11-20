public class ArrayQueue<T> implements MyQueue<T>{
    int front = 0;
    int back = 0;
    int size = 0;
    T[] queue;

    // Constructor
    public ArrayQueue() {
        queue = (T[]) (new Object[10]);
    }

    // Adds an item into the queue.
    public void enqueue(T item) {
        if (size == queue.length) {
            resize();
        }

        queue[back] = item;
        back = (back + 1) % queue.length;
        size++;
    }

    // Removes and returns the least-recently added item from the queue
    // Throws an IllegalStateException if the queue is empty
    public T dequeue() {
        if (size == 0) {
            throw new IllegalStateException("The stack is empty!");
        }

        T first = queue[front];
        front = (front + 1) % queue.length;
        size--;
        return first;
    }

    // Returns the least-recently added item from the queue
    // Throws an IllegalStateException if the queue is empty
    public T peek() {
        if (size == 0) {
            throw new IllegalStateException("The stack is empty!");
        }

        return queue[front];
    }

    // Return the number of items currently in the queue
    public int size() {
        return size;
    }

    // Returns a boolean to indicate whether the queue has items
    public boolean isEmpty() {
        return size == 0;
    }

    public void resize() {
        T[] temp = (T[]) (new Object[queue.length * 2]);
    
        for (int i = 0; i < size; i++) {
            temp[i] = queue[(front + i) % queue.length];
        }
    
        front = 0;
        back = size;
        queue = temp;
    }
}