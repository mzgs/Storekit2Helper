
# StoreKit2 Plugin Documentation

The `StoreKit2Plugin` is a Flutter plugin for handling in-app purchases and subscriptions using Apple's StoreKit 2 API. It supports initializing transactions, fetching products, making purchases, checking subscriptions, and retrieving purchase history.

## Installation

1. Add the dependency to your `pubspec.yaml` file:
   ```yaml
   dependencies:
     storekit2helper:
    
   ```

2. Import the plugin:
   ```dart
   import 'package:storekit2helper/storekit2helper.dart';
   ```

## Usage

### Initialize
Initialize transaction updates:
```dart
  Storekit2Helper.initialize();
```

### Fetch Products
Fetch available products:
```dart
final products = await Storekit2Helper.fetchProducts(productIDs: ["com.example.product1", "com.example.product2"]);
```

### Purchase Product
Purchase a product:
```dart
  Storekit2Helper.buyProduct(productID:"app_weekly",
        (success, transaction, errorMessage) {
      print(success);
      print(errorMessage);
      print(transaction);
    });

```

### Check Active Subscription
Check if the user has an active subscription:
```dart
final hasActiveSubscription = await Storekit2Helper.hasActiveSubscription();
```

### Fetch Purchase History
Retrieve purchase history:
```dart
final purchaseHistory = await Storekit2Helper.fetchPurchaseHistory();
```

## Example

```dart
import 'package:flutter/material.dart';
import 'package:storekit2helper/storekit2helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    Storekit2Helper.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StoreKitExample(),
    );
  }
}

class StoreKitExample extends StatefulWidget {
  @override
  State<StoreKitExample> createState() => _StoreKitExampleState();
}

class _StoreKitExampleState extends State<StoreKitExample> {
  List<dynamic> products = [];
  bool hasActiveSubscription = false;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    checkSubscription();
  }

  Future<void> fetchProducts() async {
    final productIDs = ["com.example.product1", "com.example.product2"];
    final fetchedProducts = await Storekit2Helper.fetchProducts(productIDs: productIDs);
    setState(() {
      products = fetchedProducts;
    });
  }

  Future<void> checkSubscription() async {
    final isActive = await Storekit2Helper.hasActiveSubscription();
    setState(() {
      hasActiveSubscription = isActive;
    });
  }

  Future<void> purchaseProduct(String productId) async {
    try {
     

  Storekit2Helper.buyProduct(productId,
        (success, transaction, errorMessage) {
      print(success);
      print(errorMessage);
      print(transaction);
    });


    } catch (e) {
      print("Purchase Failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("StoreKit2 Example")),
      body: Column(
        children: [
          Text("Active Subscription: $hasActiveSubscription"),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product['title']),
                  subtitle: Text(product['localizedPrice']),
                  onTap: () => purchaseProduct(product['productId']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

## Notes
- Ensure your `productIDs` match those configured in App Store Connect.
- Handle errors gracefully to provide a seamless experience.
- This plugin requires iOS 15.0 or later.
