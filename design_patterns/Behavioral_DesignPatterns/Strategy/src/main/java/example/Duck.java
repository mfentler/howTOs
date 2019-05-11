package example;

public class Duck {
    QuackBehaviour qb;
    FlyBehaviour fb;

    public void performQuack(){
        qb.quack();
    }
    public void performFly(){
        fb.fly();
    }
}
