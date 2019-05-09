package basic_example;

public class Demo {
    public static void main(String[] args){
        Subject subject = new Subject();

        ConcreteSubjectDouble cd = new ConcreteSubjectDouble(subject);
        new ConcreteSubjectFloat(subject);

        //New value
        subject.setState(2000);

        //Remove from observers
        subject.detach(cd);

        //New value
        subject.setState(100);
    }
}
