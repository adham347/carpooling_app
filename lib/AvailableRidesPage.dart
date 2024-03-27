
import 'package:flutter/material.dart';
import 'package:carpooling_app/AvailableRideCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carpooling_app/main.dart';
import 'package:carpooling_app/LoginPage.dart';

User? loggedinUser;

class AvailableRidesPage extends StatefulWidget {
  const AvailableRidesPage({Key? key}) : super(key: key);
  @override
  State<AvailableRidesPage> createState() => _AvailableRidesPageState();
}

class _AvailableRidesPageState extends State<AvailableRidesPage> {
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
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    getCurrentUser();
    print(loggedinUser);
    var passengerProfile;
    db.collection('passengers').doc(auth.currentUser?.email).get().then((DocumentSnapshot doc){
      passengerProfile = doc.data() as Map<String,dynamic>;
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Available Rides:"
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
              label: "Available rides"
          ),
          NavigationDestination(
              icon: Icon(Icons.drive_eta),
              label: "Reserved rides"
          ),
          NavigationDestination(
              icon: Icon(Icons.drive_eta),
              label: "Rides history"
          )
        ],
      ),
      body:<Widget>[
        StreamBuilder<QuerySnapshot>(
          stream: db.collection('rides').where('available space', isGreaterThan: 0).orderBy('available space', descending: true).where('status', isEqualTo: 'pending').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if (snapshot.connectionState == ConnectionState.waiting){
              return const CircularProgressIndicator();
            }
            final userSnapshot = snapshot.data?.docs;
            if(userSnapshot == null){
              return const Text('no data');
            }

            return ListView.builder(
                itemCount: userSnapshot.length,
                itemBuilder: (context, index){
                  var rideData =  userSnapshot[index].data() as Map<String,dynamic>;
                  final String rideID = userSnapshot[index].id;
                  return AvailableRideCard(rideData: rideData, rideID: rideID,);
                }
            );
          }
      ),
        StreamBuilder<QuerySnapshot>(
            stream: db.collection('rides').where('available space', isGreaterThan: 0).orderBy('available space', descending: true).where('status', isEqualTo: 'pending')
                .where('passengers ids',arrayContains: auth.currentUser?.email )
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (snapshot.connectionState == ConnectionState.waiting){
                return const CircularProgressIndicator();
              }
              final userSnapshot = snapshot.data?.docs;
              if(userSnapshot == null){
                return const Text('no data');
              }


              return ListView.builder(
                  itemCount: userSnapshot.length,
                  itemBuilder: (context, index){
                    var rideData =  userSnapshot[index].data() as Map<String,dynamic>;
                    final String rideID = userSnapshot[index].id;
                    return AvailableRideCard(rideData: rideData, rideID: rideID,);
                  }
              );
            }
        ),
        StreamBuilder<QuerySnapshot>(
            stream: db.collection('rides').where('available space', isGreaterThan: 0).orderBy('available space', descending: true).where('status', isEqualTo: 'finished')
                .where('passengers ids',arrayContains: auth.currentUser?.email )
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (snapshot.connectionState == ConnectionState.waiting){
                return const CircularProgressIndicator();
              }
              final userSnapshot = snapshot.data?.docs;
              if(userSnapshot == null){
                return const Text('no data');
              }


              return ListView.builder(
                  itemCount: userSnapshot.length,
                  itemBuilder: (context, index){
                    var rideData =  userSnapshot[index].data() as Map<String,dynamic>;
                    final String rideID = userSnapshot[index].id;
                    return AvailableRideCard(rideData: rideData, rideID: rideID,);
                  }
              );
            }
        ),
    ][currentPageIndex]
    );
  }
}
