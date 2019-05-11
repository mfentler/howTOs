package example;

public class NormalDuck extends Duck {
    public NormalDuck(){
        this.qb = new Quack();
        this.fb = new FlyWithWings();
    }
}
