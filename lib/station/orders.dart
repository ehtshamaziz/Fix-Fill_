// ignore_for_file: camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_fill/Controller/shop_controller.dart';
import 'package:fix_fill/rider/orderDetail_screen.dart';
import 'package:fix_fill/widgets//bottom_nav_bar.dart';
import 'package:fix_fill/widgets//navbar.dart';
import 'package:fix_fill/widgets/update_status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class Orders extends StatefulWidget {
  bool shop;
  Orders({required this.shop});

  @override
  State<Orders> createState() => _OrderState();
}

class _OrderState extends State<Orders> {


  var controller =Get.put(ShopController());



  @override
  Widget build(BuildContext context) {

    late String name;
    if(widget.shop==true){
      name="shop";
    }else if(widget.shop==false){
      name="station";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Order"),
      ),
      drawer: NavBar(name:name),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future:  ShopController.instance.StationOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No orders found", style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5))));
          }

          List<Map<String, dynamic>> orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> order = orders[index];
              return Container(
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

                margin: EdgeInsets.all(20),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Order:",style:TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.green),
                          SizedBox(width: 8),
                          Text("Status: ${order['Status']}", style: TextStyle(fontSize: 16)),

                          SizedBox(width: 20,),
                          ElevatedButton(
                            onPressed: () {
                              _showUpdateItemModal(context,items: order['docID'], shop:widget.shop);                            },
                            style: ButtonStyle(
                              // Change the background color
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold), // Change the text style
                              ),
                              elevation: MaterialStateProperty.all<double>(4.0), // Change the elevation
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0), // Change the border radius
                                ),
                              ),
                            ),
                            child: Text("Change Status"),
                          ),
                        ],
                      ),
                      // Divider(height: 10, thickness: 1),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Icon(Icons.attach_money, color: Colors.blue),
                          SizedBox(width: 8),
                          Text("Total Price: ${order['totalPrice']} \$", style: TextStyle(fontSize: 16)),
                          SizedBox(width: 35,),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailScreen(order: order)));
                            },
                            style: ButtonStyle(
                              // Change the background color
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold), // Change the text style
                              ),
                              elevation: MaterialStateProperty.all<double>(4.0), // Change the elevation
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0), // Change the border radius
                                ),
                              ),
                            ),
                            child: Text("See Detail"),
                          )




                        ],
                      ),
                      // Divider(height: 10, thickness: 1),
                      SizedBox(height: 20,),


                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
void _showUpdateItemModal(BuildContext context, { required String items, required bool shop}) {
  // showModalBottomSheet
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return UpdateStatus(items:items,order:true,rider: false,shop:shop);
    },
  );
}