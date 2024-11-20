import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class ChainingHashTable <K,V> implements DeletelessDictionary<K,V>{
    private List<Item<K,V>>[] table; // the table itself is an array of linked lists of items.
    private int size;
    private static int[] primes = {11, 23, 47, 97, 197, 397, 797, 1597, 3203, 6421, 12853};

    public ChainingHashTable(){
        table = (LinkedList<Item<K,V>>[]) Array.newInstance(LinkedList.class, primes[0]);
        for(int i = 0; i < table.length; i++){
            table[i] = new LinkedList<>();
        }
        size = 0;
    }

    public boolean isEmpty(){
        return size == 0;
    }    

    public int size(){
        return size;
    }

    // TODO: implement resize
    public V insert(K key, V value){
        int index = Math.abs(key.hashCode() % table.length);

        List<Item<K,V>> chain = table[index];

        if (chain == null) {
            chain = new LinkedList<Item<K,V>>();
            table[index] = chain;
        } else {
            for (Item<K,V> item : chain) {
                if (item.key.equals(key)) {
                    V temp = item.value;
                    item.value = value;
                    return temp;
                }
            }
        }

        chain.add(new Item<K,V>(key, value));
        size++;

        if (size / table.length >= 2) {
            resize();
        }

        return null;
    }

    private void resize() {
        int newCapacity = primes[0];
        for (int prime : primes) {
            if (prime > table.length) {
                newCapacity = prime;
                break;
            }
        }

        if (newCapacity <= table.length) {
            return;
        }

        List<Item<K, V>>[] oldTable = table;
        table = (LinkedList<Item<K, V>>[]) Array.newInstance(LinkedList.class, newCapacity);
        for (int i = 0; i < table.length; i++) {
            table[i] = new LinkedList<>();
        }

        size = 0;
        for (List<Item<K, V>> chain : oldTable) {
            if (chain != null) {
                for (Item<K, V> item : chain) {
                    insert(item.key, item.value);
                }
            }
        }
    }

    // TODO
    public V find(K key){
        if (size == 0) {
            throw new IllegalStateException("Dictionary is empty!");
        }

        int index = Math.abs(key.hashCode() % table.length);
        List<Item<K,V>> chain = table[index];

        for (Item<K,V> item : chain) {
            if (item.key.equals(key)) {
                return item.value;
            }
        }

        return null;
    }

    // TODO
    public boolean contains(K key){
        int index = Math.abs(key.hashCode() % table.length);
        List<Item<K,V>> chain = table[index];

        for (Item<K,V> item : chain) {
            if (item.key.equals(key)) {
                return true;
            }
        }

        return false;
    }

    // TODO
    public List<K> getKeys(){
        ArrayList<K> out = new ArrayList<>();

        for (List<Item<K,V>> chain : table) {
            for (Item<K,V> item : chain) {
                out.add(item.key);
            }
        }

        return out;
    }

    // TODO
    public List<V> getValues(){
        ArrayList<V> out = new ArrayList<>();

        for (List<Item<K,V>> chain : table) {
            for (Item<K,V> item : chain) {
                out.add(item.value);
            }
        }

        return out;
    }

    public String toString(){
        String s = "{";
        s += table[0];
        for(int i = 1; i < table.length; i++){
            s += "," + table[i];
        }
        return s+"}";
    }

}
