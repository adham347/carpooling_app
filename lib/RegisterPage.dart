import 'dart:async';
import 'package:carpooling_app/main.dart';
import 'package:flutter/material.dart';
import 'package:carpooling_app/AvailableRidesPage.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String phone = '';
  String email = "";
  String password = "";
  String firstname = "";
  String lastname = "";
  String confirmPass = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              SizedBox(
                height: 200,
                child: Image(image: AssetImage('assets/carPoolingLogo.png')
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [

                  Text(
                      "First Name:",
                      style: TextStyle(fontSize: 20)
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: TextField(
                        onChanged: (value){
                          firstname = value;
                        },
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter your first name",
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [

                  Text(
                      "Last Name:",
                      style: TextStyle(fontSize: 20)
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: TextField(
                        onChanged: (value){
                          lastname = value;
                        },
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter your last name",
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                      "Email:",
                      style: TextStyle(fontSize: 20)
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 250,
                      height: 50,
                      child: TextField(
                        onChanged: (value){
                          email= value;
                        },
                        style: TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter your email",
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                      "Phone:",
                      style: TextStyle(fontSize: 20)
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 242,
                      height: 50,
                      child: TextField(
                        onChanged: (value){
                          phone= value;
                        },
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "ex: +201123456789",
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                      "Password:",
                      style: TextStyle(fontSize: 20)
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 210,
                      height: 50,
                      child: TextField(
                        onChanged: (value){
                          password = value;
                        },
                        style: TextStyle(fontSize: 20),
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Enter your password",

                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                      "Confirm Pass:",
                      style: TextStyle(fontSize: 20)
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                      width: 183,
                      height: 50,
                      child: TextField(
                        onChanged: (value){
                          confirmPass = value;
                        },
                        style: TextStyle(fontSize: 20),
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Confrim your password"
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  ElevatedButton(
                    onPressed: () async {
                      if(password.isEmpty || confirmPass.isEmpty || firstname.isEmpty || lastname.isEmpty || email.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Fill in all the fields!"))
                        );
                      }else{
                        if(password == confirmPass){
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Creating your account..."))
                          );
                          print(email);
                          print(password);
                          print(firstname+' '+lastname);
                          try {
                            final newUser = await auth.createUserWithEmailAndPassword(
                                email: email, password: password);

                            if (newUser != null) {
                              print(auth.currentUser);
                              final passenger = <String, dynamic>{
                                'first name': firstname,
                                'last name': lastname,
                                'email': email,
                                'phone number': phone
                              };

                              db.collection('passengers').doc(email).set(passenger);
                              auth.currentUser?.updateDisplayName(firstname+' '+lastname);
                              await Future.delayed(const Duration(seconds: 2));
                              print(auth.currentUser);

                              Navigator.pushNamedAndRemoveUntil(context, '/AvailableRides', (route) => false);
                            }
                          } on FirebaseAuthException catch (e) {
                            print(e);
                            if (e.code == 'weak-password') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('The password provided is too weak.'))
                              );
                            } else if (e.code == 'email-already-in-use') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('The account already exists for that email.'))
                              );
                            }

                          } catch (e) {
                            print(e);
                          }
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Passwords doesn't match"))
                          );
                        }
                      }
                    },
                    child: Text('Register', style: TextStyle(fontSize: 20.0)),
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}
