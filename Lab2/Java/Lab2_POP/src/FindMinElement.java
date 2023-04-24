import java.util.Arrays;

public class FindMinElement {
    private final int[] array;
    private final FinderThread[] threads;
    private MinElement minElement;
    private int finishedThreadsCount;

    public FindMinElement(int[] randomArray, int threadsCount) {
        array = randomArray;
        threads = new FinderThread[threadsCount];
        minElement = new MinElement(array[0], 0);
        finishedThreadsCount = 0;

        int amountForOneThread = array.length / threadsCount;
        for (int i = 0; i < threads.length - 1; i++)
            threads[i] = new FinderThread(i * amountForOneThread, (i + 1) * amountForOneThread, this);
        threads[threads.length - 1] = new FinderThread((threads.length - 1) * amountForOneThread, array.length, this);
    }

    public MinElement startThreads() {
        for (int i = 0; i < threads.length; i++)
            threads[i].start();

        if (awaitAllThreads()) return minElement;
        throw new RuntimeException("Something went wrong");
    }

    public MinElement findLocal(int startIndex, int endIndex) {
        MinElement localMin = new MinElement(array[startIndex], startIndex);
        for (int i = startIndex; i < endIndex; i++) {
            if (array[i] < localMin.value) localMin = new MinElement(array[i], i);
        }
        return localMin;
    }

    synchronized public void anotherThreadFinished() {
        finishedThreadsCount++;
        notify();
    }

    synchronized private boolean awaitAllThreads() {
        while (finishedThreadsCount < threads.length) {
            try {
                wait();
            } catch (InterruptedException err) {
                err.printStackTrace();
            }
        }
        return true;
    }

    synchronized public void collectMinElement(MinElement input) {
        if (input.value < minElement.value) minElement = input;

    }
}