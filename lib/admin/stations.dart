// ignore_for_file: camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_fill/Controller/login_controller.dart';
import 'package:fix_fill/admin/change_rider_status.dart';
import 'package:fix_fill/model/ListStationAdminModel.dart';
import 'package:fix_fill/model/ListUpdateModel.dart';
import 'package:fix_fill/model/ListedStationModel.dart';
import 'package:fix_fill/user/user_select_location.dart';
import 'package:fix_fill/widgets//navbar.dart';
import 'package:fix_fill/widgets/search.dart';
import 'package:fix_fill/widgets/station_listing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';

import '../Controller/shop_controller.dart';
import '../model/ListItemModel.dart';
import '../widgets/listing.dart';



class AdminStations extends StatefulWidget {
  bool shop;
   AdminStations({required this.shop});

  @override
  State<AdminStations> createState() => _AdminStationsState();
}

class _AdminStationsState extends State<AdminStations> {

  var controller= Get.put(ShopController());



  @override
  Widget build(BuildContext context) {
    Future<List<ListStationAdminModel>> items;
    if(widget.shop==true){

      items =ShopController.instance.getAllStationAdmin(widget.shop);

    }else{
      items =ShopController.instance.getAllStationAdmin(widget.shop);


    }
    return Scaffold(
        appBar: new AppBar(
            title: new Text("FIX")
        ),
        drawer: NavBar(name:"admin"),
        backgroundColor: Colors.white,
        body:SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(25,20,25,25),
            child: Center(

              child: Column(
                  children: <Widget>[



                    SizedBox(height:10.h),

                    FutureBuilder<List<ListStationAdminModel>>(
                      future: items,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center( child:Text("No Station found", style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5))));
                        } else {
                          return
                            SingleChildScrollView(
                                child:Container(
                                    height: 540.h, // Adjusted height
                                    width:400.w,
                                    child: ListView.builder(

                                      itemCount: snapshot.data!.length,

                                      itemBuilder: (context, index) {
                                        // return
                                        //   ListedStation(item: snapshot.data![index]);
                                        return
                                          // GestureDetector(
                                          //   onTap: () {
                                          //     // print(snapshot.data![index]);
                                          //     // Navigator.push(
                                          //     //   context,
                                          //     //   MaterialPageRoute(builder: (context) => TabBars(id:item.id)),
                                          //     // );
                                          //     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TabBars(id:item.id)),);
                                          //   },
                                          //   child:
                                        Container(
                                              margin: EdgeInsets.all(8.0),
                                              padding: EdgeInsets.all(16.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.5),
                                                      spreadRadius: 2,
                                                      blurRadius: 2,
                                                      offset: Offset(0,3),
                                                    )
                                                  ]

                                              ),
                                              child:Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                              Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(

                                                      width: 100.0, // Set your desired width
                                                      height: 90.0, // Set your desired height
                                                      decoration: BoxDecoration(

                                                        borderRadius: BorderRadius.circular(15.0), // Adjust the radius here for your desired curve

                                                      ),
                                                      child:

                                                      snapshot.data![index].imageProfileURL==null? Image(image:AssetImage('assets/GasStation.jpg')):Image(image:NetworkImage(snapshot.data![index].imageProfileURL!)),

                                                    ),
                                                    const SizedBox(width: 20),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [

                                                          SizedBox(height: 20,),
                                                          Text((snapshot.data![index].name).toString(), // Replace with item name
                                                            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                                                          ),
                                                          if (snapshot.data![index].distance != null)
                                                            Text("${snapshot.data![index].distance!.toStringAsFixed(2)} km away"),
                                                          SizedBox(height: 4),

                                                          Text((snapshot.data![index].status).toString(), // Replace with item name
                                                            style: TextStyle(fontSize: 19),
                                                          ),

                                                        ],

                                                      ),

                                                    )
                                                    ]),
                                                    Container(
                                                      child:
                                                      Row(
                                                        crossAxisAlignment:CrossAxisAlignment.start,
                                                        children: [

                                                          ElevatedButton(
                                                            onPressed: () {
                                                              if(widget.shop==true){
                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeStatus(id: snapshot.data![index].id, rider: false, shop:true)));

                                                              }
                                                              else{
                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeStatus(id: snapshot.data![index].id, rider: false, shop:false)));

                                                              }
                                                            },
                                                            style: ButtonStyle(
                                                              // Change the background color
                                                              textStyle: MaterialStateProperty.all<TextStyle>(
                                                                TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold,), // Change the text style
                                                              ),
                                                              elevation: MaterialStateProperty.all<double>(4.0), // Change the elevation
                                                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                                                RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(10.0), // Change the border radius
                                                                ),
                                                              ),
                                                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                                                EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0), // Change the padding
                                                              ),
                                                            ),
                                                            child: Text("Change Status"),
                                                          ),
                                                          // SizedBox(height: 40,),
                                                          SizedBox(width: 20,),
                                                          (snapshot.data![index].disabled == true)
                                                              ? ElevatedButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminStations(shop:widget.shop)));
                                                              });
                                                              if(widget.shop==true){
                                                                LoginController.instance.enableShop(snapshot.data![index].id);
                                                              }else{
                                                                LoginController.instance.enableStation(snapshot.data![index].id);
                                                              }
                                                              ;
                                                            },
                                                            style: ButtonStyle(
                                                              // backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                                            ),
                                                            child:  const Text("Un-Ban"),
                                                          )
                                                              : ElevatedButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminStations(shop:widget.shop)));
                                                              });
                                                              if(widget.shop==true){
                                                                LoginController.instance.disableShop(snapshot.data![index].id);

                                                              }else{
                                                                LoginController.instance.disableStation(snapshot.data![index].id);

                                                              }
                                                            },
                                                            style: ButtonStyle(
                                                              foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // Replace with your desired text color
                                                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xF22D2D)),
                                                              // backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                                            ),
                                                            child: const Text("Ban"),
                                                          ),

                                                          SizedBox(width: 8,),
                                                          IconButton(
                                                            icon:const Icon(Ionicons.trash_bin),
                                                            color: Colors.red,
                                                            onPressed: () {
                                                              setState(() {
                                                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AdminStations(shop:widget.shop)));
                                                              });

                                                              if(widget.shop==true){
                                                                LoginController.instance.deleteShop(snapshot.data![index].id);

                                                              }else{
                                                                LoginController.instance.deleteStation(snapshot.data![index].id);

                                                              }

                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    )



                                                  ]),

                                            );
                                        // );


                                      },
                                    )));
                        }
                      },
                    ),









                  ]
              ),

            ),
          ),
        )






    );

  }}