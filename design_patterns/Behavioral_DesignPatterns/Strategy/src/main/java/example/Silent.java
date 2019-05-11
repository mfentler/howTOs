package example;

public class Silent implements QuackBehaviour {
    @Override
    public void quack() {
        System.out.println("...");
    }
}
