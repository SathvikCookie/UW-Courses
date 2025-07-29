import java.util.*;

public class Clusterer {
    private List<List<WeightedEdge<Integer, Double>>> adjList; // the adjacency list of the original graph
    private List<List<WeightedEdge<Integer, Double>>> mstAdjList; // the adjacency list of the minimum spanning tree
    private List<List<Integer>> clusters; // a list of k points, each representing one of the clusters.
    private double cost; // the distance between the closest pair of clusters
    private int totalNodes; 

    public Clusterer(double[][] distances, int k) {
        this.adjList = new ArrayList<>();
        this.totalNodes = distances.length; 

        for (int i = 0; i < distances.length; i++) {
            List<WeightedEdge<Integer, Double>> edgesFromNode = new ArrayList<>(); 
            for (int j = 0; j < distances.length; j++) {
                if (i != j) {
                    edgesFromNode.add(new WeightedEdge<Integer, Double>(i, j, distances[i][j])); 
                }
            }
            this.adjList.add(edgesFromNode); 
        }
        computeMST(0);
        partitionIntoKClusters(k); 
    }

    private void computeMST(int start) {
        this.mstAdjList = new ArrayList<>();
        for (int i = 0; i < totalNodes; i++) { 
            this.mstAdjList.add(new ArrayList<>());
        }

        PriorityQueue<WeightedEdge<Integer, Double>> edgePriorityQueue = new PriorityQueue<>(); 
        edgePriorityQueue.add(new WeightedEdge<Integer, Double>(-1, start, 0.0));

        Set<Integer> visitedNodes = new HashSet<>(); 

        while (!edgePriorityQueue.isEmpty()) { 
            WeightedEdge<Integer, Double> currentEdge = edgePriorityQueue.poll(); 

            if (visitedNodes.contains(currentEdge.destination)) { 
                continue;
            }

            visitedNodes.add(currentEdge.destination); 

            if (currentEdge.source != -1) {
                this.mstAdjList.get(currentEdge.source).add(
                        new WeightedEdge<>(currentEdge.source, currentEdge.destination, currentEdge.weight));
                this.mstAdjList.get(currentEdge.destination).add(
                        new WeightedEdge<>(currentEdge.destination, currentEdge.source, currentEdge.weight));
            }

            for (WeightedEdge<Integer, Double> neighborEdge : adjList.get(currentEdge.destination)) { 
                if (!visitedNodes.contains(neighborEdge.destination)) { 
                    edgePriorityQueue.add(neighborEdge); 
                }
            }
        }
    }

    private void partitionIntoKClusters(int k) { 
        PriorityQueue<WeightedEdge<Integer, Double>> heaviestEdges = new PriorityQueue<>(); 

        for (int i = 0; i < totalNodes; i++) { 
            List<WeightedEdge<Integer, Double>> nodeNeighbors = mstAdjList.get(i);
            for (int j = 0; j < nodeNeighbors.size(); j++) {
                WeightedEdge<Integer, Double> edge = nodeNeighbors.get(j); 
                if (edge.source < edge.destination) { 
                    if (heaviestEdges.size() < k - 1) { 
                        heaviestEdges.add(edge);
                    } else {
                        WeightedEdge<Integer, Double> smallestHeavyEdge = heaviestEdges.peek(); 
                        if (smallestHeavyEdge.weight < edge.weight) {
                            heaviestEdges.poll(); 
                            heaviestEdges.add(edge); 
                        }
                    }
                }
            }
        }

        cost = heaviestEdges.peek().weight;

        while (!heaviestEdges.isEmpty()) { 
            WeightedEdge<Integer, Double> heavyEdge = heaviestEdges.poll(); 

            deleteEdge(heavyEdge);
            deleteEdge(new WeightedEdge<Integer, Double>(heavyEdge.destination, heavyEdge.source, heavyEdge.weight));
        }

        Set<Integer> visitedNodes = new HashSet<>();
        clusters = new ArrayList<>();

        for (int startNode = 0; startNode < totalNodes; startNode++) {
            if (!visitedNodes.contains(startNode)) { 
                traverseConnectedNodes(startNode, visitedNodes); 
            }
        }
    }

    private void deleteEdge(WeightedEdge<Integer, Double> targetEdge) {
        List<WeightedEdge<Integer, Double>> nodeNeighbors = mstAdjList.get(targetEdge.source); 
        for (int i = 0; i < nodeNeighbors.size(); i++) {
            WeightedEdge<Integer, Double> edge = nodeNeighbors.get(i); 
            if (edge.source.equals(targetEdge.source) && edge.destination.equals(targetEdge.destination)
                    && edge.weight.equals(targetEdge.weight)) {
                nodeNeighbors.remove(i);
                break;
            }
        }
    }

    private void traverseConnectedNodes(Integer startNode, Set<Integer> visitedNodes) { 
        List<Integer> clusterNodes = new ArrayList<>(); 
        Queue<Integer> traversalQueue = new LinkedList<>(); 
        traversalQueue.add(startNode); 

        while (!traversalQueue.isEmpty()) { 
            int currentNode = traversalQueue.poll();

            if (visitedNodes.contains(currentNode)) { 
                continue;
            }

            visitedNodes.add(currentNode);
            clusterNodes.add(currentNode);

            for (WeightedEdge<Integer, Double> neighborEdge : mstAdjList.get(currentNode)) {
                if (!visitedNodes.contains(neighborEdge.destination)) {
                    traversalQueue.add(neighborEdge.destination); 
                }
            }
        }

        clusters.add(clusterNodes);
    }

    public List<List<Integer>> getClusters() {
        return clusters;
    }

    public double getCost() {
        return cost;
    }
}
