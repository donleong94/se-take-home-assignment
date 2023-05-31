part of 'order_system_bloc.dart';

class OrderSystemState extends Equatable {
  const OrderSystemState({
    this.botNoCounter = 0,
    this.orderNoCounter = 0,
    this.botList = const [],
    this.pendingOrderList = const [],
    this.completeOrderList = const [],
  });

  final int botNoCounter;
  final int orderNoCounter;
  final List<Bot> botList;
  final List<Order> pendingOrderList;
  final List<Order> completeOrderList;

  OrderSystemState copyWith({
    int? botNoCounter,
    int? orderNoCounter,
    List<Bot>? botList,
    List<Order>? pendingOrderList,
    List<Order>? completeOrderList,
  }) {
    return OrderSystemState(
      botNoCounter: botNoCounter ?? this.botNoCounter,
      orderNoCounter: orderNoCounter ?? this.orderNoCounter,
      botList: botList ?? this.botList,
      pendingOrderList: pendingOrderList ?? this.pendingOrderList,
      completeOrderList: completeOrderList ?? this.completeOrderList,
    );
  }

  @override
  List<Object?> get props {
    return [
      botNoCounter,
      orderNoCounter,
      botList,
      pendingOrderList,
      completeOrderList,
    ];
  }
}
