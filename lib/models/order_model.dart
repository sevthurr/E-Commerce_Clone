import 'product_model.dart';

class Order {
  final String orderId;
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final String firstName;
  final String lastName;
  final String email;
  final String address;
  final String city;
  final String zipCode;
  final String paymentMethod;
  final DateTime orderDate;

  Order({
    required this.orderId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.city,
    required this.zipCode,
    required this.paymentMethod,
    required this.orderDate,
  });
}
