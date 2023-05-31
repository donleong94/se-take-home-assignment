import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:se_take_home_assignment/bloc/order_system_bloc.dart';
import 'package:se_take_home_assignment/widget/bot_item_widget.dart';
import 'package:se_take_home_assignment/widget/order_item_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  final OrderSystemBloc orderSystemBloc = OrderSystemBloc();

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
          bloc: orderSystemBloc,
          builder: (context, state) {
            final botList = state.botList;
            final vipOrderList = state.pendingOrderList;
            final completeOrderList = state.completeOrderList;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          orderSystemBloc.add(RemoveBotEvent());
                        },
                        child: const Text("- Bot"),
                      ),
                      12.pw,
                      TextButton(
                        onPressed: () {
                          orderSystemBloc.add(AddBotEvent());
                        },
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
                      children: [
                        ...botList.mapIndexed(
                          (index, item) {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: BotItemWidget(
                                bot: item,
                                onCompleteOrder: () {
                                  orderSystemBloc.add(BotCompleteOrderEvent(currentBot: item));
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  24.ph,
                  const Text("PENDING"),
                  4.ph,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Row(
                      children: [
                        ...vipOrderList.mapIndexed(
                          (index, item) {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: OrderItemWidget(
                                order: item,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  12.ph,
                  const Text("COMPLETE"),
                  4.ph,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Row(
                      children: [
                        ...completeOrderList.mapIndexed(
                          (index, item) {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: OrderItemWidget(
                                order: item,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  12.ph,
                  const Spacer(),
                  12.ph,
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          orderSystemBloc.add(AddVipOrderEvent());
                        },
                        child: const Text("Add VIP Order"),
                      ),
                      12.pw,
                      TextButton(
                        onPressed: () {
                          orderSystemBloc.add(AddNormalOrderEvent());
                        },
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
