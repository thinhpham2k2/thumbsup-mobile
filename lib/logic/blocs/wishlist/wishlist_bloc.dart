import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:my_app/data/models/wish_list_model.dart';
import 'package:my_app/data/repositories/wishlist_product_repository.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishListBloc extends Bloc<WishListEvent, WishListState> {
  final WishListRepository _wishListRepository;
  WishListBloc(this._wishListRepository) : super(WishListLoadingState()) {
    on<StartWishListEvent>(_onStartWishList);
    on<AddWishListProductEvent>(_onAddWishList);
    // on<RemoveWishListProductEvent>(_onRemoveWishList());
  }

  Future<void> _onStartWishList(
      StartWishListEvent event, Emitter<WishListState> emit) async {
    emit(WishListLoadingState());
    try {
      final wishListProducts = await _wishListRepository.getWishListProducts();
      emit(WishListLoadedState(wishLists: wishListProducts));
    } catch (e) {
      emit(WishListErrorState(e.toString()));
    }
  }

  Future<void> _onAddWishList(
      AddWishListProductEvent event, Emitter<WishListState> emit) async {
    try {
      bool result = await _wishListRepository.createWishListProduct(
          event.customerId, event.productId);
      final wishListProducts = await _wishListRepository.getWishListProducts();
      if (result) {
        emit(WishListLoadedState(wishLists: wishListProducts));
      } else {
        emit(WishListErrorState('Thêm thất bại'));
      }
    } catch (e) {
      emit(WishListErrorState(e.toString()));
    }
  }
}
