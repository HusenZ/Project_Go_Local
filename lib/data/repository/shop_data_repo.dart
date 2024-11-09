import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gozip/domain/entities/shop_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductStream {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> fetchShopName(String shopId) {
    return FirebaseFirestore.instance
        .collection('Shops')
        .doc(shopId)
        .snapshots();
  }

  Stream<QuerySnapshot> getProductStream() {
    return _firestore
        .collection('Products')
        .where('location', isEqualTo: 'Bagalkot')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProductsForShopsStream(
      String locality) {
    print("The locality on the stream ---> $locality");
    return _firestore
        .collection('Products')
        .where('location', arrayContains: locality)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getShopProductStream(
      String shopId) {
    return _firestore
        .collection('Products')
        .where('shopId', isEqualTo: shopId)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getShopStream(String uid) {
    return _firestore.collection('Shops').doc(uid).snapshots();
  }

  Stream<QuerySnapshot> getCartItems() {
    return _firestore
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Cart')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> orderItems() {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('orderDate', descending: false)
        .snapshots();
  }

  Stream<List<Shop>> getShopsStream() {
    // Replace 'shops' with your actual collection name in Firestore
    return FirebaseFirestore.instance.collection('Shops').snapshots().map(
      (querySnapshot) {
        final shops =
            querySnapshot.docs.map((doc) => Shop.fromFirestore(doc)).toList();
        return shops;
      },
    );
  }

  Stream<List<Shop>> getNearbyShops(String? userLocality) {
    String trimmedLocality = userLocality!.trim();
    if (trimmedLocality == 'Belgaum' ||
        trimmedLocality == 'Belgaum(Belagavi)' ||
        trimmedLocality == 'Belagavi(Belgaum)') {
      trimmedLocality = 'Belagavi';
    }
    return FirebaseFirestore.instance
        .collection('Shops')
        .where('applicationStatus', isEqualTo: 'verified')
        .snapshots()
        .map(
      (querySnapshot) {
        final shops = querySnapshot.docs
            .map((doc) => Shop.fromFirestore(doc))
            .where((shop) =>
                shop.location.toLowerCase() == trimmedLocality.toLowerCase())
            .toList();

        return shops;
      },
    );
  }
}
