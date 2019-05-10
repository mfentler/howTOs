package pizzaStore;

public class ViennaHamPizza extends HamPizza {
    public ViennaHamPizza(){
        setTopping();
    }
    @Override
    public void setTopping() {
        this.toppings.add("Ham");
    }
    @Override
    public void eat(){
        System.out.println("This pizza has following ingredients: ");
        for(String topping:this.toppings){
            System.out.println(" - "+topping);
        }
    }
}
