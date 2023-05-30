part of 'order_system_bloc.dart';

abstract class OrderSystemEvent extends Equatable {
  const OrderSystemEvent();

  @override
  List<Object?> get props {
    return [];
  }
}

class AddBotEvent extends OrderSystemEvent {}

class RemoveBotEvent extends OrderSystemEvent {}

class AddVipOrderEvent extends OrderSystemEvent {}

class AddNormalOrderEvent extends OrderSystemEvent {}

class BotStartOrderEvent extends OrderSystemEvent {
  const BotStartOrderEvent({
    required this.currentBot,
  });

  final Bot currentBot;

  @override
  List<Object> get props {
    return [
      currentBot,
    ];
  }
}

class BotCompleteOrderEvent extends OrderSystemEvent {
  const BotCompleteOrderEvent({
    required this.currentBot,
  });

  final Bot currentBot;

  @override
  List<Object> get props {
    return [
      currentBot,
    ];
  }
}

class BotStopAndPendingOrderEvent extends OrderSystemEvent {
  const BotStopAndPendingOrderEvent({
    required this.currentBot,
  });

  final Bot currentBot;

  @override
  List<Object> get props {
    return [
      currentBot,
    ];
  }
}
