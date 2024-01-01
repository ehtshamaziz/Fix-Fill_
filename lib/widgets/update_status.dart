import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_fill/Controller/shop_controller.dart';
import 'package:fix_fill/admin/station_maps.dart';
import 'package:fix_fill/model/ListUpdateModel.dart';
import 'package:fix_fill/station/orders.dart';
import 'package:fix_fill/widgets/bottom_nav_bar.dart';
import 'package:fix_fill/widgets/bottom_nav_shop.dart';
import 'package:fix_fill/widgets/bottom_navbar_rider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fix_fill/widgets/bottom_nav_admin.dart';

import '../station/shop.dart';

class UpdateStatus extends StatefulWidget {
  // const UpdateItemDialog({super.key});

  String items;
  bool order;
  bool rider;
  bool shop;
  //
  UpdateStatus({required this.items,required this.order, required this.rider, required this.shop});

  @override
  _UpdateStatusState createState() => _UpdateStatusState();
}

class _UpdateStatusState extends State<UpdateStatus> {
  String itemName = '';
  double price = 0.0;
  int quantity = 1;
  // List<String> dropdownOptions = ['Gas', 'Disel', 'Petrol',];
  final _formkey=GlobalKey<FormState>();
  final controller= Get.put(ShopController());
  static ShopController get instance => Get.find();

  TextEditingController priceController = TextEditingController(text: "");
  TextEditingController quantityController = TextEditingController(text: "");
  TextEditingController categoryController = TextEditingController(text: "");
  // late String selectedOption="Gas";

  // String selectedOption1 = 'Gas';
  String selectedOption="Pending";

  List<String> dropdownOption1 = ['Pending', 'Delivered', 'In-progress',];
  List<String> dropdownOption2 = ['Pending', 'Accepted',];

  String statusID="";
  String userID="";
  // String selectedOption2 = 'Tyre';
  // List<String> dropdownOptions2 = ['Tyre', 'Oil', 'Key',];
  @override
  void initState() {

    super.initState();
    (widget.order==true)?(

    ShopController.instance.getOrder(widget.items.toString()).then((shopData) {
      setState(() {
        print("dataaaaaaaaaaa ${shopData.Status}");
        userID=shopData.userID;
        print("helpp ${userID}");
        statusID=shopData.id;
        selectedOption= shopData.Status;
        // priceController = TextEditingController(text: shopData.price.toString());
        // quantityController = TextEditingController(text: shopData.quantity.toString());

      });
    }))
    :(
        ShopController.instance.getRider(widget.items.toString()).then((riderData) {
    setState(() {
    print("dataaaaaaaaaaa ${riderData.status}");
    // userID=shopData.userID;
    print("helpp ${userID}");
    statusID=riderData.id;
    selectedOption= riderData.status;
    // priceController = TextEditingController(text: shopData.price.toString());
    // quantityController = TextEditingController(text: shopData.quantity.toString());

    });
    })

    );
  }

  @override
  Widget build(BuildContext context) {

    List<String> xyz=widget.order? dropdownOption1:dropdownOption2;
    return Dialog(
      backgroundColor: Colors.white, // Set the background color to white

      child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
          padding: EdgeInsets.all(50.0),
          child:Form(
            key: _formkey,
            child: Column(

              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                const Text("Update Status",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)
                ),
                DropdownButton<String>(
                  // initialSelection: dropdownOptions.first,
                    value: selectedOption,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedOption = newValue!;
                      });
                    },
                    style: const TextStyle(
                      // You can customize the text style here
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    underline: Container(
                      // You can customize the underline (border) here
                      height: 2,
                      color: Colors.blueAccent,
                    ),
                    isExpanded: true,
                    items: xyz.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()),


                SizedBox(height: 20),
                Row(
                  children: <Widget>[
SizedBox(width: 30,),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(), // Close the dialog
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        if (_formkey.currentState!.validate()) {
                          if(widget.order==true){

                            ShopController.instance.updateStatus(statusID,selectedOption,userID);
                            Navigator.of(context).pop();
                            setState(() {
                              print("Ancc");
                              // initState();
                              // BottomShopNavigationBar
                              if(widget.shop==true){
                                print("Orderrsss11111");
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavAdmin()));

                              }else if(widget.shop==false){
                                print("Orderrsss00000");

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavigationBarExample()));

                              }
                              // Shop(isFuel:true);
                              print("BBBB");
                            });
                          }
                          // else{
                            else if(widget.rider==true){
                              ShopController.instance.updateRiderStatus(widget.items,selectedOption);
                              Navigator.of(context).pop();
                              setState(() {

                                // initState();
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavAdmin()));
                                // Shop(isFuel:true);
                                print("BBBB");
                              });
                            }else if(widget.shop==false){
                              ShopController.instance.updateStationStatus(widget.items,selectedOption);
                              Navigator.of(context).pop();
                              setState(() {

                                // initState();
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavAdmin()));
                                // Shop(isFuel:true);
                                print("BBBB");
                              });
                            }
                            else if(widget.shop==true){
                              ShopController.instance.updateShopStatus(widget.items,selectedOption);
                              Navigator.of(context).pop();
                              setState(() {

                                // initState();
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavAdmin()));
                                // Shop(isFuel:true);
                                print("BBBB");
                              });
                            }

                          }

                        },
                      // },

                      child: Text('Update'),
                    ),
                  ],
                ),

              ],
            ),)),
    );
  }
}
