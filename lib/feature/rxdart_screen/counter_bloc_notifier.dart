import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class MyNameEntity {
  final String firstName;
  final String lastName;
  MyNameEntity({
    required this.firstName,
    required this.lastName,
  });

  MyNameEntity copy() {
    return MyNameEntity(
      firstName: firstName,
      lastName: lastName,
    );
  }
}

class CounterBlocNotifier extends ChangeNotifier {
  int initialCount = 0;
  late MyNameEntity myNameEntity;
  late BehaviorSubject<int> _subjectCounter;
  late BehaviorSubject<MyNameEntity> _subjectMyName;

  CounterBlocNotifier() {
    _subjectCounter = BehaviorSubject<int>.seeded(initialCount);
    myNameEntity = MyNameEntity(firstName: "Ridwan", lastName: "Fatur");
    _subjectMyName = BehaviorSubject<MyNameEntity>.seeded(myNameEntity);
  }

  Stream<int> get counterObservable {
    return _subjectCounter.stream;
  }

  Stream<MyNameEntity> get myNameObservable {
    return _subjectMyName.stream;
  }

  void changeName() {
    if (myNameEntity.firstName == "Ridwan") {
      myNameEntity = MyNameEntity(firstName: "Nadya", lastName: "Putri");
    } else {
      myNameEntity = MyNameEntity(firstName: "Ridwan", lastName: "Fatur");
    }
    
    _subjectMyName.sink.add(myNameEntity);
  }

  void increment() {
    initialCount++;
    _subjectCounter.sink.add(initialCount);
  }

  void decrement() {
    initialCount--;
    _subjectCounter.sink.add(initialCount);
  }
}
