import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gozip/bloc/wish_list_bloc/wish_list_state.dart';
import 'package:gozip/domain/entities/product.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class AddProductEvent extends WishlistEvent {
  final Product product;

  AddProductEvent({required this.product});
  @override
  List<Object?> get props => [product];
}

class RemoveProductEvent extends WishlistEvent {
  final Product product;

  RemoveProductEvent({required this.product});
}

/////

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  WishlistBloc() : super(const WishlistState()) {
    on<AddProductEvent>((event, emit) async {
      try {
        emit(WishListLoading());
        final docRef = FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('WishList')
            .doc('ids');

        final snapshot = await docRef.get();

        if (snapshot.exists) {
          final productIdList =
              (snapshot.data()!['productIds'] as List<dynamic>?) ?? [];
          if (productIdList.contains(event.product.productId)) {
            emit(ItemExists());
          }
        } else {
          // Add product ID to wishlist

          await docRef.update({
            'productIds': FieldValue.arrayUnion([event.product.productId]),
          });
          emit(WishListSuccess());
        }
      } catch (e) {
        emit(WishListFailure());
      }
    });

    on<RemoveProductEvent>((event, emit) async {
      emit(WishListLoading());
      try {
        await _removeFromWishlist(event.product);
      } catch (e) {
        emit(WishListFailure());
      } finally {}
    });
  }

  // Future<String?> _addToWishlist(Product product) async {
  //   // Check if product ID already exists in wishlist efficiently
  //   final docRef = FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(userId)
  //       .collection('WishList')
  //       .doc('ids');

  //   final snapshot = await docRef.get();

  //   if (snapshot.exists) {
  //     final productIdList =
  //         (snapshot.data()!['productIds'] as List<dynamic>?) ?? [];
  //     if (productIdList.contains(product.productId)) {
  //       print(
  //           'Product with ID ${product.productId} already exists in wishlist.');
  //       return "Exists";
  //     }
  //   }

  //   // Add product ID to wishlist
  //   await docRef.update({
  //     'productIds': FieldValue.arrayUnion([product.productId]),
  //   });
  //   return 'Added';
  // }

  Future<void> _removeFromWishlist(Product product) async {
    final docRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('WishList')
        .doc('ids');

    try {
      // Update wishlist with FieldValue.arrayRemove
      await docRef.update({
        'productIds': FieldValue.arrayRemove([product.productId]),
      });
    } on FirebaseException catch (e) {}
  }
}
