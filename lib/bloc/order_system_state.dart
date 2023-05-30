part of 'order_system_bloc.dart';

class OrderSystemState extends Equatable {
  const OrderSystemState({
    this.botNoCounter = 0,
    this.orderNoCounter = 0,
    this.botList = const [],
    this.vipOrderList = const [],
    this.normalOrderList = const [],
    this.completeOrderList = const [],
  });

  final int botNoCounter;
  final int orderNoCounter;
  final List<Bot> botList;
  final List<Order> vipOrderList;
  final List<Order> normalOrderList;
  final List<Order> completeOrderList;

  OrderSystemState copyWith({
    int? botNoCounter,
    int? orderNoCounter,
    List<Bot>? botList,
    List<Order>? vipOrderList,
    List<Order>? normalOrderList,
    List<Order>? completeOrderList,
  }) {
    return OrderSystemState(
      botNoCounter: botNoCounter ?? this.botNoCounter,
      orderNoCounter: orderNoCounter ?? this.orderNoCounter,
      botList: botList ?? this.botList,
      vipOrderList: vipOrderList ?? this.vipOrderList,
      normalOrderList: normalOrderList ?? this.normalOrderList,
      completeOrderList: completeOrderList ?? this.completeOrderList,
    );
  }

  @override
  List<Object?> get props {
    return [
      botNoCounter,
      orderNoCounter,
      botList,
      vipOrderList,
      normalOrderList,
      completeOrderList,
    ];
  }
}
