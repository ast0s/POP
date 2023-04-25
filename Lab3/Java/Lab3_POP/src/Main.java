public class Main {

    public static void main(String[] args) {
        Main main = new Main();

        int storageSize = 4;
        int itemTarget = 8;
        int consumers = 3;
        int producers = 3;

        main.init(storageSize, itemTarget, consumers, producers);
    }

    private void init(int storageSize, int itemTarget, int consumers, int producers) {
        Manager manager = new Manager(storageSize, itemTarget);

        for (int i = 0; i < consumers; i++){
            new Consumer(i, manager);
        }

        for (int i = 0; i < producers; i++){
            new Producer(i, manager);
        }
    }
}