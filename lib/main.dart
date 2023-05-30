import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:se_take_home_assignment/bloc/order_system_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("McD"),
      ),
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: BlocBuilder<OrderSystemBloc, OrderSystemState>(
          builder: (context, state) {
            final botList = state.botList;
            final vipOrderList = state.vipOrderList;
            final normalOrderList = state.normalOrderList;
            final completeOrderList = state.completeOrderList;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text("- Bot"),
                      ),
                      12.pw,
                      TextButton(
                        onPressed: () {},
                        child: const Text("+ Bot"),
                      ),
                    ],
                  ),
                  12.ph,
                  const Text("Bot"),
                  4.ph,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Row(
                      children: [],
                    ),
                  ),
                  24.ph,
                  const Text("VIP Order"),
                  4.ph,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Row(
                      children: [],
                    ),
                  ),
                  12.ph,
                  const Text("Normal Order"),
                  4.ph,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Row(
                      children: [],
                    ),
                  ),
                  12.ph,
                  const Text("Completed Order"),
                  4.ph,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Row(
                      children: [],
                    ),
                  ),
                  12.ph,
                  const Spacer(),
                  12.ph,
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text("Add VIP Order"),
                      ),
                      12.pw,
                      TextButton(
                        onPressed: () {},
                        child: const Text("Add Normal Order"),
                      ),
                    ],
                  ),
                  12.ph,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

extension EmptyPadding on num {
  SizedBox get ph => SizedBox(height: toDouble());

  SizedBox get pw => SizedBox(width: toDouble());
}
