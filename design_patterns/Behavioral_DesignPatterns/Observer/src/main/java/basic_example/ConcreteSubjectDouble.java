package basic_example;

public class ConcreteSubjectDouble extends Observer{

    public ConcreteSubjectDouble(Subject s){
        this.subject = s;
        this.subject.attach(this);
    }

    @Override
    public void update() {
        Double d = (double)subject.getState();
        System.out.println("The double state is: "+d);
    }
}
