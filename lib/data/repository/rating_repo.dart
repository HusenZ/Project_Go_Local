import 'package:cloud_firestore/cloud_firestore.dart';

class RatingRepo {
  static Future<String> getProductsAvgRating(String productId) async {
    try {
      var productDoc = await FirebaseFirestore.instance
          .collection('Products')
          .where('productId', isEqualTo: productId)
          .get()
          .then(
        (querySnaps) {
          var doc = querySnaps.docs[0];

          return doc.id;
        },
      );
      final reviews = await FirebaseFirestore.instance
          .collection('Products')
          .doc(productDoc)
          .collection('Reviews')
          .get();
      double totalRating = 0.0;
      int ratingCount = 0;

      for (final review in reviews.docs) {
        final rating = review.get('rating');
        if (rating != null) {
          totalRating += rating;
          ratingCount++;
        }
      }
      if (ratingCount > 0) {
        return (totalRating / (ratingCount)).toString();
      } else {
        return '0.0';
      }
    } catch (error) {
      return ' 0.0';
    }
  }

  static Future<String> getShopRating(String shopId) async {
    try {
      var productDoc = await FirebaseFirestore.instance
          .collection('Products')
          .where('shopId', isEqualTo: shopId)
          .get()
          .then(
        (querySnaps) {
          var doc = querySnaps.docs[0];
          return doc.id;
        },
      );
      final reviews = await FirebaseFirestore.instance
          .collection('Products')
          .doc(productDoc)
          .collection('Reviews')
          .get();
      double totalRating = 0.0;
      int ratingCount = 0;

      for (final review in reviews.docs) {
        final rating = review.get('rating');
        if (rating != null) {
          totalRating += rating;
          ratingCount++;
        }
      }
      if (ratingCount > 0) {
        return (totalRating / (ratingCount)).toString();
      } else {
        return '0.0';
      }
    } catch (error) {
      return ' 0.0';
    }
  }
}
