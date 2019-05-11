package kaffeehaus;

public class Demo {
    public static void main(String[] args){
        Coffee c1 = new Espresso();
        c1 = new Milk(c1);
        c1 = new Sugar(c1);
        c1 = new Milk(c1);
        System.out.println(c1.getDescription());
        System.out.println(c1.cost());


        Coffee c2 = new Cappuchino();
        c2 = new Sugar(c2);
        System.out.println(c2.getDescription());
        System.out.println(c2.cost());
    }
}
