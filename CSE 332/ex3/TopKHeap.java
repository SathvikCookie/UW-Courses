import java.util.Map;
import java.util.HashMap;
import java.util.List;

public class TopKHeap<T extends Comparable<T>> {
    private BinaryMinHeap<T> topK; // Holds the top k items
    private BinaryMaxHeap<T> rest; // Holds all items other than the top k
    private int size; // Maintains the size of the data structure
    private final int k; // The value of k
    private Map<T, MyPriorityQueue<T>> itemToHeap; // Keeps track of which heap contains each item.
    
    // Creates a topKHeap for the given choice of k.
    public TopKHeap(int k){
        topK = new BinaryMinHeap<>();
        rest = new BinaryMaxHeap<>();
        size = 0;
        this.k = k;
        itemToHeap = new HashMap<>();
    }

    // Returns a list containing exactly the
    // largest k items. The list is not necessarily
    // sorted. If the size is less than or equal to
    // k then the list will contain all items.
    // The running time of this method should be O(k).
    public List<T> topK(){
        return topK.toList();
    }

    // Add the given item into the data structure.
    // The running time of this method should be O(log(n)+log(k)).
    public void insert(T item){
        if (topK.size() < k) {
            topK.insert(item);
            itemToHeap.put(item, topK);
        } else if (item.compareTo(topK.peek()) > 0) {
            T temp = topK.extract();

            itemToHeap.put(temp, rest);
            itemToHeap.put(item, topK);

            rest.insert(temp);
            topK.insert(item);
        } else {
            rest.insert(item);

            itemToHeap.put(item, rest);
        }

        size++;
    }

    // Indicates whether the given item is among the 
    // top k items. Should return false if the item
    // is not present in the data structure at all.
    // The running time of this method should be O(1).
    // We have provided a suggested implementation,
    // but you're welcome to do something different!
    public boolean isTopK(T item){
        return itemToHeap.get(item) == topK;
    }

    // To be used whenever an item's priority has changed.
    // The input is a reference to the items whose priority
    // has changed. This operation will then rearrange
    // the items in the data structure to ensure it
    // operates correctly.
    // Throws an IllegalArgumentException if the item is
    // not a member of the heap.
    // The running time of this method should be O(log(n)+log(k)).
    public void updatePriority(T item) {
        MyPriorityQueue<T> temp = itemToHeap.get(item);
    
        if (temp == null) {
            throw new IllegalArgumentException("No such item!");
        }
    
        temp.updatePriority(item);
    
        if (temp == topK) {
            if (topK.peek().compareTo(rest.peek()) < 0) {
                T replace = topK.extract();
                rest.insert(replace);
                itemToHeap.put(replace, rest);
                topK.insert(rest.extract());
                itemToHeap.put(item, topK);
            }
        } else {
            if (item.compareTo(topK.peek()) > 0) {
                T replace = topK.extract();
                topK.insert(item);
                itemToHeap.put(item, topK);
                rest.insert(replace);
                itemToHeap.put(replace, rest);
            }
        }
    }    

    // Removes the given item from the data structure
    // throws an IllegalArgumentException if the item
    // is not present.
    // The running time of this method should be O(log(n)+log(k)).
    public void remove(T item){
        MyPriorityQueue<T> temp = itemToHeap.get(item);

        if (temp == null) {
            throw new IllegalArgumentException("Mo such item!");
        }

        temp.remove(item);
        itemToHeap.remove(temp);

        if (temp == topK && rest.size() > 0) {
            T replace = rest.extract();
            topK.insert(replace);
            itemToHeap.put(replace, topK);
        }

        size--;
    }
}
