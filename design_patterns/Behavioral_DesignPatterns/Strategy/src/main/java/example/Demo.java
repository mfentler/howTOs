package example;

public class Demo {
    public static void main(String[] args){
        Duck d1 = new NormalDuck();
        d1.performQuack();
        d1.performFly();
        Duck d2 = new GummiEnte();
        d2.performQuack();
        d2.performFly();
    }
}
