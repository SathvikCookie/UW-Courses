public class LinkedStack<T> implements MyStack<T> {
    ListNode<T> front;

    // Constructor
    public LinkedStack() {
        front = null;
    }

    // Adds an item into the queue.
    public void push(T item) {
        ListNode<T> curr = new ListNode<T>(item, front);
        front = curr;
    }
    
    // Removes and returns the least-recently added item from the queue
    // Throws an IllegalStateException if the queue is empty
    public T pop() {
        if (front == null) {
            throw new IllegalStateException("The stack is empty!");
        }

        T temp = front.data;
        front = front.next;
        return temp;
    }
    
    // Returns the least-recently added item from the queue
    // Throws an IllegalStateException if the queue is empty
    public T peek() {
        if (front == null) {
            throw new IllegalStateException("The stack is empty!");
        }

        return front.data;
    }
    
    // Return the number of items currently in the queue
    public int size() {
        int count = 0;
        ListNode<T> curr = front;

        while (curr != null) {
            count++;
            curr = curr.next;
        }

        return count;
    }
    
    // Returns a boolean to indicate whether the queue has items
    public boolean isEmpty() {
        return front == null;
    }

    private static class ListNode<T>{
        private final T data;
        private ListNode<T> next;

        private ListNode(T data, ListNode<T> next){
            this.data = data;
            this.next = next;
        }

        private ListNode(T data){
            this.data = data;
        }
    }
}
