import 'package:carpooling_app/main.dart';
import 'package:flutter/material.dart';
import 'package:carpooling_app/AvailableRidesPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';



class RideDetails extends StatefulWidget {
  final Map<String,dynamic> rideData;
  final String rideID;


  const RideDetails({
    required this.rideID,
    required this.rideData,
    Key? key  }) : super(key: key);

  @override
  State<RideDetails> createState() => _RideDetailsState();
}

class _RideDetailsState extends State<RideDetails> {

  Future<void> _launchUrl(String url) async {
    try {
      await launch(
        url,
        forceWebView: false,   // Set to false to open in the external browser (Chrome)
        forceSafariVC: false,  // Set to true if you want to use SafariViewController (iOS)
      );
    } catch (e) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('dd-MM-yyyy').format(widget.rideData['date'].toDate());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Ride Details"),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      "From:",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 10),
                    Text(widget.rideData['from'],style: TextStyle(fontSize: 20),)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      "To:",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 35),
                    Text(widget.rideData['to'],style: TextStyle(fontSize: 20),)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      "Location:",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => _launchUrl(widget.rideData['location']),
                      child: Text(widget.rideData['location'],style:TextStyle(fontSize: 8)),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      "Date:",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 20),
                    Text(date,style: TextStyle(fontSize: 20),)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      "Departure time:",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 20),
                    Text(widget.rideData['time'],style: TextStyle(fontSize: 20),)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      "Car type:",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 20),
                    Text(widget.rideData['car type'],style: TextStyle(fontSize: 20),)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      "License Number:",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 20),
                    Text(widget.rideData['license number'],style: TextStyle(fontSize: 20),)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      "Driver Name:",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 20),
                    Text(widget.rideData['driver'],style: TextStyle(fontSize: 20),)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      "Driver's Phone:",
                      style: TextStyle(fontSize: 20),
                    ),

                    Text(' '+widget.rideData['phone number'],style: TextStyle(fontSize: 20),)
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(widget.rideData['status'] == 'pending')
                  ElevatedButton(
                    onPressed: () async{
                      var passengerProfile;
                      var ride;
                      await db.collection('rides').doc(widget.rideID).get().then((DocumentSnapshot doc){
                        ride = doc.data() as Map<String,dynamic>;
                      });
                      await db.collection('passengers').doc(auth.currentUser?.email).get().then((DocumentSnapshot doc){
                        passengerProfile = doc.data() as Map<String,dynamic>;
                      });

                      var currentTime = DateTime.now();
                      String rideDate = DateFormat('yyyy-MM-dd').format(widget.rideData['date'].toDate()).toString();
                      if(widget.rideData['time'] == '7:30 AM'){
                        rideDate = '$rideDate 07:30:00';
                        DateTime rd = DateTime.parse(rideDate);
                        var newDate = DateTime(rd.year,rd.month,rd.day-1,20,00);
                        if(currentTime.isAfter(newDate) && testingFlag==false){
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Too late to book this ride'))
                          );
                        }else{
                          try {
                            var newPassenger = <String,dynamic>{
                              'name': auth.currentUser?.displayName,
                              'phone': passengerProfile['phone number']
                            };
                            ride['passengers'].add(newPassenger);
                            ride['available space']--;
                            ride['passengers ids'].add(auth.currentUser?.email);

                            await db.collection('rides').doc(widget.rideID).update({
                              'passengers':ride['passengers'],
                              'available space':ride['available space'],
                              'passengers ids': ride['passengers ids']
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Ride Booked')));
                          }catch(e){
                            print(e);
                          }
                        }
                      }else{
                        rideDate = '$rideDate 17:30:00';
                        DateTime rd = DateTime.parse(rideDate);
                        var newDate = DateTime(rd.year,rd.month,rd.day,13,00);
                        print(newDate);
                        if(currentTime.isAfter(newDate) && testingFlag == false){
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Too late to book this ride'))
                          );
                        }else{
                          try {
                            var newPassenger = <String,dynamic>{
                              'name': auth.currentUser?.displayName,
                              'phone': passengerProfile['phone number']
                            };
                            ride['passengers'].add(newPassenger);
                            ride['available space']--;
                            ride['passengers ids'].add(auth.currentUser?.email);

                            await db.collection('rides').doc(widget.rideID).update({
                              'passengers':ride['passengers'],
                              'available space':ride['available space'],
                              'passengers ids': ride['passengers ids']
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Ride Booked')));
                          }catch(e){
                            print(e);
                          }
                        }
                      }
                      Navigator.pushNamedAndRemoveUntil(context, '/AvailableRides', (route) => false);

                    },
                    child: Text('Confirm Ride', style: TextStyle(fontSize: 20.0)),
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
