package kaffeehaus;

public class Milk extends Topping {
    Coffee coffee;
    public Milk(Coffee c){
        coffee = c;
    }
    @Override
    public String getDescription() {
        return coffee.getDescription()+", Extra Milk";
    }

    @Override
    public double cost() {
        return coffee.cost()+0.5;
    }
}
