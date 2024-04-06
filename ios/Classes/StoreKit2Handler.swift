import StoreKit



class StoreKit2Handler {
    static func fetchProducts(productIdentifiers: [String], completion: @escaping (Result<[Product], Error>) -> Void) {
        Task {
            do {
                
                let allProducts = try await Product.products(for: productIdentifiers)
                 
                let sortedProducts = productIdentifiers.compactMap { identifier in
                    allProducts.first(where: { $0.id == identifier })
                }
              
                completion(.success(sortedProducts))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    static  func hasActiveSubscription() async -> Bool {
        
        for await verificationResult in Transaction.currentEntitlements {
            switch verificationResult {
                
            case .verified(_):
                return true
                
            case .unverified(_, _): break
                
            }
        }
        return false
    }
    
    static func buyProduct(productId productID: String, completion: @escaping (Bool, Error?, Transaction?) -> Void) {
        Task {
            do {
                // Fetch the products
                let products = try await Product.products(for: [productID])
                guard let product = products.first else {
                    // Handle the case where the product is not found
                    completion(false, NSError(domain: "StoreKitError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Product not found"]),nil)
                    return
                }
                
                print(products.count)
                
                // Attempt to purchase the product
                let result = try await product.purchase()
                
                
                switch result {
                case .success(let verification):
                    switch verification {
                    case .verified(let transaction ):
                       
                        await transaction.finish()
                        
                        // Call completion handler indicating success
                        completion(true, nil,  transaction )
                    case .unverified:
                        // Handle unverified transaction
                        completion(false, NSError(domain: "StoreKitError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Transaction unverified"]),nil)
                    }
                case .pending:
                    // Handle pending state if needed
                    break
                case .userCancelled:
                    // User cancelled the purchase
                    
                    completion(false, NSError(domain: "StoreKitError", code: -3, userInfo: [NSLocalizedDescriptionKey: "User cancelled"]),nil)
                @unknown default:
                    // Handle unexpected cases
                    completion(false, NSError(domain: "StoreKitError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Unknown purchase result"]),nil)
                }
                
            } catch {
                
                completion(false, error,nil)
            }
        }
    }
    
}
