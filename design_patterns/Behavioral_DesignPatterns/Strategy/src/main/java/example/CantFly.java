package example;

public class CantFly implements FlyBehaviour{
    @Override
    public void fly() {
        System.out.println("I cant fly");
    }
}
