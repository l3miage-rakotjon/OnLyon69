import 'package:flutter/material.dart';
import 'package:ok/models/user.dart';

import '../pages/profilepage.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
        actions: [

          IconButton(
              onPressed:(){
                Navigator
                    .of(context)
                    .push(MaterialPageRoute(builder:
                    (context) => ProfilePage(user:User("Jo", "Jo", "")),
                ));
                print("Profile");
              },
              icon: const Icon(Icons.person)),
          IconButton(
              onPressed:(){
                print("Settings");
              },
              icon: const Icon(Icons.settings))
        ],
      ),

      body: Column(
        children: [
          Center(
            child: Container(
              padding:  EdgeInsets.all(20.0),
              child:  Image.asset("assets/images/icon.jpg")
            ),
          ),
           Container(
            padding: EdgeInsets.all(20),
            child: Text("Bienvenue sur ma page d'accueil",
            style: TextStyle(
              fontSize: 20.0
            ))
          )
        ],
      )
    );
  }
}
