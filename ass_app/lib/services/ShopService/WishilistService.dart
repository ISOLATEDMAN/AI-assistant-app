// services/WishlistService.dart
import 'package:ass_app/models/ProductModel.dart';

class WishlistService {
  static WishlistService? _instance;
  static List<ProductModel> _wishlistProducts = [];
  
  WishlistService._internal();
  
  factory WishlistService() {
    _instance ??= WishlistService._internal();
    return _instance!;
  }

  // Get all wishlist products
  List<ProductModel> getWishlistProducts() {
    return List.from(_wishlistProducts);
  }

  // Add product to wishlist
  bool addToWishlist(ProductModel product) {
    // Check if product already exists
    if (_wishlistProducts.any((p) => p.id == product.id)) {
      return false; // Product already in wishlist
    }
    
    _wishlistProducts.add(product);
    return true;
  }

  // Remove product from wishlist
  bool removeFromWishlist(int productId) {
    final initialLength = _wishlistProducts.length;
    _wishlistProducts.removeWhere((p) => p.id == productId);
    return _wishlistProducts.length < initialLength;
  }

  // Check if product is in wishlist
  bool isInWishlist(int productId) {
    return _wishlistProducts.any((p) => p.id == productId);
  }

  // Clear entire wishlist
  void clearWishlist() {
    _wishlistProducts.clear();
  }

  // Get wishlist count
  int getWishlistCount() {
    return _wishlistProducts.length;
  }
}