package pizzaStore;

public class NYCheesePizza extends CheesePizza {
    public NYCheesePizza(){
        setTopping();
    }
    @Override
    public void setTopping() {
        this.toppings.add("Cheddar");
        this.toppings.add("Tomatosauce");
        this.toppings.add("Extra cheese");
    }
    @Override
    public void eat(){
        System.out.println("This pizza has following ingredients: ");
        for(String topping:this.toppings){
            System.out.println(" - "+topping);
        }
    }
}
