# storekit2

A new Flutter plugin project.

## Getting Started

This project is IOS Storekit 2 implementation.

## USAGE

``` dart

  // get products
    var products = await Storekit2Helper.fetchProducts(
        ["app_weekly", "app_yearly", "app_lifetime"]);

    for (var p in products) {
      print(p.productId +
          " - " +
          p.periodUnit +
          " " +
          p.periodValue.toString() +
          " " +
          p.type);
    }

    // check user has active subscription
    var hasActiveSubscription = await Storekit2Helper.hasActiveSubscription();

    // Buy product by product id
    Storekit2Helper.buyProduct("app_weekly",
        (success, transaction, errorMessage) {
      print(success);
      print(errorMessage);
      print(transaction);
    });


```

 


 

