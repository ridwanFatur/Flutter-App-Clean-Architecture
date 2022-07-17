import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/feature/rxdart_screen/counter_bloc_notifier.dart';
import 'package:provider/provider.dart';

class RxDartScreen extends StatefulWidget {
  const RxDartScreen({Key? key}) : super(key: key);

  @override
  State<RxDartScreen> createState() => _RxDartScreenState();
}

class _RxDartScreenState extends State<RxDartScreen> {
  @override
  Widget build(BuildContext context) {
    print("Build");
    final counterObservable =
        context.read<CounterBlocNotifier>().counterObservable;

    final myNameObservable =
        context.read<CounterBlocNotifier>().myNameObservable;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter RxDart"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<int>(
                stream: counterObservable,
                builder: (context, snapshot) {
                  return Text(
                    "${snapshot.data}",
                  );
                },
              ),
              const SizedBox(height: 20),
              StreamBuilder<MyNameEntity>(
                  stream: myNameObservable,
                  builder: (context, snapshot) {
                    MyNameEntity? entity = snapshot.data;
                    return Text("${entity?.firstName} ${entity?.lastName}");
                  }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<CounterBlocNotifier>().changeName();
                },
                child: const Text("Toggle Change String"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              context.read<CounterBlocNotifier>().increment();
            },
          ),
          const SizedBox(
            height: 16.0,
          ),
          FloatingActionButton(
            child: const Icon(Icons.remove),
            onPressed: () {
              context.read<CounterBlocNotifier>().decrement();
            },
          ),
        ],
      ),
    );
  }
}
