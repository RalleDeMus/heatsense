abstract interface class Subject {
  List<Observer> get observers;

  void attach(Observer o);

  void detach(Observer o);

  void notify();
}

abstract interface class Observer {
  void update();
}

class Subject1 implements Subject {
  String state = 'state';

  @override
  // TODO: implement o
  List<Observer> observers = [];

  @override
  void attach(Observer o) {
    observers.add(o);
    // TODO: implement attach
  }

  @override
  void detach(Observer o) {
    observers.remove(o);
    // TODO: implement detach
  }

  @override
  void notify() {
    for (final o in observers) {
      o.update();
    }
  }
}

class Observer1 implements Observer {
  String state = 'state';

  @override
  void update() {}
}

class Observer2 implements Observer {
  String state = 'state';

  @override
  void update() {
    // TODO: implement update
  }
}
