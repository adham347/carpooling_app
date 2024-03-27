
import 'package:flutter/material.dart';
import 'package:carpooling_app/DriverRideCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carpooling_app/main.dart';

User? loggedinUser;

class DriverRidesPage extends StatefulWidget {
  const DriverRidesPage({Key? key}) : super(key: key);
  @override
  State<DriverRidesPage> createState() => _DriverRidesPageState();
}

class _DriverRidesPageState extends State<DriverRidesPage> {
  int currentPageIndex = 0;

  void getCurrentUser() async {
    try {
      final user = auth.currentUser;

      if (user != null) {
        loggedinUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    getCurrentUser();
    print(loggedinUser);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
            "Rides:"
        ),
        backgroundColor: Colors.blueGrey,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations:const <Widget>[
          NavigationDestination(
              icon: Icon(Icons.drive_eta),
              label: "upcoming rides"
          ),
          NavigationDestination(
              icon: Icon(Icons.drive_eta),
              label: "rides done"
          ),
          NavigationDestination(
              icon: Icon(Icons.drive_eta),
              label: "started ride"
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.pushNamed(context, '/AddRide');
        },
      ),
      body:<Widget>[
        StreamBuilder<QuerySnapshot>(
          stream: db.collection('rides').where('driverID', isEqualTo: auth.currentUser?.email).where('status',isEqualTo: 'pending' ).orderBy('date').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if (snapshot.connectionState == ConnectionState.waiting){
              return const CircularProgressIndicator();
            }
            final userSnapshot = snapshot.data?.docs;
            if(userSnapshot == null){
              return const Text('no rides');
            }
            return ListView.builder(
                itemCount: userSnapshot.length,
                itemBuilder: (context, index){
                  var rideData =  userSnapshot[index].data() as Map<String,dynamic>;
                  final String rideID = userSnapshot[index].id;
                  return DriverRideCard(rideData: rideData, rideID: rideID,);
                }
            );
          }
      ),
        StreamBuilder<QuerySnapshot>(
            stream: db.collection('rides').where('driverID', isEqualTo: auth.currentUser?.email).where('status',isEqualTo: 'finished' )
                .orderBy('date').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (snapshot.connectionState == ConnectionState.waiting){
                return const CircularProgressIndicator();
              }
              final userSnapshot = snapshot.data?.docs;
              if(userSnapshot!.isEmpty){
                return const Text('no data');
              }
              return ListView.builder(
                  itemCount: userSnapshot.length,
                  itemBuilder: (context, index){
                    var rideData =  userSnapshot[index].data() as Map<String,dynamic>;
                    final String rideID = userSnapshot[index].id;
                    return DriverRideCard(rideData: rideData, rideID: rideID,);
                  }
              );
            }
        ),
        StreamBuilder<QuerySnapshot>(
            stream: db.collection('rides').where('driverID', isEqualTo: auth.currentUser?.email).where('status',isEqualTo: 'started' )
                .orderBy('date').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (snapshot.connectionState == ConnectionState.waiting){
                return const CircularProgressIndicator();
              }
              final userSnapshot = snapshot.data?.docs;
              if(userSnapshot!.isEmpty){
                return const Text('no data');
              }
              return ListView.builder(
                  itemCount: userSnapshot.length,
                  itemBuilder: (context, index){
                    var rideData =  userSnapshot[index].data() as Map<String,dynamic>;
                    final String rideID = userSnapshot[index].id;
                    return DriverRideCard(rideData: rideData, rideID: rideID,);
                  }
              );
            }
        ),
    ][currentPageIndex]
    );

  }
}
