import 'package:flutter/material.dart';
import 'package:carpooling_app/AvailableRidesPage.dart';
import 'package:carpooling_app/main.dart';
import 'package:intl/intl.dart';

bool showStartButton = true;

class DriverRideDetails extends StatefulWidget {
  final Map<String,dynamic> rideData;
  final String rideID;

  const DriverRideDetails({
    required this.rideID,
    required this.rideData,
    Key? key  }) : super(key: key);

  @override
  State<DriverRideDetails> createState() => _DriverRideDetailsState();
}

class _DriverRideDetailsState extends State<DriverRideDetails> {


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
                    Text(widget.rideData['location'],style: TextStyle(fontSize: 8),)
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
                      "Passengers:",
                      style: TextStyle(fontSize: 20),
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.rideData['passengers'].length,
                  itemBuilder: (context, index){
                    return Row(
                      children: [
                        Text(widget.rideData['passengers'][index]['name']+' '+widget.rideData['passengers'][index]['phone'])
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(widget.rideData['status'] == 'pending' || widget.rideData['status'] == 'started')
                    ElevatedButton(
                    onPressed: () async{
                      var currentTime = DateTime.now();
                      String rideDate = DateFormat('yyyy-MM-dd').format(widget.rideData['date'].toDate()).toString();
                      if(widget.rideData['time'] == '7:30 AM'){
                        rideDate = '$rideDate 07:30:00';
                        DateTime rd = DateTime.parse(rideDate);
                        var newDate = DateTime(rd.year,rd.month,rd.day-1,20,00);
                        if(currentTime.isAfter(newDate) && testingFlag == false){
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Too late to cancel a ride'))
                          );
                        }else{
                          try {
                            await db.collection('rides')
                                .doc(widget.rideID)
                                .update({'status': 'canceled'});
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Ride Canceled')));
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
                                  content: Text('Too late to cancel a ride'))
                          );
                        }else{
                          try {
                            await db.collection('rides')
                                .doc(widget.rideID)
                                .update({'status': 'canceled'});
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Ride Canceled')));
                          }catch(e){
                            print(e);
                          }
                        }
                      }

                      Navigator.pushNamed(context, '/DriverRides');
                    },
                    child: Text('Cancel', style: TextStyle(fontSize: 20.0,color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      backgroundColor: Colors.red
                    ),
                  ),
                  SizedBox(width: 30,),
                  if(widget.rideData['status'] == 'pending' || widget.rideData['status'] == 'started')
                    if(showStartButton)
                      ElevatedButton(
                        onPressed: () async {
                          await db.collection('rides')
                              .doc(widget.rideID)
                              .update(
                              {'status': 'started'});
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Ride Started')));
                          setState(() {
                            showStartButton = false;
                          });
                        },
                        child: Text('Start', style: TextStyle(fontSize: 20.0)),
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                        ),
                      ),
                  if(widget.rideData['status'] == 'pending' || widget.rideData['status'] == 'started')
                    if(!showStartButton)
                      ElevatedButton(
                        onPressed: () async {
                          await db.collection('rides')
                              .doc(widget.rideID)
                              .update(
                              {'status': 'finished'});
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Ride Completed')));
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/DriverRides', (route) => false);
                        },
                        child: Text('Finish', style: TextStyle(fontSize: 20.0)),
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
