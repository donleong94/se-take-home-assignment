import 'package:se_take_home_assignment/model/order.dart';

class Bot {
  Bot({
    required this.botNo,
  });

  final int botNo;
  Order? currentProcessingOrder;
}
