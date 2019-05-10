package pizzaStore;

public class NYHamPizza extends HamPizza {
    public NYHamPizza(){
        setTopping();
    }
    @Override
    public void setTopping() {
        this.toppings.add("Ham");
        this.toppings.add("Mushrooms");
    }
    @Override
    public void eat(){
        System.out.println("This pizza has following ingredients: ");
        for(String topping:this.toppings){
            System.out.println(" - "+topping);
        }
    }
}
