import Flutter
import UIKit
import StoreKit

 

public class Storekit2Plugin: NSObject, FlutterPlugin {
    
    let periodTitles = [
        "Day": "Weekly",
        "Week": "Weekly",
        "Month": "Monthly",
        "Year": "Yearly"
    ]

    
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "storekit2helper", binaryMessenger: registrar.messenger())
    let instance = Storekit2Plugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

     
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        
    case "initialize":
        Task{
            
            await result(StoreKit2Handler.initialize())
        }
  
        
    case "fetchPurchaseHistory":
        Task{
            await result(StoreKit2Handler.fetchPurchaseHistory())
        }
      
        
    case "hasActiveSubscription":
          Task {
              let hasSubscription =  await StoreKit2Handler.hasActiveSubscription()
              result(hasSubscription)
          }
        
        
    case "fetchProducts":
        if let args = call.arguments as? [String: Any], let productIDs = args["productIDs"] as? [String] {
           
            StoreKit2Handler.fetchProducts(productIdentifiers: productIDs) { fetchResult in
                switch fetchResult {
                case .success(let products):
                    // Convert products to a format that can be sent back to Flutter
                 let productDetails = products.map { product -> [String: Any] in
    
                     var data = [
                      "productId": product.id,
                      "title": product.displayName,
                      "description": product.description,
                      "price": product.price,
                      "periodUnit": String(describing: product.subscription?.subscriptionPeriod.unit ?? Product.SubscriptionPeriod.Unit.day)  ,
                      "periodValue": product.subscription?.subscriptionPeriod.value ?? 0,
                      "periodTitle": "",
                      "json":  String(data:  product.jsonRepresentation, encoding: .utf8) ?? "",
                      "localizedPrice": product.displayPrice,
                      "type": String(describing: product.type.rawValue),
                      "introductoryOffer": String(describing: product.subscription?.introductoryOffer?.paymentMode.rawValue ?? "") ,
                      
                      "introductoryOfferPeriod":  String(describing: product.subscription?.introductoryOffer?.period.debugDescription ?? "") ,
                      "isTrial": false
                  ]
                      
                     
                 if let periodTitle = self.periodTitles[data["periodUnit"] as! String]{
                     data["periodTitle"] = periodTitle
                 }
                 if(data["introductoryOffer"] as! String != ""){
                     data["isTrial"] = true
                 }
                     
                     
                     return data
              }

                    result(productDetails)
                case .failure(let error):
                    result(FlutterError(code: "PRODUCT_FETCH_ERROR", message: error.localizedDescription, details: nil))
                }
            }
        } else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing productIDs", details: nil))
        }

    case "buyProduct":
        if let args = call.arguments as? [String: Any], let productId = args["productId"] as? String {
         
            StoreKit2Handler.buyProduct(productId: productId) { success, error, transaction in
                
                
                if success {
                    // Assuming transaction is not nil if success is true
                    let transactionDetails : [String:Any] = [
                        "transactionId": transaction!.id,
                        "productId": transaction!.productID,
                        "appBundleID": transaction!.appBundleID,
                        "purchaseDate": Int(transaction!.purchaseDate.timeIntervalSince1970),
                        "json":  String(data:  transaction!.jsonRepresentation, encoding: .utf8) ?? "",
                         
                    ]
                    
                  
                    result(transactionDetails)
                } else   {
                 
                   let errorCode = "PURCHASE_ERROR"
                    let   errorMessage = error?.localizedDescription ?? "error"
                    
                    result(FlutterError(code: errorCode, message: errorMessage, details: nil))
                }
            }
        } else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing productId", details: nil))
        }

    default:
        result(FlutterMethodNotImplemented)
    }
}

}
