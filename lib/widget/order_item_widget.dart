import 'package:flutter/material.dart';
import 'package:se_take_home_assignment/main.dart';
import 'package:se_take_home_assignment/model/order.dart';

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({
    super.key,
    required this.order,
  });

  final Order order;

  @override
  Widget build(BuildContext context) {
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
            Text("Order #${order.orderNo}"),
            4.ph,
            Text(order.isVip ? "VIP" : "Normal"),
          ],
        ),
      ),
    );
  }
}
