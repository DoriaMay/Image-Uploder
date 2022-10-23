import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/imageUpload/image_upload.dart';
import 'package:email_password_login/imageUpload/show_upload.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100,
                child: Image.asset("assets/logo.png", fit: BoxFit.contain),
              ),
              const Text(
                "Welcome Back",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${loggedInUser.firstName} ${loggedInUser.secondName}",
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "${loggedInUser.email}",
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "${loggedInUser.uid}",
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ImageUpload(userId: loggedInUser.uid)));
                  },
                  child: const Text("Upload Image")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ShowUploads(userId: loggedInUser.uid)));
                  },
                  child: const Text("Show Image")),
            ],
          ),
        ),
      ),
    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  _appBar() {
    // getting the size of our app bar
    // we will get the height
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
        child: AppBar(
          title: const Text("Profile"),
          actions: [
            IconButton(
              onPressed: () {
                logout(context);
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        preferredSize: Size.fromHeight(appBarHeight));
  }
}
