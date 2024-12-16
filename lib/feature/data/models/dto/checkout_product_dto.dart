import 'package:json_annotation/json_annotation.dart';

part 'checkout_product_dto.g.dart';

@JsonSerializable()
class CheckoutProductDto {
  final String? id;
  final String buyer;
  final String buyerName;
  final String deliveryDate;
  final String messageToSeller;
  final String storeId;
  final String timeStamp;
  final double totalPrice;
  final String forApproval;
  final List<Map<String, dynamic>> productList;

  CheckoutProductDto({
    this.id,
    required this.buyer,
    required this.buyerName,
    required this.deliveryDate,
    required this.messageToSeller,
    required this.storeId,
    required this.timeStamp,
    required this.totalPrice,
    required this.productList,
    required this.forApproval,
  });

  factory CheckoutProductDto.fromMap(Map<String, dynamic> map) {
    return CheckoutProductDto(
      id: map['id'],
      buyer: map['buyer'],
      buyerName: map['buyerName'],
      deliveryDate: map['deliveryDate'],
      messageToSeller: map['messageToSeller'],
      storeId: map['storeId'],
      timeStamp: map['timestamp'],
      totalPrice: double.parse(map['total'].toString()),
      forApproval: map['forApproval'],
      productList: (map['products'] as List<dynamic>)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList(),
    );
  }

  factory CheckoutProductDto.fromJson(Map<String, dynamic> json) =>
      _$CheckoutProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutProductDtoToJson(this);
}
