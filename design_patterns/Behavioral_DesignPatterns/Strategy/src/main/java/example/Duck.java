package example;

public class Duck {
    protected QuackBehaviour qb;
    protected FlyBehaviour fb;

    public void performQuack(){
        qb.quack();
    }
    public void performFly(){
        fb.fly();
    }
}
