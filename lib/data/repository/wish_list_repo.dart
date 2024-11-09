import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishListRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  Future<Map<String, dynamic>?> getProducDetails(String productId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Products')
          .where('productId', isEqualTo: productId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final productDoc = querySnapshot.docs.first;
      return productDoc.data();
    } catch (error) {
      return null;
    }
  }

  Future<void> addToWishList(String productId) async {
    final userDocRef = _firestore.collection('Users').doc(userId);
    final wishListRef = userDocRef.collection('wish_list').doc(productId);

    // Check if product already exists (optional)
    final snapshot = await wishListRef.get();
    if (snapshot.exists) {
      return; // Product already exists
    }

    await wishListRef.set({
      'product_data': await getProducDetails(productId),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getWishListProducts() {
    final userDocRef =
        FirebaseFirestore.instance.collection('Users').doc(userId);
    final wishListRef = userDocRef.collection('wish_list').snapshots();

    return wishListRef;
  }

  Future<void> removeFromWishList(String productId) async {
    final userDocRef =
        FirebaseFirestore.instance.collection('Users').doc(userId);
    final wishListRef = userDocRef.collection('wish_list').doc(productId);

    await wishListRef.delete();
  }

  Stream<bool> isProductWishlisted(String productId) {
    final userDocRef = _firestore.collection('Users').doc(userId);
    final wishListRef = userDocRef.collection('wish_list').doc(productId);

    return wishListRef.snapshots().map((snapshot) => snapshot.exists);
  }
}
