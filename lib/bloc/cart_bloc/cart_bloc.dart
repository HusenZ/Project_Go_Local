import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:gozip/domain/entities/product.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  CartBloc() : super(CartInitial()) {
    on<AddToCart>(_addToCart);
    on<RemoveFromCart>(_removeFromCart);
  }

  // ... event handlers ...

  Future<void> _addToCart(AddToCart event, Emitter<CartState> emit) async {
    String itemId = _uuid.v4();
    try {
      emit(CartLoading());
      await _firestore
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Cart')
          .doc(itemId)
          .set({
        'name': event.product.name,
        'price': event.product.price,
        'shopId': event.product.shopId,
        'description': event.product.details,
        'category': event.product.category!.name,
        'image': event.product.imageUrl,
        'productId': event.product.productId,
        'discountedPrice': event.product.discountedPrice,
        'cartItemId': itemId,
      });
    } catch (error) {
      emit(CartError(message: error.toString()));
    }
  }

  Future<void> _removeFromCart(
      RemoveFromCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      _firestore
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Cart')
          .doc(event.cartItemId)
          .delete();
      emit(CartRemoveSuccessState()); // Update UI
    } catch (error) {
      emit(CartError(message: error.toString()));
    }
  }
}
