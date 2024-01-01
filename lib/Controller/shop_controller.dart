import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_fill/Repository/Shop_Repository/shop_repository.dart';
import 'package:fix_fill/model/ListItemModel.dart';
import 'package:fix_fill/model/ListStationAdminModel.dart';
import 'package:fix_fill/model/ListedRiderModal.dart';
import 'package:fix_fill/model/ListedUsersModel.dart';
import 'package:fix_fill/model/notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/ListUpdateModel.dart';
import '../model/ListedStationModel.dart';


class ShopController extends GetxController{
  // final stationName= TextEditingController();
  // final price= TextEditingController();
  // final quantity= TextEditingController();
  // final SideService service = SideService();

  // List<Service> get items => service.items;
  static ShopController get instance => Get.find();
  RxBool reloadFlags = false.obs;


   void add(bool isFuel,double price, int quantity, String selectedOption, bool shop) async{
     print("abccc");
    ShopRepository.instance.addShop(isFuel,price,quantity,selectedOption, shop);

  }
  void updateList(bool fuel, String id,double price, int quantity, String selectedOption, bool shop) async{
    print("update");
    ShopRepository.instance.updateService(fuel,id,price,quantity,selectedOption,shop);

  }

  Future<String>getStationName(String StationID, bool isShop) async => ShopRepository.instance.getStationName(StationID,isShop);
  void updateStatus( String id, String selectedOption, String userID) async{
    print("update");
    ShopRepository.instance.updateStatus(id,selectedOption,userID);

  }
  Future<List<ListItemModel>> getList(bool isFuel, bool shop) async{
    print("abccc");
    List<ListItemModel> allItems = await ShopRepository.instance.getShop(shop);
    return allItems.where((item) => item.fuel == isFuel).toList();
  }


  Future<dynamic> getListUser(String id, bool shop) async{
    print("abccc");
    List<Service> allItems = await ShopRepository.instance.fetchServices(id,shop);
    return allItems;

    // return allItems.where((item) => item.fuel == isFuel).toList();
  }

  void delete( String shopId, bool shop)async{
     ShopRepository.instance.deleteShop(shopId,shop);
  }
  Future<ListUpdateModel> getItem(bool isFuel, String items, bool shop) async{
    return ShopRepository.instance.getServiceToUpdate(isFuel,items,shop);
  }
  Future<OrderModel> getOrder(String items) async{
    return ShopRepository.instance.getOrderToUpdate(items);
  }
  Future<void>? ChangeOrderStatus(String docID) async{
    await ShopRepository.instance.ChangeOrderStatus(docID);
    reloadOtherScreen();
    update();
  }
  Future<List<NotificationModel>>fetchUserNotifications() async{
     return ShopRepository.instance.fetchUserNotificationss();
  }
  Future<List<ListStationModel>> getStation(bool shop) async{
    return ShopRepository.instance.getStation(shop);
  }
  Future<List<ListStationModel>> locationforboth() async{
    return ShopRepository.instance.locationforboth();
  }


  Future<List<ListStationAdminModel>> getAllStationAdmin(bool shop) async{
    return ShopRepository.instance.getAllStationAdmin(shop);
  }
  // Future<List<ListStationAdminModel>> getAllShopAdmin() async{
  //   return ShopRepository.instance.getAllShopAdmin();
  // }
  Future<ListStationAdminModel> getStationAdmin(String id, bool shop) async{
    return ShopRepository.instance.getStationAdmin(id, shop);
  }

  Future<List<ListRiderModel>> getRiders() async{
    return ShopRepository.instance.getRiders();
  }
  Future<ListRiderModel> getRider(String id) async{
    return ShopRepository.instance.getRider(id);
  }
  void updateRiderStatus( String id, String selectedOption) async{
    print("update Rider");
    ShopRepository.instance.updateRiderStatus(id,selectedOption);

  }
  void updateStationStatus( String id, String selectedOption) async{
    print("update station");
    ShopRepository.instance.updateStationStatus(id,selectedOption);

  }
  void updateShopStatus( String id, String selectedOption) async{
    print("update shop");
    ShopRepository.instance.updateShopStatus(id,selectedOption);

  }

  Future<List<ListUserModel>> getAdminUsers() async{
    return ShopRepository.instance.getAdminUsers();
  }




  void order(String? orderAddresss,String location,String Cardetail, double finalprice, String stationId, LatLng selectedLocation, bool isShop){
    ShopRepository.instance.saveOrderDetailsToFirebase(orderAddresss,location,Cardetail,finalprice,stationId, selectedLocation, isShop);
    reloadOtherScreen();
    update();

  }
  void reloadOtherScreen() {
    print("Toggeeeeellllllllllllllddddddddddd");
    reloadFlags.toggle();

  }
void savelocation(LatLng location){
     ShopRepository.instance.saveLocationToFirestore(location);
}
  Future<GeoPoint> getStationlocation(String stationID) async{
    return ShopRepository.instance.fetchStationLocation(stationID);
  }

  Future<List<LatLng>> fetchRoute(LatLng start, LatLng end) async{
     return ShopRepository.instance.fetchRoute(start,end);
  }

  Future<List<Map<String, dynamic>>> UserOrders() async {
    // reloadOtherScreen();
    // update();
    return await ShopRepository.instance.fetchUserOrders();

  }

  Future<List<Map<String, dynamic>>> AllOrders() async {
    return await ShopRepository.instance.fetchAllOrders();
  }

  Future<List<Map<String, dynamic>>> fetchRiderMyOrders() async {

    return await ShopRepository.instance.fetchRiderMyOrders();
  }


  Future<List<Map<String, dynamic>>> StationOrders() async {
    return await ShopRepository.instance.fetchStationOrders();
  }
void shopSavelocation(LatLng location, String stationId, bool station){
     ShopRepository.instance.saveShopLocation(location,stationId,station);
}
}