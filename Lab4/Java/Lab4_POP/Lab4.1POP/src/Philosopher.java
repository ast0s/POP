class Philosopher implements Runnable {
    private final int id;
    private final Fork leftFork;
    private final Fork rightFork;

    public Philosopher(int id, Fork leftFork, Fork rightFork) {
        this.id = id;
        this.leftFork = leftFork;
        this.rightFork = rightFork;
    }

    @Override
    public void run() {
        Fork firstFork = leftFork.id < rightFork.id ? leftFork : rightFork;
        Fork secondFork = leftFork.id < rightFork.id ? rightFork : leftFork;

        try {
            for (int i = 0; i < 10; i++) {
                System.out.println("Philosopher " + id + " thinking time " + i);
                firstFork.access.acquire();
                System.out.println("Philosopher " + id + " took fork " + firstFork.id);
                secondFork.access.acquire();
                System.out.println("Philosopher " + id + " took fork " + secondFork.id);
                System.out.println("Philosopher " + id + " eating time " + i);
                System.out.println("Philosopher " + id + " put fork " + secondFork.id);
                secondFork.access.release();
                System.out.println("Philosopher " + id + " put fork " + firstFork.id);
                firstFork.access.release();
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
