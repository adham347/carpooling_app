

import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carpooling_app/AvailableRidesPage.dart';
import 'package:carpooling_app/main.dart';

List timeList = ['7:30 AM','5:30 PM'];
String firstTime = timeList.first;

List spaceList = ['4','3','2','1'];
String space = spaceList.first;


class AddRidePage extends StatefulWidget {
  const AddRidePage({Key? key}) : super(key: key);

  @override
  State<AddRidePage> createState() => _AddRidePageState();
}

class _AddRidePageState extends State<AddRidePage>{
  String location= '';
  String to = "";
  String from = '';
  String time = '';
  DateTime? datePicked;
  TextEditingController dateController= TextEditingController();




  @override
  Widget build(BuildContext context){

    var driverData;
    db.collection('drivers').doc(auth.currentUser?.email.toString()).get().then((DocumentSnapshot doc) async{
      driverData = doc.data() as Map<String,dynamic>;
      print(driverData);
    });

    //final driverData = driverDoc.data() as DocumentSnapshot;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Add a Ride",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(
                        "From:",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                      width: 250,
                      height: 50,
                      child: TextField(
                        onChanged: (value){
                          from = value;
                        },
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter location",
                          ),
                        ),
                      ),
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
                      SizedBox(
                        width: 250,
                        height: 50,
                        child: TextField(
                          onChanged: (value){
                            to = value;
                          },
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Enter location",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10,left: 10),
                  child: Row(
                    children: [
                      Text(
                        "Link:",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 315,
                        height: 50,
                        child: TextField(
                          onChanged: (value){
                            location = value;
                          },
                          style: TextStyle(fontSize: 10),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Paste a maps link",
                          ),
                        ),
                      ),
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
                      DropdownButton(
                          value: firstTime,
                          items: timeList.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            );
                          }).toList(),
                          onChanged: (var x) {
                            setState(() {
                              firstTime = x.toString();
                            });
                          }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(
                        "Ride Date:",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 20),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: TextField(
                            controller: dateController,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.edit_calendar),

                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate:DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 7))
                              );
                              if(pickedDate != null ){
                                datePicked = pickedDate;
                                print(pickedDate);  //get the picked date in the format => 2022-07-04 00:00:00.000
                                String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                print(formattedDate); //formatted date output using intl package =>  2022-07-04
                                //You can format date as per your need
                                setState(() {
                                  dateController.text = formattedDate; //set foratted date to TextField value.
                                });
                              }else{
                                print("Date is not selected");
                              }
                            }

                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(
                        "Available Space:",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 20),
                      DropdownButton(
                          value: space,
                          items: spaceList.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            );
                          }).toList(),
                          onChanged: (var x) {
                            setState(() {
                              space = x.toString();
                            });
                          }),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    ElevatedButton(
                      onPressed: () async{
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Adding Ride...'))
                        );

                        bool sameDateTimeFlag = false;
                        await db.collection('rides').where('driverID',isEqualTo: driverData['email']).where('status',isEqualTo: 'pending')
                            .where('time', isEqualTo: firstTime).where('date', isEqualTo: datePicked).get().then((querySnapshot){
                              if(querySnapshot.docs.isNotEmpty) sameDateTimeFlag= true;
                        });

                        String carType = driverData['car type'];
                        String license = driverData['license number'];
                        String email = driverData['email'];
                        String phone = driverData['phone number'];
                        final ride = <String,dynamic>{
                          'to': to,
                          'from': from,
                          'location': location,
                          'time': firstTime,
                          'date': datePicked,
                          'add date': DateTime.now(),
                          'driver': auth.currentUser?.displayName,
                          'driverID': email,
                          'phone number': phone,
                          'car type': carType,
                          'license number': license,
                          'available space': int.parse(space),
                          'status':'pending',
                          'passengers': [],
                          'passengers ids': []
                        };
                        print("same date time flag:"+ sameDateTimeFlag.toString());
                        if(to.isEmpty || from.isEmpty || location.isEmpty || datePicked == null){
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Fill the empty fields'))
                          );
                        }else{
                          if(sameDateTimeFlag){
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('there is a ride on the same time and date added by you'))
                            );
                          }else{
                            try {
                              await db.collection('rides').add(ride);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Ride added'))
                              );
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/DriverRides', (route) => false);
                            } catch(e){
                              print(e);
                            }
                          }
                        }

                      },
                      child: Text('Add Ride', style: TextStyle(fontSize: 20.0)),
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
      ),
    );
  }
}
