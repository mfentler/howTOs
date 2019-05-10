package example1;

public class Demo {
    public static void main(String[] args){
        AbstractFactory factory = FactoryProducer.generateFactory(false);

        Shape shape1 = factory.generateObject("CUBE");
        shape1.getShape();
        Shape shape2 = factory.generateObject("RECTANGLE");
        shape2.getShape();

        //Switch Factory
        factory = FactoryProducer.generateFactory(true);
        Shape shape3 = factory.generateObject("CIRCLE");
        shape3.getShape();
    }
}
