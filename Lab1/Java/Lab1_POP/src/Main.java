import java.util.Scanner;
public class Main {
    public static void main(String[] args) {
        try (Scanner scanner = new Scanner(System.in)) {
            System.out.print("Enter the desired amount of threads: ");
            int numThreads = scanner.nextInt();

            System.out.print("Enter the step to calculate: ");
            int step = scanner.nextInt();

            Thread[] calculatorThreads = new Thread[numThreads];
            Thread[] delayTime = new Thread[numThreads];

            for (int i = 0; i < numThreads; i++) {
                System.out.print("Enter the time (sec) of delay for " + (i + 1) + " thread: ");
                int timeDelay = scanner.nextInt();

                Stopper threadStopper = new Stopper(timeDelay);
                Calculator calculator = new Calculator(i + 1, threadStopper, step);
                delayTime[i] = new Thread(() -> threadStopper.setDelay());
                calculatorThreads[i] = new Thread(() -> calculator.result());
            }

            for (int i = 0; i < numThreads; i++) {
                calculatorThreads[i].start();
                delayTime[i].start();
            }
        }
    }
}