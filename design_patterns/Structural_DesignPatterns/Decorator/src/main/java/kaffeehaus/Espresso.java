package kaffeehaus;

public class Espresso extends Coffee {

    public Espresso(){
        this.description = "Espresso";
    }
    @Override
    public double cost() {
        return 1.5;
    }
}
