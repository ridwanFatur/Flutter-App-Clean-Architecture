import 'package:rxdart/rxdart.dart';

class CounterBloc {
  int initialCount = 0;
  late BehaviorSubject<int> _subjectCounter;

  CounterBloc(this.initialCount) {
    _subjectCounter = BehaviorSubject<int>.seeded(initialCount);
  }

  Stream<int> get counterObservable {
    return _subjectCounter.stream;
  }

  void increment() {
    initialCount++;
    _subjectCounter.sink.add(initialCount);
  }

  void decrement() {
    initialCount--;
    _subjectCounter.sink.add(initialCount);
  }

  void dispose() {
    _subjectCounter.close();
  }
}
