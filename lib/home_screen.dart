import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storageInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: StreamBuilder(
          stream: storageInstance
              .collection("users")
              .snapshots(), // this takes a snapshot of all the data in the db
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final userData = snapShot.data?.docs; // userData is an array

            if (userData!.isEmpty) {
              return const Center(child: Text("No data available"));
            }

            return ListView.builder(
                itemCount: userData.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Row(
                      children: [
                        Text(
                          "E-mail Address : ${userData[index]["E-mail Address"]}",
                          style: const TextStyle(fontSize: 11),
                        ),
                        const SizedBox(width: 10),
                        Text("Password : ${userData[index]["Password"]}",
                            style: const TextStyle(fontSize: 11))
                      ],
                    ),
                  );
                });
          }),
    );
  }
}

// .collections() is used to get the path of the stored data
// snapShot tells us if connection was successfull