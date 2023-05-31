import 'package:flutter/material.dart';
import 'package:se_take_home_assignment/main.dart';
import 'package:se_take_home_assignment/model/bot.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class BotItemWidget extends StatefulWidget {
  const BotItemWidget({
    super.key,
    required this.bot,
    required this.onCompleteOrder,
  });

  final Bot bot;
  final Function() onCompleteOrder;

  @override
  State<BotItemWidget> createState() => _BotItemWidgetState();
}

class _BotItemWidgetState extends State<BotItemWidget> {
  final CountdownController _controller = CountdownController(autoStart: true);
  bool isRunning = false;

  @override
  Widget build(BuildContext context) {
    final currentOrder = widget.bot.currentProcessingOrder;
    final hasOrder = currentOrder != null;
    final String botName = "Bot #${widget.bot.botNo}";
    String orderProcessing = "";

    if (hasOrder) {
      if (!isRunning) {
        isRunning = true;
        _controller.restart();
      }

      orderProcessing = "Process Order #${currentOrder.orderNo}";
    } else {
      orderProcessing = "Idle";
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 2,
          color: Colors.grey,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Text(botName),
            4.ph,
            Text(orderProcessing),
            4.ph,
            hasOrder
                ? Countdown(
                    controller: _controller,
                    seconds: 5,
                    build: (BuildContext context, double time) {
                      return Text("${time.toInt()}s");
                    },
                    onFinished: () {
                      isRunning = false;
                      widget.onCompleteOrder();
                    },
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
