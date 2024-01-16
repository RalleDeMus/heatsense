abstract interface class Subject {
  void attach(Observer o);
  void detach(Observer o);
  void notify();
}

class Subject1 implements Subject {
  List<Observer> observers = [];

  @override
  void attach(Observer o) {
    observers.add(o);
  }

  @override
  void detach(Observer o) {
    observers.remove(o);
  }

  @override
  void notify() {
    for (final o in observers){
      o.update();
    }
  }
  
  
  void getState() {
    return ;
  }

}

abstract interface class Observer {
void update();
}

class Observer1 implements Observer {
  @override
  void update() {
    // TODO: implement update
  }

}