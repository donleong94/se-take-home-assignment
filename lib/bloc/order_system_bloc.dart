import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:se_take_home_assignment/model/bot.dart';
import 'package:se_take_home_assignment/model/order.dart';

part 'order_system_event.dart';

part 'order_system_state.dart';

class OrderSystemBloc extends Bloc<OrderSystemEvent, OrderSystemState> {
  OrderSystemBloc() : super(const OrderSystemState()) {
    on<OrderSystemEvent>(
      _onOrderSystemEvent,
      transformer: sequential(),
    );
  }

  _onOrderSystemEvent(
    OrderSystemEvent event,
    Emitter<OrderSystemState> emitter,
  ) async {
    if (event is AddBotEvent) {
      _onAddBotEvent(event, emitter);
    } else if (event is RemoveBotEvent) {
      _onRemoveBotEvent(event, emitter);
    } else if (event is AddVipOrderEvent) {
      _onAddVipOrderEvent(event, emitter);
    } else if (event is AddNormalOrderEvent) {
      _onAddNormalOrderEvent(event, emitter);
    } else if (event is BotStartOrderEvent) {
      _onBotStartOrderEvent(event, emitter);
    } else if (event is BotCompleteOrderEvent) {
      _onBotCompleteOrderEvent(event, emitter);
    } else if (event is BotStopAndPendingOrderEvent) {
      _onBotStopAndPendingOrderEvent(event, emitter);
    }
  }

  void _onAddBotEvent(
    AddBotEvent event,
    Emitter<OrderSystemState> emitter,
  ) async {
    final int newCounter = state.botNoCounter + 1;
    final List<Bot> botList = state.botList;
    final Bot newBot = Bot(botNo: newCounter);
    botList.add(newBot);

    emitter(
      state.copyWith(
        botNoCounter: newCounter,
        botList: botList,
      ),
    );

    add(
      BotStartOrderEvent(
        currentBot: newBot,
      ),
    );
  }

  _onRemoveBotEvent(
    RemoveBotEvent event,
    Emitter<OrderSystemState> emitter,
  ) async {
    final List<Bot> botList = state.botList;

    if (botList.isNotEmpty) {
      final Bot lastBot = botList.last;

      add(
        BotStopAndPendingOrderEvent(
          currentBot: lastBot,
        ),
      );

      botList.removeLast();

      emitter(
        state.copyWith(
          botList: botList,
        ),
      );
    }
  }

  _onAddVipOrderEvent(
    AddVipOrderEvent event,
    Emitter<OrderSystemState> emitter,
  ) async {
    final int newCounter = state.orderNoCounter + 1;
    final List<Order> orderList = state.vipOrderList;
    final List<Bot> botList = state.botList;

    final Order newOrder = Order(orderNo: newCounter, isVip: true);
    final Bot? availableBot = botList.firstWhereOrNull((item) => item.currentProcessingOrder == null);
    orderList.add(newOrder);

    emitter(
      state.copyWith(
        orderNoCounter: newCounter,
        vipOrderList: orderList,
      ),
    );

    if (availableBot != null) {
      add(
        BotStartOrderEvent(
          currentBot: availableBot,
        ),
      );
    }
  }

  _onAddNormalOrderEvent(
    AddNormalOrderEvent event,
    Emitter<OrderSystemState> emitter,
  ) async {
    final int newCounter = state.orderNoCounter + 1;
    final List<Order> orderList = state.normalOrderList;
    final List<Bot> botList = state.botList;

    final Order newOrder = Order(orderNo: newCounter, isVip: false);
    final Bot? availableBot = botList.firstWhereOrNull((item) => item.currentProcessingOrder == null);
    orderList.add(newOrder);

    emitter(
      state.copyWith(
        orderNoCounter: newCounter,
        normalOrderList: orderList,
      ),
    );

    if (availableBot != null) {
      add(
        BotStartOrderEvent(
          currentBot: availableBot,
        ),
      );
    }
  }

  _onBotStartOrderEvent(
    BotStartOrderEvent event,
    Emitter<OrderSystemState> emitter,
  ) async {
    final vipOrderList = state.vipOrderList;
    final normalOrderList = state.normalOrderList;
    final Bot currentBot = event.currentBot;

    final Order? availableVipOrder = vipOrderList.firstWhereOrNull((item) => item.isPending());
    final Order? availableNormalOrder = normalOrderList.firstWhereOrNull((item) => item.isPending());

    if (availableVipOrder != null) {
      availableVipOrder.setStatusProcessing();
      currentBot.currentProcessingOrder = availableVipOrder;
    } else if (availableNormalOrder != null) {
      availableNormalOrder.setStatusProcessing();
      currentBot.currentProcessingOrder = availableNormalOrder;
    }

    emitter(state);
  }

  _onBotCompleteOrderEvent(
    BotCompleteOrderEvent event,
    Emitter<OrderSystemState> emitter,
  ) async {
    final List<Order> vipList = state.vipOrderList;
    final List<Order> normalList = state.normalOrderList;
    final List<Order> completeList = state.completeOrderList;
    final Bot currentBot = event.currentBot;

    if (currentBot.currentProcessingOrder != null) {
      final Order completedOrder = currentBot.currentProcessingOrder!;
      currentBot.currentProcessingOrder = null;
      completeList.add(completedOrder);

      if (completedOrder.isVip) {
        vipList.removeWhere((item) => item.orderNo == completedOrder.orderNo);
      } else {
        normalList.removeWhere((item) => item.orderNo == completedOrder.orderNo);
      }
    }

    emitter(
      state.copyWith(
        vipOrderList: vipList,
        normalOrderList: normalList,
        completeOrderList: completeList,
      ),
    );
  }

  _onBotStopAndPendingOrderEvent(
    BotStopAndPendingOrderEvent event,
    Emitter<OrderSystemState> emitter,
  ) async {
    final List<Order> vipList = state.vipOrderList;
    final List<Order> normalList = state.normalOrderList;
    final Bot currentBot = event.currentBot;

    if (currentBot.currentProcessingOrder != null) {
      final Order currentOrder = currentBot.currentProcessingOrder!;
      currentOrder.setStatusPending();
      currentBot.currentProcessingOrder = null;

      if (currentOrder.isVip) {
        vipList.insert(0, currentOrder);
      } else {
        normalList.insert(0, currentOrder);
      }

      emitter(
        state.copyWith(
          vipOrderList: vipList,
          normalOrderList: normalList,
        ),
      );
    }
  }
}
