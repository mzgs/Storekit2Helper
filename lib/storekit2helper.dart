import 'package:flutter/services.dart';

class Storekit2Helper {
  static const MethodChannel _channel = MethodChannel('storekit2helper');

  static Future<List<ProductDetail>> fetchProducts(
      List<String> productIDs) async {
    final List<dynamic> productList = await _channel
        .invokeMethod('fetchProducts', {"productIDs": productIDs});

    List<ProductDetail> products = [];
    for (var product in productList) {
      products.add(ProductDetail(
        description: product['description'],
        productId: product['productId'],
        title: product['title'],
        price: product['price'],
        localizedPrice: product['localizedPrice'],
        type: product['type'],
        json: product['json'],
        periodUnit: product['periodUnit'],
        periodValue: product['periodValue'],
        periodTitle: product['periodTitle'],
        introductoryOffer: product['introductoryOffer'],
        introductoryOfferPeriod: product['introductoryOfferPeriod'],
        isTrial: product['isTrial'],
      ));
    }
    return products;
  }

  static Future<void> buyProduct(
    String productId,
    void Function(bool success, Map<String, dynamic>? transaction,
            String? errorMessage)
        onResult,
  ) async {
    try {
      final dynamic result =
          await _channel.invokeMethod('buyProduct', {'productId': productId});
      // Explicitly cast the result to Map<String, dynamic>
      final Map<String, dynamic>? resultMap = Map<String, dynamic>.from(result);
      // If successful, invoke the callback with success=true, the casted result, and no error message.
      onResult(true, resultMap, null);
    } on PlatformException catch (e) {
      // If there's a platform exception, invoke the callback with success=false, no transaction, and the error message.
      onResult(false, null, e.message);
    } catch (e) {
      // For any other type of error, invoke the callback with success=false, no transaction, and a generic error message.
      onResult(false, null, 'An unexpected error occurred. $e');
    }
  }

  static Future<bool> hasActiveSubscription() async {
    final bool hasSubscription =
        await _channel.invokeMethod('hasActiveSubscription');
    return hasSubscription;
  }
}

class ProductDetail {
  final String productId;
  final String title;
  final String description;
  final double price;
  final String localizedPrice;
  final String type;
  final String json;
  final String periodUnit;
  final int periodValue;
  final String periodTitle;
  final String introductoryOffer;
  final String introductoryOfferPeriod;
  final bool isTrial;

  ProductDetail(
      {required this.productId,
      required this.title,
      required this.description,
      required this.price,
      required this.localizedPrice,
      required this.type,
      required this.json,
      required this.periodUnit,
      required this.periodValue,
      required this.periodTitle,
      required this.introductoryOffer,
      required this.introductoryOfferPeriod,
      required this.isTrial});
}
