import 'package:fix_fill/Repository/Authentication_Repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  /// TextField Controllers to get data from TextFields
  final email = TextEditingController();
  final password = TextEditingController();

  /// TextField Validation

  //Call this Function from Design & it will do the rest
  Future <String?> login(String email, String password,String selectedOption) async {
    String? errorMessage = await AuthenticationRepository.instance.loginWithEmailAndPassword(email, password,selectedOption);
    return errorMessage;



  }
  Future<void> deleteRider(String riderId) async {
    AuthenticationRepository.instance.deleteRider(riderId);

  }
  Future<void> disableRider(String uid) async {

    AuthenticationRepository.instance.disableRider(uid);

  }
  Future<void> enableRider(String uid) async {

    AuthenticationRepository.instance.enableRider(uid);

  }


  Future<void> disableStation(String uid) async {

    AuthenticationRepository.instance.disableStation(uid);

  }

  Future<void> disableShop(String uid) async {

    AuthenticationRepository.instance.disableShop(uid);

  }



  Future<void> enableStation(String uid) async {

    AuthenticationRepository.instance.enableStation(uid);

  }
  Future<void> enableShop(String uid) async {

    AuthenticationRepository.instance.enableShop(uid);

  }

  Future<void> disableUser(String uid) async {

    AuthenticationRepository.instance.disableUser(uid);

  }
  Future<void> enableUser(String uid) async {

    AuthenticationRepository.instance.enableUser(uid);

  }


  Future<void> deleteUser(String userId) async {
    AuthenticationRepository.instance.deleteUser(userId);

  }
  Future<void> deleteStation(String stationId) async {
    AuthenticationRepository.instance.deleteStation(stationId);

  }
  Future<void> deleteShop(String stationId) async {
    AuthenticationRepository.instance.deleteShop(stationId);

  }
}