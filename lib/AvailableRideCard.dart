import 'package:carpooling_app/RideDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carpooling_app/main.dart';
import 'package:intl/intl.dart';


class AvailableRideCard extends StatelessWidget {
  final Map<String,dynamic> rideData;
  final String rideID;

  const AvailableRideCard({
    required this.rideData,
    required this.rideID
  });

  @override
  Widget build(BuildContext context) {

    print(rideData);
    String date = DateFormat('dd-MM-yyyy').format(rideData['date'].toDate());

    return GestureDetector(
      onTap: (){
        Navigator.push(context, new MaterialPageRoute(
            builder: (context) => new RideDetails(rideID: rideID,rideData: rideData,))
        );
      },
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: SizedBox(
                  width: 350,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("From: "),
                          Text(rideData['from']),
                          SizedBox(width: 20),
                          Text("To: "),
                          Text(rideData['to'])
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Text("Car type: "),
                          Text(rideData['car type'])
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Available Spaces: "),
                          Text(rideData['available space'].toString())
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Date: "),
                          Text(date)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Departure time: "),
                          Text(rideData['time'])
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
