import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Semaphore;

public class Manager {
    int storageSize;
    public Semaphore access;
    public Semaphore full;
    public Semaphore empty;
    public volatile int itemTarget;
    public volatile int itemProduced;
    public volatile int itemConsumed;

    private int lastIndex = 0;
    public List<String> storage;

    public Manager(int storageSize, int itemTarget) {
        this.storageSize = storageSize;
        this.itemTarget = itemTarget;
        this.itemConsumed = 0;
        this.itemProduced = 0;
        access = new Semaphore(1);
        full = new Semaphore(storageSize);
        empty = new Semaphore(0);
        storage = new ArrayList<>();
    }

    public int put(){
        storage.add("item " + lastIndex);
        lastIndex++;
        return lastIndex - 1;
    }
}