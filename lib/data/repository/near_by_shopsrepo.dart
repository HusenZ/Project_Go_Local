import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gozip/domain/entities/product.dart';
import 'package:gozip/domain/entities/category.dart';
import 'package:gozip/domain/entities/shop_model.dart';

class FirebaseLocation {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Shop>> getNearbyShops(String? userLocality) async {
    try {
      // Query all shops
      QuerySnapshot querySnapshot = await _firestore.collection('Shops').get();

      // Convert query snapshot to list of shops
      List<Shop> allShops = querySnapshot.docs.map((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Shop(
            cid: data['id'],
            openTime: data['openTime'],
            closeTime: data['closeTime'],
            deliveryAvailable: data['delivery'],
            location: data['location'],
            shopName: data['name'],
            shopLogoPath: data['shopLogo'],
            shopBannerPath: data['shopImage'],
            address: data['location']);
      }).toList();

      // Filter shops based on locality match
      List<Shop> nearbyShops = allShops
          .where((shop) => shop.location.contains(userLocality!))
          .toList();

      return nearbyShops;
    } catch (e) {
      return [];
    }
  }

  Future<List<Product>> getProductsForShop(String shopId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Products')
          .where('shopId', isEqualTo: shopId)
          .get();

      // Convert query snapshot to list of products
      List<Product> products = querySnapshot.docs.map((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Product(
            name: data['name'],
            price: data['price'],
            details: data['description'],
            imageUrl: data['selectedPhotos'],
            category: mapCategory[data['category']] ?? Category.men,
            shopId: data['shopId'],
            productId: data['productId'],
            discountedPrice: data['discountedPrice']);
      }).toList();

      return products;
    } catch (e) {
      return [];
    }
  }
}
