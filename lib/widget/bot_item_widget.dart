import 'package:flutter/material.dart';
import 'package:se_take_home_assignment/model/bot.dart';

class BotItemWidget extends StatefulWidget {
  const BotItemWidget({
    super.key,
    required this.bot,
  });

  final Bot bot;

  @override
  State<BotItemWidget> createState() => _BotItemWidgetState();
}

class _BotItemWidgetState extends State<BotItemWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
