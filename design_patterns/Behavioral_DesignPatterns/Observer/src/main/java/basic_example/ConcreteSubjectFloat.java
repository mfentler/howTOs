package basic_example;

public class ConcreteSubjectFloat extends Observer{
    public ConcreteSubjectFloat(Subject s){
        this.subject = s;
        this.subject.attach(this);
    }


    @Override
    public void update() {
        Float f = (float)subject.getState();
        System.out.println("Float is: "+f);
    }
}
