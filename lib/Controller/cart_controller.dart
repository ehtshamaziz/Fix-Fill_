import 'package:fix_fill/admin/station_maps.dart';
import 'package:get/get.dart';

import '../model/CartData.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();
  final Cart cart = Cart();
  Map<String, List<CartItem>> cartItemsByStation = {};
  Map<String, List<CartItem>> groupedItems = {};
  RxBool reloadFlag = false.obs;

  List<CartItem> get items => cart.items;
  double get totalPrice => cart.totalPrice;
  void reloadOtherScreen() {
    reloadFlag.toggle();

  }
  void addItem(CartItem item) {
    cart.addItem(item);
    reloadOtherScreen();
    groupCartItems();
    update(); // Notify listeners for updates
  }
  void removeStationItems(String stationId) {
    items.removeWhere((item) => item.shopID == stationId);
    reloadOtherScreen();
    groupCartItems(); // Regroup items after removal
    update();
  }

  void groupCartItems() {
    groupedItems.clear(); // Clear existing items before regrouping

    for (var item in CartController.instance.items) {
      if (!groupedItems.containsKey(item.shopID)) {
        groupedItems[item.shopID] = [];
        update();
      }
      groupedItems[item.shopID]!.add(item);
      update();
    }

  }

  void removeItem(String itemId) {
    cart.removeItem(itemId);
    update(); // Notify listeners for updates
  }

  void updateItemQuantity(String itemId, int quantity) {

    cart.updateItemQuantity(itemId, quantity);
    update(); // Notify listeners for updates
  }

}
