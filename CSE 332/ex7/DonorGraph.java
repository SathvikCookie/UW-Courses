import java.util.*;

public class DonorGraph {
    private List<List<Match>> adjList;

    // The donatingTo array indicates which repient each donor is
    // affiliated with. Specifically, the donor at index i has volunteered
    // to donate a kidney on behalf of recipient donatingTo[i].
    // The matchScores 2d array gives the match scores associated with each
    // donor-recipient pair. Specificically, matchScores[x][y] gives the
    // HLA score for donor x and reciplient y.
    public DonorGraph(int[] donorToBenefit, int[][] matchScores) {
        adjList = new ArrayList<>();

        for (int i = 0; i < matchScores[0].length; i++) {
            adjList.add(new ArrayList<>());
        }

        for (int recipient = 0; recipient < matchScores[0].length; recipient++) {
            for (int donor = 0; donor < matchScores.length; donor++) {
                if (matchScores[donor][recipient] >= 60) {
                    int beneficiary = donorToBenefit[donor];

                    adjList.get(beneficiary).add(new Match(donor, beneficiary, recipient));
                }
            }
        }
    }

    // Will be used by the autograder to verify your graph's structure.
    // It's probably also going to helpful for your debugging.
    public boolean isAdjacent(int start, int end){
        for(Match m : adjList.get(start)){
            if(m.recipient == end)
                return true;
        }
        return false;
    }

    // Will be used by the autograder to verify your graph's structure.
    // It's probably also going to helpful for your debugging.
    public int getDonor(int beneficiary, int recipient){
        for(Match m : adjList.get(beneficiary)){
            if(m.recipient == recipient)
                return m.donor;
        }
        return -1;
    }


    // returns a chain of matches to make a donor cycle
    // which includes the given recipient.
    // Returns an empty list if no cycle exists. 
    public List<Match> findCycle(int recipient) {
        List<Match> path = new ArrayList<>();
        Set<Integer> visited = new HashSet<>();
        if (findCycleHelper(recipient, recipient, path, visited)) {
            return path;
        } else {
            return new ArrayList<>();
        }
    }
    
    private boolean findCycleHelper(int curr, int target, List<Match> path, Set<Integer> visited) {
        visited.add(curr);
    
        for (Match m : adjList.get(curr)) {
            if (m.recipient == target) {
                path.add(m);
                return true;
            }
    
            if (!visited.contains(m.recipient)) {
                path.add(m);
                if (findCycleHelper(m.recipient, target, path, visited)) {
                    return true;
                }
                path.remove(path.size() - 1);
            }
        }
    
        visited.remove(curr);
        return false;
    }
    

    // returns true or false to indicate whether there
    // is some cycle which includes the given recipient.
    public boolean hasCycle(int recipient){
        return hasCycleHelper(recipient, recipient, new HashSet<>(), new HashSet<>());
    }

    private boolean hasCycleHelper(int curr, int target, Set<Integer> visited, Set<Integer> done) {
        visited.add(curr);
        boolean cycleFound = false;

        for (Match m : adjList.get(curr)) {
            if (m.recipient == target && !done.contains(m.recipient)) {
                cycleFound = true;
            }

            if (!visited.contains(m.recipient) && !cycleFound) {
                cycleFound = hasCycleHelper(m.recipient, target, visited, done);
            }
        }

        done.add(curr);
        return cycleFound;
    }
}
