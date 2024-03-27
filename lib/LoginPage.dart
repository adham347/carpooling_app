import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carpooling_app/main.dart';
import 'DatabaseHelper.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  int currentPageIndex = 0;
bool showSpinner = false;
String email = '';
String password = '';
@override
Widget build(BuildContext context) {
  var _emailController = TextEditingController();
  var _passController = TextEditingController();
  if(rememberedUserProfile != null){
    _emailController.text = rememberedUserProfile['email'];
  }

  return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations:const <Widget>[
          NavigationDestination(
              icon: Icon(Icons.person),
              label: "Rider"
          ),
          NavigationDestination(
              icon: Icon(Icons.drive_eta),
              label: "Driver"
          )
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
      ),
      body:<Widget>[
        /// rider
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "ASU FOE Carpooling",
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  "Rider",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 200,
                  child: Image(image: AssetImage('assets/carPoolingLogo.png')
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                        "Email",
                        style: TextStyle(fontSize: 20)
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: TextField(
                        controller: _emailController,
                        onChanged: (value){
                          email=value;
                        },
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "ID@eng.asu.edu.eg",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                        "Password",
                        style: TextStyle(fontSize: 20)
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: TextField(
                        controller: _passController,
                        onChanged: (value){
                          password = value;
                        },
                        style: TextStyle(fontSize: 20),
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Enter you password"
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async{

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Signing In..."))
                        );
                        try {
                          final loggedUser = await auth
                              .signInWithEmailAndPassword(
                              email: email, password: password);
                          if(rememberEmailFlag){
                            Map<String,dynamic> profile = {
                              'email': email,
                              'name': loggedUser.user?.displayName
                            };
                            await DatabaseHelper.instance.insertUserProfile(profile);
                          }

                          if(loggedUser != null){
                            Navigator.pushNamedAndRemoveUntil(context, '/AvailableRides', (route) => false);
                          }
                        }on FirebaseAuthException catch(e){
                          print(e);
                          print(e.code);
                          print(e.message);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Invalid Email of Password"))
                          );

                          _emailController.clear();
                          _passController.clear();
                        }

                      },
                      child: Text('Login', style: TextStyle(fontSize: 20.0)),
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),

                    ElevatedButton(
                      onPressed: (){
                        Navigator.pushNamed(context, '/Register');
                      },
                      child: Text('Register', style: TextStyle(fontSize: 20.0)),
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('remember email'),
                    Checkbox(value: rememberEmailFlag, onChanged: (bool? value){
                      setState(() {
                        rememberEmailFlag = value!;

                      });
                    })
                  ],
                ),
                Row(
                  children: [
                    Text('testing mode'),
                    Checkbox(value: testingFlag, onChanged: (bool? value){
                      setState(() {
                        testingFlag = value!;

                      });
                    })
                  ],
                ),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
        /// driver
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "ASU FOE Carpooling",
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  "Driver",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 200,
                  child: Image(image: AssetImage('assets/carPoolingLogo.png')
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                        "Email",
                        style: TextStyle(fontSize: 20)
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: TextField(
                        controller: _emailController,
                        onChanged: (value){
                          email=value;
                        },
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "ID@eng.asu.edu.eg",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                        "Password",
                        style: TextStyle(fontSize: 20)
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: TextField(
                        controller: _passController,
                        onChanged: (value){
                          password = value;
                        },
                        style: TextStyle(fontSize: 20),
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Enter you password"
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async{
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Signing In..."))
                        );
                        try {
                          await db.collection('drivers').doc(email).get().then(
                                  (DocumentSnapshot doc) async{
                                    final data = doc.data() as Map<String,dynamic>;
                                    print(data);
                                    final loggedUser = await auth
                                        .signInWithEmailAndPassword(
                                        email: email, password: password);
                                    if(rememberEmailFlag) {
                                      Map<String, dynamic> profile = {
                                        'email': email,
                                        'name': loggedUser.user?.displayName
                                      };
                                      await DatabaseHelper.instance
                                          .insertUserProfile(profile);
                                    }
                                    if(loggedUser != null){
                                      Navigator.pushNamedAndRemoveUntil(context, '/DriverRides', (route) => false);
                                    }
                                  },onError: (e) => print("Error getting doc: $e"),
                          );

                        }on FirebaseAuthException catch(e){
                          print(e);
                          print(e.code);
                          print(e.message);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Invalid Email of Password"))
                          );

                          _emailController.clear();
                          _passController.clear();
                        } catch(e){
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Invalid Email or Password"))
                          );
                          _emailController.clear();
                          _passController.clear();
                        }

                      },
                      child: Text('Login', style: TextStyle(fontSize: 20.0)),
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),

                    ElevatedButton(
                      onPressed: (){
                        Navigator.pushNamed(context, '/DriverRegister');
                      },
                      child: Text('Register', style: TextStyle(fontSize: 20.0)),
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('remember email'),
                    Checkbox(value: rememberEmailFlag, onChanged: (bool? value){
                      setState(() {
                        rememberEmailFlag = value!;

                      });
                    })
                  ],
                ),
                Row(
                  children: [
                    Text('testing mode'),
                    Checkbox(value: testingFlag, onChanged: (bool? value){
                      setState(() {
                        testingFlag = value!;
                      });
                    })
                  ],
                ),

                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ][currentPageIndex]
  );
}
}
