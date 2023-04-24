class Stopper {
    public volatile boolean canStop = false;
    private int delayTime;

    public Stopper(int delayTime) {
        this.delayTime = delayTime;
    }

    public void setDelay() {
        try {
            Thread.sleep(delayTime * 1000);
            canStop = true;
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}