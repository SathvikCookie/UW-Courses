import java.util.ArrayList;
import java.util.List;

public class BinarySearchTree<K extends Comparable<K>, V> implements OrderedDeletelessDictionary<K,V> {

    // Fields were made public to assist with autograding
    // Do not change the visibility of these fields :)
    public TreeNode<K, V> root;
    public int size;

    public BinarySearchTree(){
        root = null;
        size = 0;
    }

    public int size(){
        return size;
    }

    public boolean isEmpty(){
        return size == 0;
    }

    public V find(K key){
        if(root == null){
            throw new IllegalStateException();
        }
        return find(key, root);
    }

    //recursive helper
    private V find(K key, TreeNode<K,V> curr){
        if(curr == null){
            return null;
        }
        int currMinusNew = curr.key.compareTo(key); // negative if curr is smaller
        if(curr.key.equals(key)){
            return curr.value;
        } else if(currMinusNew < 0){
            // curr is smaller so key must be to the right.
            return find(key, curr.right);
        } else{
            return find(key, curr.left);
        }
    }

    // Returns the smallest key which is greater than the given key
    // Returns null if the given key is greater than or equal to the largest
    // key present
    public K findNextKey(K key){
        if (root == null) {
            return null;
        }

        return findNextKey(key, root, null);
    }

    private K findNextKey(K key, TreeNode<K, V> curr, K min) {
        if (curr == null) {
            return min;
        }

        if (curr.key.compareTo(key) > 0) {
            min = curr.key;
            return findNextKey(key, curr.left, min);
        } else {
            return findNextKey(key, curr.right, min);
        }
    }

    // Returns the largest key which is less than the given key
    // Returns null if the given key is less than or equal to the smallest
    // key present
    public K findPrevKey(K key){
        if (root == null) {
            return null;
        }

        return findPrevKey(key, root, null);
    }

    private K findPrevKey(K key, TreeNode<K, V> curr, K max) {
        if (curr == null) {
            return max;
        }

        if (curr.key.compareTo(key) < 0) {
            max = curr.key;
            return findPrevKey(key, curr.right, max);
        } else {
            return findPrevKey(key, curr.left, max);
        }
    }

    public V insert(K key, V value){
        V answer = find(key, root);
        if(answer == null){
            size++;
        }
        root = insert(key, value, root);
        root.updateHeight();
        return answer; 
    }

    private TreeNode<K,V> insert(K key, V value, TreeNode<K,V> curr){
        if (curr == null){
            return new TreeNode<>(key, value);
        }
        int currMinusNew = curr.key.compareTo(key);
        if(currMinusNew==0){
            curr.value = value;
        } else if(currMinusNew < 0){
            curr.right = insert(key, value, curr.right);
        } else{
            curr.left = insert(key, value, curr.left);
        }
        curr.updateHeight();
        return curr;
    }

    public List<V> getValues(){
        List<V> values = new ArrayList<>();
        inorderFillValues(values, root);
        return values;
    }

    private void inorderFillValues(List<V> values, TreeNode<K,V> curr){
        if(curr != null){
            inorderFillValues(values, curr.left);
            values.add(curr.value);
            inorderFillValues(values, curr.right);
        }
    }

    public List<K> getKeys(){
        List<K> keys = new ArrayList<K>();
        inorderFillKeys(keys, root);
        return keys;
    }

    private void inorderFillKeys(List<K> keys, TreeNode<K,V> curr){
        if(curr != null){
            inorderFillKeys(keys, curr.left);
            keys.add(curr.key);
            inorderFillKeys(keys, curr.right);
        }
    }

    public void printSideways() {
        printSideways(root, 0);
    }

    private void printSideways(TreeNode<K,V> root, int level) {
        if (root != null) {
            printSideways(root.right, level + 1);
            for (int i = 0; i < level; i++) {
                System.out.print("    ");
            }
            System.out.println(root.key);
            printSideways(root.left, level + 1);
        }
    }
}
