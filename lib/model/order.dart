class Order {
  Order({
    required this.orderNo,
    required this.isVip,
  });

  final int orderNo;
  final bool isVip;
  int status = 0;
  int progress = 0;

  void setStatusPending() {
    status = 0;
    progress = 0;
  }

  void setStatusProcessing() {
    status = 1;
  }

  void setStatusCompleted() {
    status = 2;
  }

  bool isPending() {
    return status == 0;
  }

  bool isProcessing() {
    return status == 1;
  }

  bool isCompleted() {
    return status == 2;
  }
}
