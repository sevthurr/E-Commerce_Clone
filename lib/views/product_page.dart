import '../models/product_model.dart';
import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'checkout_page.dart';
import 'orders_page.dart';
import '../models/order_model.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int selectedIndex = 0;
  int currentNavIndex = 0;
  Set<Product> favoriteProducts = {};
  List<CartItem> cartItems = [];
  List<Order> orders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task 8 - Mayugba"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  setState(() {
                    currentNavIndex = 2;
                  });
                },
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '${cartItems.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: currentNavIndex == 0
            ? _buildHome()
            : currentNavIndex == 1
                ? _buildFavorites()
                : currentNavIndex == 2
                    ? _buildCart()
                    : _buildOrders(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentNavIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            currentNavIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Orders"),
        ],
      ),
    );
  }

Widget _buildHome() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Our Products",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _categoryButton("All Products", 0),
          _categoryButton("Jackets", 1),
          _categoryButton("Sneakers", 2),
        ],
      ),

      const SizedBox(height: 15),
      Expanded(child: _buildProductGrid()),
    ],
  );
}

Widget _buildProductGrid() {
  List<Product> displayProducts;

  if (selectedIndex == 0) {
    displayProducts = products;
  } else if (selectedIndex == 1) {
    displayProducts =
        products.where((product) => product.category == 'Jackets').toList();
  } else {
    displayProducts =
        products.where((product) => product.category == 'Sneakers').toList();
  }

  return GridView.builder(
    itemCount: displayProducts.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.7,
    ),
    itemBuilder: (context, index) {
      final product = displayProducts[index];
      return _buildProductCard(product);
    },
  );
} 

Widget _categoryButton(String title, int index) {
  return ElevatedButton(
    onPressed: () => setState(() => selectedIndex = index),
    style: ElevatedButton.styleFrom(
      backgroundColor: selectedIndex == index ? Colors.red : Colors.grey[200],
      foregroundColor: selectedIndex == index ? Colors.white : Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    child: Text(title),
  );
}

Widget _buildFavorites() {
  if (favoriteProducts.isEmpty) {
    return const Center(
      child: Text("No favorite products yet."),
    );
  }

  return GridView.builder(
    itemCount: favoriteProducts.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.7,
    ),
    itemBuilder: (context, index) {
      final product = favoriteProducts.elementAt(index);
      return _buildProductCard(product);
    },
  );
}

Widget _buildCart() {
  return CartPage(
    cartItems: cartItems,
    onRemoveItem: (cartItem) {
      setState(() {
        cartItems.remove(cartItem);
      });
    },
    onUpdateQuantity: (cartItem, newQuantity) {
      setState(() {
        cartItem.quantity = newQuantity;
      });
    },
    onCheckout: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutPage(
            cartItems: cartItems,
            onConfirmOrder: (order) {
              setState(() {
                orders.add(order);
                cartItems.clear();
              });
            },
          ),
        ),
      );
    },
  );
}

Widget _buildOrders() {
  return OrdersPage(orders: orders);
}
Widget _buildProductCard(Product product) {
  final isFavorited = favoriteProducts.contains(product);

  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                isFavorited ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  if (isFavorited) {
                    favoriteProducts.remove(product);
                  } else {
                    favoriteProducts.add(product);
                  }
                });
              },
            ),
          ),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1.2,
                child: Image.asset(
                  product.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            product.status,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '₱${product.price}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onPressed: () {
                setState(() {
                  final existingItem = cartItems.firstWhere(
                    (item) => item.product == product,
                    orElse: () => CartItem(product: product),
                  );
                  
                  if (cartItems.contains(existingItem)) {
                    existingItem.quantity++;
                  } else {
                    cartItems.add(existingItem);
                  }
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} added to cart!'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                'Add to Cart',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}