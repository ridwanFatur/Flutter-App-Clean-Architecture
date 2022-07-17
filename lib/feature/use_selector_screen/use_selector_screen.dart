import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/feature/use_selector_screen/simple_notifier.dart';
import 'package:provider/provider.dart';

class UseSelectorScreen extends StatelessWidget {
  const UseSelectorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Build");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Use Selector"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Selector<SimpleNotifier, int>(
                selector: (context, notifier) => notifier.count,
                builder: (context, count, _) {
                  print("Build Count");
                  return Text(
                    "$count",
                  );
                },
              ),
              const SizedBox(height: 20),
              Selector<SimpleNotifier, String>(
                selector: (context, notifier) {
                  return "${notifier.myNameEntity.firstName} ${notifier.myNameEntity.lastName}";
                },
                builder: (context, name, _) {
                  print("Build MyNameEntity");
                  return Text(
                    name,
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<SimpleNotifier>().changeName();
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
              context.read<SimpleNotifier>().increment();
            },
          ),
          const SizedBox(
            height: 16.0,
          ),
          FloatingActionButton(
            child: const Icon(Icons.remove),
            onPressed: () {
              context.read<SimpleNotifier>().decrement();
            },
          ),
        ],
      ),
    );
  }
}
