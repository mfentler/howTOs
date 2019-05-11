package kaffeehaus;

public class Sugar extends Topping {
    private Coffee coffee;

    public Sugar(Coffee c){
        coffee = c;
    }

    @Override
    public String getDescription() {
        return coffee.getDescription()+", Extra Sugar";
    }

    @Override
    public double cost() {
        return coffee.cost()+0.15;
    }
}
