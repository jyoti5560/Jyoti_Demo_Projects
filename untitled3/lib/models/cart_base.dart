import 'package:untitled3/models/cart_mixin.dart';
import 'package:untitled3/models/currency_mixin.dart';

abstract class CartModel
    with
        CartMixin,
        CurrencyMixin{
  @override
  double getSubTotal();

  // double getItemTotal(
  //     {ProductVariation productVariation, Product product, int quantity = 1});

  double getTotal();

 // String updateQuantity(Product product, String key, int quantity, {context});

  void removeItemFromCart(String key);

  @override
 // Product getProductById(String id);

  @override
 // ProductVariation getProductVariationById(String key);

  void clearCart();

  void setOrderNotes(String note);

  void initData();

  @override
  String addProductToCart({
    context,
   // Product product,
    int quantity = 1,
   // ProductVariation variation,
    Function notify,
    isSaveLocal = true,
    Map<String, dynamic> options,
  });

  void setRewardTotal(double total);

  @override
  void loadSavedCoupon();
}