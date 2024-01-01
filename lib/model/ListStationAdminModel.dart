class ListStationAdminModel {

  String id;
  String name;
  double latitude;
  double longitude;
  double? distance;
  String status;
  String? imageURL;
  bool disabled;
  String? imageProfileURL;


  ListStationAdminModel(
      {required this.id, required this.name, required this.latitude, required this.longitude, this.distance, required this.status, required this.imageURL, required this.disabled,required this.imageProfileURL});
}