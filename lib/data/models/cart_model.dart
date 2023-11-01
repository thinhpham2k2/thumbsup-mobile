import 'package:equatable/equatable.dart';
import 'package:my_app/data/models/product_model.dart';

class Cart extends Equatable {
  List<ProductModel> products;
  Cart({required this.products});

  Map productQuantity(products) {
    var quantity = Map();

    products.forEach((product) {
      if (!quantity.containsKey(product)) {
        quantity[product] = 1;
        (product as ProductModel).quantity = quantity[product];
      } else {
        quantity[product] += 1;
        (product as ProductModel).quantity = quantity[product];
      }
    });
    return quantity;
  }

  Map productStore(products) {
    Map<String?, List<ProductModel>> filterStore = Map();

    products.forEach((product) {
      List<ProductModel> listItem = [];
      if (!filterStore.containsKey(product.storeName)) {
        listItem.add(product);
        filterStore[product.storeName] = listItem;
        listItem = [];
      } else {
        filterStore.forEach((key, value) {
          if (product.storeName!.contains(key!)) {
            value.add(product);
          }
        });
      }
    });
    return filterStore;
  }

  double get subTotal =>
      products.fold(0, (total, current) => total + current.salePrice);

  double deliveryFree = 0;
  double tax = 0;
  double total(subtotal, deliverFree, tax) {
    return subtotal + deliveryFree + tax;
  }

  String get subTotalString => subTotal.toStringAsFixed(2);

  @override
  List<Object?> get props => [products, deliveryFree, tax];
}
