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
    int newCounter = state.botNoCounter + 1;
    List<Bot> botList = [...state.botList];
    Bot newBot = Bot(botNo: newCounter);
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
    List<Bot> botList = [...state.botList];

    if (botList.isNotEmpty) {
      Bot lastBot = botList.last;

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
    int newCounter = state.orderNoCounter + 1;
    List<Order> orderList = [...state.pendingOrderList];
    List<Bot> botList = [...state.botList];
    Order newOrder = Order(orderNo: newCounter, isVip: true);

    // -1 means there is no VIP order, then will add in index 0 (-1 + 1)
    int lastVip = orderList.lastIndexWhere((item) => item.isVip);
    orderList.insert(lastVip + 1, newOrder);

    emitter(
      state.copyWith(
        orderNoCounter: newCounter,
        pendingOrderList: orderList,
      ),
    );

    Bot? availableBot = botList.firstWhereOrNull((item) => item.currentProcessingOrder == null);

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
    int newCounter = state.orderNoCounter + 1;
    List<Order> orderList = [...state.pendingOrderList];
    List<Bot> botList = [...state.botList];
    Order newOrder = Order(orderNo: newCounter, isVip: false);

    // Will add into last index no matter what
    orderList.insert(orderList.length, newOrder);

    emitter(
      state.copyWith(
        orderNoCounter: newCounter,
        pendingOrderList: orderList,
      ),
    );

    Bot? availableBot = botList.firstWhereOrNull((item) => item.currentProcessingOrder == null);

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
    Bot currentBot = event.currentBot;
    List<Order> pendingOrderList = [...state.pendingOrderList];
    Order? availablePendingOrder = pendingOrderList.firstWhereOrNull((item) => item.isPending());

    if (availablePendingOrder != null) {
      availablePendingOrder.setStatusProcessing();
      currentBot.currentProcessingOrder = availablePendingOrder;
    }

    emitter(
      state.copyWith(
        pendingOrderList: pendingOrderList,
      ),
    );
  }

  _onBotCompleteOrderEvent(
    BotCompleteOrderEvent event,
    Emitter<OrderSystemState> emitter,
  ) async {
    Bot currentBot = event.currentBot;
    List<Order> pendingOrderList = [...state.pendingOrderList];
    List<Order> completeList = [...state.completeOrderList];

    if (currentBot.currentProcessingOrder != null) {
      Order completedOrder = currentBot.currentProcessingOrder!;
      currentBot.currentProcessingOrder = null;

      pendingOrderList.removeWhere((item) => item.orderNo == completedOrder.orderNo);
      completeList.add(completedOrder);
    }

    emitter(
      state.copyWith(
        pendingOrderList: pendingOrderList,
        completeOrderList: completeList,
      ),
    );

    if (currentBot.currentProcessingOrder == null) {
      add(
        BotStartOrderEvent(
          currentBot: currentBot,
        ),
      );
    }
  }

  _onBotStopAndPendingOrderEvent(
    BotStopAndPendingOrderEvent event,
    Emitter<OrderSystemState> emitter,
  ) async {
    List<Order> pendingOrderList = [...state.pendingOrderList];
    Bot currentBot = event.currentBot;

    if (currentBot.currentProcessingOrder != null) {
      Order currentOrder = currentBot.currentProcessingOrder!;
      currentOrder.setStatusPending();
      currentBot.currentProcessingOrder = null;

      emitter(
        state.copyWith(
          pendingOrderList: pendingOrderList,
        ),
      );
    }
  }
}
