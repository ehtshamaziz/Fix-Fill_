class ListRiderModel {

  String id;
  String name;
  String status;
  String imageURL;
  bool disabled;
  String? imageProfileURL;


  ListRiderModel({required this.status,required this.id, required this.name, required this.imageURL, required this.disabled, required this.imageProfileURL});
}