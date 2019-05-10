package pizzaStore;

public class ViennaSalamiPizza extends SalamiPizza{
    public ViennaSalamiPizza(){
        setTopping();
    }
    @Override
    public void setTopping() {
        this.toppings.add("Garlic Salami");
        this.toppings.add("Mozarella");
        this.toppings.add("Tomato sauce");
    }
    @Override
    public void eat(){
        System.out.println("This pizza has following ingredients: ");
        for(String topping:this.toppings){
            System.out.println(" - "+topping);
        }
    }
}
