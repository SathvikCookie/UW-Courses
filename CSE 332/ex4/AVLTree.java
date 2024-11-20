public class AVLTree  <K extends Comparable<K>, V> extends BinarySearchTree<K,V> {

    public AVLTree(){
        super();
    }

    public V insert(K key, V value){
        V answer = null;

        if (root != null) {
            answer = find(key);
        }

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

        // ROTATE
        // Get left and right heights
        int difference = getHeight(curr.left) - getHeight(curr.right);

        if (difference < -1) {
            // check if inserted into right or left and either rotate once or twice
            if (getHeight(curr.right.right) >= getHeight(curr.right.left)) {
                curr = rotateLeft(curr);
            } else {
                curr.right = rotateRight(curr.right);
                curr = rotateLeft(curr);
            }
        } else if (difference > 1) {
            // check if inserted into right or left and either rotate once or twice
            if (getHeight(curr.left.left) >= getHeight(curr.left.right)) {
                curr = rotateRight(curr);
            } else {
                curr.left = rotateLeft(curr.left);
                curr = rotateRight(curr);
            }
        }

        return curr;
    }

    private int getHeight(TreeNode<K,V> node) {
        if (node == null) {
            return -1;
        } else {
            return node.height;
        }
    }

    private TreeNode<K,V> rotateRight(TreeNode<K,V> curr) {
        TreeNode<K,V> leftChild = curr.left;
        curr.left = leftChild.right;
        leftChild.right = curr;

        curr.updateHeight();
        leftChild.updateHeight();

        return leftChild;
    }

    private TreeNode<K,V> rotateLeft(TreeNode<K,V> curr) {
        TreeNode<K,V> rightChild = curr.right;
        curr.right = rightChild.left;
        rightChild.left = curr;

        curr.updateHeight();
        rightChild.updateHeight();

        return rightChild;
    }
}

