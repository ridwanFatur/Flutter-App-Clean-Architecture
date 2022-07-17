import 'package:flutter/material.dart';

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

class SimpleNotifier extends ChangeNotifier {
  int count = 0;
  MyNameEntity myNameEntity = MyNameEntity(firstName: "Ridwan", lastName: "Fatur");

  void changeName() {
    if (myNameEntity.firstName == "Ridwan") {
      myNameEntity = MyNameEntity(firstName: "Nadya", lastName: "Putri");
    } else {
      myNameEntity = MyNameEntity(firstName: "Ridwan", lastName: "Fatur");
    }
    notifyListeners();
  }

  void increment(){
    count ++;
    notifyListeners();
  }

  void decrement(){
    count --;
    notifyListeners();
  }
}