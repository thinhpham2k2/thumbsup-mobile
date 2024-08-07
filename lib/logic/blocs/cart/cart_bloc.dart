import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_app/data/models/cart_model.dart';
import 'package:my_app/data/models/product_model.dart';
import 'package:my_app/data/repositories/local_storage_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final LocalStorageRepository localStorageRepository;
  CartBloc({required this.localStorageRepository}) : super(CartLoading()) {
    on<LoadCartEvent>(_onCartStarted);
    on<RefreshCartEvent>(_onCartRefresh);
    on<AddProductEvent>(_onCartProductAdded);
    on<RemoveProductEvent>(_onCartProductRemoved);
    on<RemoveAllProduct>(_onRemoveAllProduct);
    on<LoadCartAfterPaymentEvent>(_onLoadCartAfterPaymentProduct);
  }

  Future<void> _onCartStarted(
      LoadCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      Box box = await localStorageRepository.openBox();
      List<ProductModel> products = localStorageRepository.getCart(box);
      await Future<void>.delayed(const Duration(seconds: 1));
      emit(CartLoaded(cart: Cart(products: products)));
    } catch (_) {
      emit(CartError());
    }
  }

  Future<void> _onCartRefresh(
      RefreshCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      Box box = await localStorageRepository.openBox();
      localStorageRepository.clearCart(box);
      await Future<void>.delayed(const Duration(seconds: 1));
      emit(CartLoaded(cart: Cart(products: [])));
    } catch (_) {
      emit(CartError());
    }
  }

  Future<void> _onCartProductAdded(
      AddProductEvent event, Emitter<CartState> emit) async {
    final state = this.state;
    if (state is CartLoaded) {
      try {
        Box box = await localStorageRepository.openBox();
        localStorageRepository.addProductToCart(box, event.product);
        emit(
          CartLoaded(
              cart: state.cart.copyWith(
                  products: List.from(state.cart.products)
                    ..add(event.product))),
        );
      } on Exception {
        emit(CartError());
      }
    }
  }

  Future<void> _onCartProductRemoved(
      RemoveProductEvent event, Emitter<CartState> emit) async {
    final state = this.state;
    if (state is CartLoaded) {
      try {
        Box box = await localStorageRepository.openBox();
        localStorageRepository.removeProductFromCart(box, event.product);
        emit(
          CartLoaded(
            cart: state.cart.copyWith(
              products: List.from(state.cart.products)..remove(event.product)
            )
          ),
        );
      } on Exception {
        emit(CartError());
      }
    }
  }

  Future<void> _onRemoveAllProduct(
    RemoveAllProduct event,
    Emitter<CartState> emit,
  ) async {
    final state = this.state;

    if (state is CartLoaded) {
      try {
        Box box = await localStorageRepository.openBox();
        localStorageRepository.removeProductFromCart(box, event.product);
        emit(
          CartLoaded(
            cart: state.cart.copyWith(
              products: List.from(state.cart.products)
                ..removeWhere((product) => product == event.product),
            ),
          ),
        );
      } catch (_) {}
    }
  }

  Future<void> _onLoadCartAfterPaymentProduct(
    LoadCartAfterPaymentEvent event,
    Emitter<CartState> emit,
  ) async {
    final state = this.state;

    if (state is CartLoaded) {
      try {
        Box box = await localStorageRepository.openBox();
        localStorageRepository.clearCart(box);
        emit(CartLoading());
      } catch (_) {}
    }
  }
}
