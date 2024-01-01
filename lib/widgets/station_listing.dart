import 'package:fix_fill/Controller/shop_controller.dart';
import 'package:fix_fill/constants.dart';
import 'package:fix_fill/user/SelectServices.dart';
import 'package:fix_fill/user/select_service.dart';
import 'package:fix_fill/widgets/tab_bar.dart';
import 'package:fix_fill/widgets/update_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';

import '../model/ListItemModel.dart';

import 'package:ionicons/ionicons.dart';

import '../model/ListedStationModel.dart';
class ListedStation extends StatelessWidget {
  // const Listed({Key? key}) : super(key: key);

  final ListStationModel item;
  bool shop;

  ListedStation({required this.item, required this.shop});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onTap: () {
          print(item);
          if(shop==true){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SideServices(id:item.id, shop:true)),
            );
          }else if(shop==false){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TabBars(id:item.id)),
            );
          }

           // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TabBars(id:item.id)),);
        },
        child:Container(
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
          child:Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(

                  width: 100.0, // Set your desired width
                  height: 90.0, // Set your desired height
                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(15.0), // Adjust the radius here for your desired curve
                  ),
                    child:

                    item.imageProfileURL==null? Image(image:AssetImage('assets/GasStation.jpg')):Image(image:NetworkImage(item.imageProfileURL!)),

                        // image:item.imageProfileURL==null? AssetImage('assets/GasStation.jpg'):NetworkImage(item.imageProfileURL),
                     // item.imageProfileURL==null?AssetImage('assets/GasStation.jpg'):NetworkImage(item.imageProfileURL), // Your image asset
                     //  fit: BoxFit.cover,


                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(height: 10),

                      Text(("${item.name}").toString(), // Replace with item name
                        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(("${item.description}").toString(), // Replace with item name
                        style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.5),overflow: TextOverflow.ellipsis,),
                      ),
                      item.distance!=null
                          ?Text("${item.distance!.toStringAsFixed(2)} km away")
                          : Container(),

                    ],

                  ),

                ),



              ]),

        ));
  }
}

