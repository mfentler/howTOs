public class Demo {
    public static void main(String[] args){
        SimpleFactory factory = new SimpleFactory();
        Shape object1 = factory.getObject("CUBE");
        object1.draw();
        Shape object2 = factory.getObject("RECTANGLE");
        object2.draw();
    }
}
