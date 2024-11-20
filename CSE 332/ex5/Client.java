import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;

public class Client {
    public static void main(String[] args) {
        smallWordsearchTest();
        largeWordsearchTest();
    }

    public static void smallWordsearchTest(){
        String dictionaryFile = "smallWords.txt";
        String puzzleFile = "smallpuzzle.txt";
        List<Word<String>> dictionary = readDictionary(dictionaryFile);
        String[][] stringgrid = makeGrid(puzzleFile);
        WordSearch<String> ws = new WordSearch<>(stringgrid, dictionary);
        int count = ws.countWords();
        if(count == 7){
            System.out.println("small example is correct!");
        } else{
            System.out.println("small example is incorrect.");
        }
    }

    public static void largeWordsearchTest(){
        String dictionaryFile = "bigWords.txt";
        String puzzleFile = "bigpuzzle.txt";
        List<Word<String>> dictionary = readDictionary(dictionaryFile);
        String[][] stringgrid = makeGrid(puzzleFile);
        WordSearch<String> ws = new WordSearch<>(stringgrid, dictionary);
        int count = ws.countWords();
        if(count == 421){
            System.out.println("big example is correct!");
        } else{
            System.out.println("big example is incorrect.");
        }
    }

    public static String[][] makeGrid(String filename){
        List<String[]> lines = new ArrayList<>();
        try{
            File gridFile = new File(filename);
            Scanner gridReader = new Scanner(gridFile);
            while(gridReader.hasNextLine()){
                String line = gridReader.nextLine().toLowerCase();
                String[] splitLine = line.split(" ");
                lines.add(splitLine);
            }
            gridReader.close();
        }catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        String[][] grid = new String[lines.size()][lines.get(0).length];
        for(int i = 0; i < grid.length; i++){
            for(int j = 0; j < grid[0].length; j++){
                grid[i][j] = lines.get(i)[j];
            }
        }
        return grid;
    }

    public static List<Word<String>> readDictionary(String filename){
        List<Word<String>> dictionary = new ArrayList<>();
        try{
            File dictFile = new File(filename);
            Scanner dictReader = new Scanner(dictFile);
            while(dictReader.hasNextLine()){
                String word = dictReader.nextLine().toLowerCase();
                String[] arr = new String[word.length()];
                for(int i = 0; i < arr.length; i++){
                    arr[i] = word.substring(i, i+1);
                }
                dictionary.add(new Word<String>(arr));
            }
            dictReader.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return dictionary;
    }
}
