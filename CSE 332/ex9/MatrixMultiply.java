import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.RecursiveAction;
import java.util.concurrent.RecursiveTask;

public class MatrixMultiply {
    static ForkJoinPool POOL = new ForkJoinPool();
    static int CUTOFF;

    // Behavior should match Sequential.multiply.
    // Ignoring the initialization of arrays, your implementation should have n^3 work and log(n) span
    public static int[][] multiply(int[][] a, int[][] b, int cutoff) {
        MatrixMultiply.CUTOFF = cutoff;
        int[][] product = new int[a.length][b[0].length];
        POOL.invoke(new MatrixMultiplyAction(product, a, b, 0, a.length, 0, b[0].length)); // Corrected bounds
        return product;
    }

    // Behavior should match the 2d version of Sequential.dotProduct.
    // Your implementation must have linear work and log(n) span
    public static int dotProduct(int[][] a, int[][] b, int row, int col, int start, int end, int cutoff) {
        MatrixMultiply.CUTOFF = cutoff;
        return POOL.invoke(new DotProductTask(a, b, start, end, row, col));
    }

    private static class MatrixMultiplyAction extends RecursiveAction {
        private int[][] product, a, b;
        private final int left, right, top, bottom;

        public MatrixMultiplyAction(int[][] product, int[][] a, int[][] b, int left, int right, int top, int bottom) {
            this.product = product;
            this.a = a;
            this.b = b;
            this.left = left;
            this.right = right;
            this.top = top;
            this.bottom = bottom;
        }

        public void compute() {
            if (right - left <= CUTOFF || bottom - top <= CUTOFF) {
                for (int i = left; i < right; i++) {
                    for (int j = top; j < bottom; j++) {
                        product[i][j] = dotProduct(a, b, i, j, 0, a[0].length, CUTOFF);
                    }
                }
            } else {
                int midRow = (left + right) / 2;
                int midCol = (top + bottom) / 2;

                MatrixMultiplyAction topLeft = new MatrixMultiplyAction(product, a, b, left, midRow, top, midCol);
                MatrixMultiplyAction topRight = new MatrixMultiplyAction(product, a, b, left, midRow, midCol, bottom);
                MatrixMultiplyAction bottomLeft = new MatrixMultiplyAction(product, a, b, midRow, right, top, midCol);
                MatrixMultiplyAction bottomRight = new MatrixMultiplyAction(product, a, b, midRow, right, midCol, bottom);

                topLeft.fork();
                topRight.fork();
                bottomLeft.fork();
                bottomRight.compute();
                bottomLeft.join();
                topRight.join();
                topLeft.join();
            }
        }
    }

    private static class DotProductTask extends RecursiveTask<Integer> {
        private final int[][] a, b;
        private final int lo, hi, row, col;

        public DotProductTask(int[][] a, int[][] b, int lo, int hi, int row, int col) {
            this.a = a;
            this.b = b;
            this.lo = lo;
            this.hi = hi;
            this.row = row;
            this.col = col;
        }

        public Integer compute() {
            if (hi - lo <= CUTOFF) {
                int total = 0;
                for (int i = lo; i < hi; i++) {
                    total += a[row][i] * b[i][col];
                }
                return total;
            } else {
                int mid = (lo + hi) / 2;
                DotProductTask left = new DotProductTask(a, b, lo, mid, row, col);
                DotProductTask right = new DotProductTask(a, b, mid, hi, row, col);

                left.fork();
                int rightResult = right.compute();
                int leftResult = left.join();

                return leftResult + rightResult;
            }
        }
    }
}
