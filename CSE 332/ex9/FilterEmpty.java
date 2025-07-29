import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.RecursiveAction;

public class FilterEmpty {
    static ForkJoinPool POOL = new ForkJoinPool();
    static int CUTOFF;

    public static String[] filterEmpty(String[] arr, int cutoff) {
        FilterEmpty.CUTOFF = cutoff;
        int[] map = new int[arr.length];

        POOL.invoke(new MapEmptyTask(arr, map, 0, arr.length));

        int[] prefix = ParallelPrefix.prefixSum(map, CUTOFF);
        String[] result = new String[prefix[prefix.length - 1]];

        POOL.invoke(new PopulateTask(arr, prefix, result, 0, arr.length));
        
        return result;
    }

    private static class MapEmptyTask extends RecursiveAction {
        private final String[] arr;
        private final int[] map;
        private final int lo, hi;

        public MapEmptyTask(String[] arr, int[] map, int lo, int hi) {
            this.arr = arr;
            this.map = map;
            this.lo = lo;
            this.hi = hi;
        }

        public void compute() {
            if (hi - lo <= CUTOFF) {
                for (int i = lo; i < hi; i++) {
                    map[i] = arr[i].isEmpty() ? 0 : 1;
                }
            } else {
                int mid = (lo + hi) / 2;
                MapEmptyTask left = new MapEmptyTask(arr, map, lo, mid);
                MapEmptyTask right = new MapEmptyTask(arr, map, mid, hi);

                left.fork();
                right.compute();
                left.join();
            }
        }
    }

    private static class PopulateTask extends RecursiveAction {
        private final String[] arr;
        private final int[] prefix;
        private final String[] result;
        private final int lo, hi;

        public PopulateTask(String[] arr, int[] prefix, String[] result, int lo, int hi) {
            this.arr = arr;
            this.prefix = prefix;
            this.result = result;
            this.lo = lo;
            this.hi = hi;
        }

        public void compute() {
            if (hi - lo <= CUTOFF) {
                for (int i = lo; i < hi; i++) {
                    if (!arr[i].isEmpty()) {
                        result[prefix[i] - 1] = arr[i];
                    }
                }
            } else {
                int mid = (lo + hi) / 2;
                PopulateTask left = new PopulateTask(arr, prefix, result, lo, mid);
                PopulateTask right = new PopulateTask(arr, prefix, result, mid, hi);

                left.fork();
                right.compute();
                left.join();
            }
        }
    }
}
