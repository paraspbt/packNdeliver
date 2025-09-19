// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Order {
  final String status;
  final String orderNo;
  final String salesId;
  final String value;
  final String custName;
  final String phone;
  final String address;
  Order({
    required this.status,
    required this.orderNo,
    required this.salesId,
    required this.value,
    required this.custName,
    required this.phone,
    required this.address,
  });

  Order copyWith({
    String? status,
    String? orderNo,
    String? salesId,
    String? value,
    String? custName,
    String? phone,
    String? address,
  }) {
    return Order(
      status: status ?? this.status,
      orderNo: orderNo ?? this.orderNo,
      salesId: salesId ?? this.salesId,
      value: value ?? this.value,
      custName: custName ?? this.custName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'orderNo': orderNo,
      'salesId': salesId,
      'value': value,
      'custName': custName,
      'phone': phone,
      'address': address,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      status: map['status'] as String,
      orderNo: map['orderNo'] as String,
      salesId: map['salesId'].toString(),
      value: map['total'].toString(),
      custName: '${map['firstName']} ${map['lastName']}',
      phone: map['mobNo'] as String,
      address: '${map['shippingAddressLine1']}\n${map['shippingAddressLine2']}'
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .join('\n'),
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Order(status: $status, orderNo: $orderNo, salesId: $salesId, value: $value, custName: $custName, phone: $phone, address: $address)';
  }

  @override
  bool operator ==(covariant Order other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.orderNo == orderNo &&
        other.salesId == salesId &&
        other.value == value &&
        other.custName == custName &&
        other.phone == phone &&
        other.address == address;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        orderNo.hashCode ^
        salesId.hashCode ^
        value.hashCode ^
        custName.hashCode ^
        phone.hashCode ^
        address.hashCode;
  }
}
