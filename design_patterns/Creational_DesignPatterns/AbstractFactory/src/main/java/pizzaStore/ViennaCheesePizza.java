package pizzaStore;

public class ViennaCheesePizza extends CheesePizza {
    public ViennaCheesePizza(){
        setTopping();
    }
    @Override
    public void setTopping() {
        this.toppings.add("Mozarella");
        this.toppings.add("Tomatosauce");
    }
    @Override
    public void eat(){
        System.out.println("This pizza has following ingredients: ");
        for(String topping:this.toppings){
            System.out.println(" - "+topping);
        }
    }
}
