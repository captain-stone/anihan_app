import 'package:flutter/material.dart';

class OrderWidgetArgs {
  final int dataPaymentCount;
  final int dataShipMentCount;
  final int dataDoneCount;

  final VoidCallback onPressedPayments;
  final VoidCallback onPressedShipments;
  final VoidCallback onGoing;
  final VoidCallback onDone;

  OrderWidgetArgs({
    required this.dataPaymentCount,
    required this.dataShipMentCount,
    required this.dataDoneCount,
    required this.onPressedPayments,
    required this.onPressedShipments,
    required this.onGoing,
    required this.onDone,
  });
}

class OrderWidgetBuyerArgs {
  final int dataPaymentCount;
  final int dataShipMentCount;

  final VoidCallback onPressedPayments;
  final VoidCallback onPressedShipments;
  final VoidCallback onGoing;
  final VoidCallback onDone;

  OrderWidgetBuyerArgs({
    required this.dataPaymentCount,
    required this.dataShipMentCount,
    required this.onPressedPayments,
    required this.onPressedShipments,
    required this.onGoing,
    required this.onDone,
  });
}
