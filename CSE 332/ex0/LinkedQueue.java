public class LinkedQueue<E> implements MyQueue<E>{
    ListNode<E> front;
    ListNode<E> back;

    // Constructor
    public LinkedQueue() {
        front = null;
        back = null;
    }

    // Adds an item into the queue.
    public void enqueue(E item) {
        ListNode<E> last = new ListNode<E>(item);

        if (front == null) {
            front = last;
            back = last;
        } else {
            back.next = last;
            back = last;
        }
    }
    
    // Removes and returns the least-recently added item from the queue
    // Throws an IllegalStateException if the queue is empty
    public E dequeue() {
        if (front == null) {
            throw new IllegalStateException("The queue is empty!");
        }

        E first = front.data;
        front = front.next;

        if (front == null) {
            back = null;
        }

        return first;
    }
    
    // Returns the least-recently added item from the queue
    // Throws an IllegalStateException if the queue is empty
    public E peek() {
        if (front == null) {
            throw new IllegalStateException("The queue is empty!");
        }

        return front.data;
    }
    
    // Return the number of items currently in the queue
    public int size() {
        int count = 0;
        ListNode<E> curr = front;

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

    private static class ListNode<E>{
        private final E data;
        private ListNode<E> next;

        private ListNode(E data, ListNode<E> next){
            this.data = data;
            this.next = next;
        }

        private ListNode(E data){
            this.data = data;
        }
    }
}
