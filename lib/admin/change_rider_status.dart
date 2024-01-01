import 'package:fix_fill/Controller/shop_controller.dart';
import 'package:fix_fill/model/ListStationAdminModel.dart';
import 'package:fix_fill/model/ListedRiderModal.dart';
import 'package:fix_fill/model/ListedStationModel.dart';
import 'package:fix_fill/widgets/navbar.dart';
import 'package:fix_fill/widgets/update_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangeStatus extends StatefulWidget {
   String id;
   bool rider;
   bool shop;
  ChangeStatus({ required this.id, required this.rider, required this.shop});

  @override
  State<ChangeStatus> createState() => _ChangeStatusState();
}

class _ChangeStatusState extends State<ChangeStatus> {
  var controller = Get.put(ShopController());
   Future<ListRiderModel>? items;
   Future<ListStationAdminModel>? item2;


  @override
  Widget build(BuildContext context) {
    if (widget.rider) {
      items = ShopController.instance.getRider(widget.id);
    } else {
      item2 = ShopController.instance.getStationAdmin(widget.id,widget.shop);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("FIX"),
      ),
      drawer: NavBar(name: "admin",),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(25, 20, 25, 25),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.h),
                (widget.rider==true)
                    ?(buildRidersList())
                    :(buildStationsList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRidersList() {

    return FutureBuilder<ListRiderModel>(
      future: items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          String? imageUrl = snapshot.data!.imageURL;

          return
            SingleChildScrollView(
                child: Container(
                  height: 500.h, // Adjusted height
                  width: 400.w,

                            child: Column(
                                children: [


                                  imageUrl != null
                                      ? Image.network(imageUrl)
                                      : Text("No image found"),
                                  SizedBox(height: 20.h,),
                                  (snapshot.data!.id == widget.id)
                                      ? Text("Currently: ${snapshot.data!.status}")
                                      : Text("No found"),
                                  SizedBox(height: 10.h,),
                                  ElevatedButton(onPressed: () {
                                    _showUpdateItemModal(
                                        context, items: widget.id, rider:true, shop:widget.shop);
                                  },
                                      child: Text("Change Status"))
                                ])


                        )
                  //     }
                  // ),
                );
          // Render riders list here
        }
      },
    );
  }

  Widget buildStationsList() {

    return FutureBuilder<ListStationAdminModel>(
      future: item2,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }  else {
          String? imageUrl = snapshot.data!.imageURL;

          return
            SingleChildScrollView(
                child: Container(
                  height: 500.h, // Adjusted height
                  width: 400.w,


                            child: Column(
                                children: [

                                  imageUrl != null
                                      ? Image.network(imageUrl)
                                      : Text("No image found"),
                                  SizedBox(height: 20.h,),
                                  (snapshot.data!.id == widget.id)
                                      ? Text("Currently: ${snapshot.data!.status}")
                                      : Text("No found"),
                                  SizedBox(height: 10.h,),
                                  ElevatedButton(onPressed: () {
                                    _showUpdateItemModal(
                                        context, items: widget.id, rider:false,shop:widget.shop);
                                  },
                                      child: Text("Change Status"))
                                ])



                  //     }
                  // ),
                ));
          // Render stations list here
        }
      },
    );
  }

}

void _showUpdateItemModal(BuildContext context, { required String items, required bool rider, required bool shop}) {
  // showModalBottomSheet
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return UpdateStatus(items:items,order:false, rider:rider,shop:shop);
    },
  );
}
