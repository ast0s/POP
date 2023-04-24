public class FinderThread extends Thread {
    private int startIndex;
    private int endIndex;
    private final FindMinElement parent;

    public FinderThread(int startIndex, int endIndex, FindMinElement parent) {
        this.startIndex = startIndex;
        this.endIndex = endIndex;
        this.parent = parent;
    }

    @Override
    public void run() {
        MinElement localMinElement = parent.findLocal(startIndex, endIndex);
        parent.collectMinElement(localMinElement);
        parent.anotherThreadFinished();
    }
}