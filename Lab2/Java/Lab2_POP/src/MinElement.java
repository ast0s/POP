public class MinElement {
    public int value;
    public int index;

    public MinElement(int value, int index) {
        this.value = value;
        this.index = index;
    }

    @Override
    public String toString() {
        return "minimal element: " + value + ", index: " + index + ";";
    }
}