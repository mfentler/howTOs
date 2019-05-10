package pizzaStore;

public class NYSalamiPizza extends SalamiPizza {
    public NYSalamiPizza(){
        setTopping();
    }
    @Override
    public void setTopping() {
        this.toppings.add("Normal Salami");
    }
    @Override
    public void eat(){
        System.out.println("This pizza has following ingredients: ");
        for(String topping:this.toppings){
            System.out.println(" - "+topping);
        }
    }
}
