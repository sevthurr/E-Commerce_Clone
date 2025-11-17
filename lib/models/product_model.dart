class Product {
  final String name;
  final String price;
  final String status;
  final String image;
  final String category;

  Product({
    required this.name,
    required this.price,
    required this.status,
    required this.image,
    required this.category,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => double.parse(product.price) * quantity;
}
final List<Product> products = [
  Product(
    name: 'ON Cloudmonster 2',
    price: '12000.0',
    status: 'Trending Now',
    image: 'assets/images/shoes1.jpg',
    category: 'Sneakers',
  ),
  Product(
    name: 'New Balance 530',
    price: '10000.0',
    status: 'Out of Stock',
    image: 'assets/images/shoes2.jpg',
    category: 'Sneakers',
  ),
  Product(
    name: 'Rebook Jacket',
    price: '3000.0',
    status: 'Trending Now',
    image: 'assets/images/jacket1.jpg',
    category: 'Jackets',
  ),
  Product(
    name: 'PUMA Jacket',
    price: '4500.0',
    status: 'Out of Stock',
    image: 'assets/images/jacket2.jpg',
    category: 'Jackets',
  ),
];
