import 'package:afar_cabs_user/rides_page/controller/ride_details_map_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants/colors/colors.dart';

class RideDetailPage extends StatelessWidget {
  RideDetailPage({Key? key}) : super(key: key);
  final rideMapController = Get.put(RideDetailsMapController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            elevation: 0.0,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                Text(
                  "Order ID",
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Text(
                  "Tue, Feb 07, 10:16 AM",
                  style: TextStyle(color: Colors.grey, fontSize: 14.0),
                )
              ],
            ),
            actions: [
              Padding(
                padding: EdgeInsets.all(height * 0.02),
                child: Text(
                  "₹ 203",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
          ),
        ),
        body: Stack(
          children: <Widget>[
            LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return GetBuilder<RideDetailsMapController>(
                  builder: (controller) {
                return SizedBox(
                  height: constraints.maxHeight / 1.9,
                  child: Obx(
                    () => controller.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : GoogleMap(
                            onMapCreated: controller.onMapCreated,
                            initialCameraPosition: controller.initialPosition,
                            polylines:
                                Set<Polyline>.of(controller.polylines.values),
                            // on below line setting user location enabled.
                            myLocationEnabled: true,
                            // on below line we are setting markers on the map
                            markers: Set.from(controller.startEndMarkers),
                          ),
                  ),
                );
              });
            }),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey,
                    width: 0.2,
                  ),
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                ),
                title: Text('Driver Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                subtitle: Text('Maruti Eritiga TN - 02 M 1234'),
              ),
            ),
            DraggableScrollableSheet(
                initialChildSize: 0.47,
                minChildSize: 0.47,
                maxChildSize: 1,
                snapSizes: [0.47, 1],
                snap: true,
                builder: (BuildContext context, scrollSheetController) {
                  return Container(
                    color: Colors.white,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: ClampingScrollPhysics(),
                      controller: scrollSheetController,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 50,
                                child: Divider(
                                  thickness: 5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Pickup
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 0.05,
                                ),
                                Icon(
                                  Icons.circle,
                                  color: Colors.red,
                                  size: 20.0,
                                ),
                                SizedBox(
                                  width: width * 0.05,
                                ),
                                Expanded(
                                  child: AutoSizeText("X6FQ+7JW, Ambedkar Nagar perungudi, Chennai, TamilNadu - 625410",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.1,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width * 0.15),
                              child: Text(
                                "10:16 AM",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            /// Spacer
                            SizedBox(
                              height: 20,
                            ),
                            /// Drop
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 0.05,
                                ),
                                Icon(
                                  Icons.circle,
                                  color: Colors.green,
                                  size: 20.0,
                                ),
                                SizedBox(
                                  width: width * 0.05,
                                ),
                                Expanded(
                                  child: AutoSizeText("4th Cross, Thiruvanmiyur Chennai, TamilNadu - 625410",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.1,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width * 0.15),
                              child: Text(
                                "10:45 AM",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            /// Spacer
                            SizedBox(
                              height: 20,
                            ),
                            /// Details Container
                            Container(
                              width: double.infinity,
                              height: height * 0.57,
                              color: Colors.grey.shade300,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                                  child: Card(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: <Widget>[
                                                Text('Bill Details',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Text(
                                                              "Your Trips",
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      width: width * 0.4,
                                                    ),
                                                    AutoSizeText('₹ 72.81',
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Text(
                                                              "Coupon Saving",
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      width: width * 0.4,
                                                    ),
                                                    AutoSizeText('-₹ 7.28',
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Text(
                                                              "Rounded off",
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      width: width * 0.4,
                                                    ),
                                                    AutoSizeText('-₹ 0.48',
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Text(
                                                              "Total Bill",
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      width: width * 0.4,
                                                    ),
                                                    AutoSizeText('₹ 66',
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                AutoSizeText('Includes ₹4.43 Taxes',
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Text(
                                                              "Total Payable",
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      width: width * 0.4,
                                                    ),
                                                    AutoSizeText('₹ 66',
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
