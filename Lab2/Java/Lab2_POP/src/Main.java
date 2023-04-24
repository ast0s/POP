import java.util.Random;

public class Main {
    public static void main(String[] args) {
        FindMinElement finder = new FindMinElement(generateRandomArray(100000, -1), 4);
        System.out.println("Threads found: " + finder.startThreads());
    }

    static int[] generateRandomArray(int length, int negativeElement) {
        int[] result = new int[length];
        Random random = new Random();

        for (int i = 0; i < result.length; i++)
            result[i] = random.nextInt(0, length);

        int randomIndex = random.nextInt(0, length);
        System.out.println("Negative element (" + negativeElement + ") has been put into (" + randomIndex + ") index");
        result[randomIndex] = negativeElement;

        return result;
    }
}