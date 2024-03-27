import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carpooling_app/main.dart';

class DriverRegisterPage extends StatefulWidget {
  const DriverRegisterPage({Key? key}) : super(key: key);

  @override
  State<DriverRegisterPage> createState() => _DriverRegisterPageState();
}

class _DriverRegisterPageState extends State<DriverRegisterPage> {
  String carType = "";
  String licencePlate = "";
  String email = "";
  String password = "";
  String firstname = "";
  String lastname = "";
  String confirmPass = "";
  String phone = "";

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
              SizedBox(height: 20,),
              Text(
                "Driver Register",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700
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
                      "Car Type:",
                      style: TextStyle(fontSize: 20)
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 220,
                      height: 50,
                      child: TextField(
                        onChanged: (value){
                          carType = value;
                        },
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "ex: kia cerato",
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [

                  Text(
                      "License Number:",
                      style: TextStyle(fontSize: 20)
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 150,
                      height: 50,
                      child: TextField(
                        onChanged: (value){
                          licencePlate = value;
                        },
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "ex: ب م ي 287",
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [

                  Text(
                      "Phone Number:",
                      style: TextStyle(fontSize: 20)
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 150,
                      height: 50,
                      child: TextField(
                        onChanged: (value){
                          phone = value;
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
                          labelText: "ID@eng.asu.edu.eg",
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
                      if(phone.isEmpty || password.isEmpty || confirmPass.isEmpty || firstname.isEmpty || lastname.isEmpty || email.isEmpty || carType.isEmpty || licencePlate.isEmpty){
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
                              auth.currentUser?.updateDisplayName(firstname+' '+lastname);
                              final driver = <String, dynamic>{
                                'first name': firstname,
                                'last name': lastname,
                                'license number': licencePlate,
                                'car type': carType,
                                'email': email,
                                'phone number': phone
                              };
                              await db.collection('drivers').doc(email).set(driver);
                              await Future.delayed(const Duration(seconds: 2));
                              print(auth.currentUser);

                              Navigator.pushNamedAndRemoveUntil(context, '/DriverRides', (route) => false);
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
