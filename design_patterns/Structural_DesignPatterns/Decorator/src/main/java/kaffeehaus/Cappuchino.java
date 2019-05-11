package kaffeehaus;

public class Cappuchino extends Coffee {

    public Cappuchino(){
        this.description = "Cappuchino";
    }

    @Override
    public double cost() {
        return 2.0;
    }
}
