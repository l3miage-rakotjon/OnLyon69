import 'package:flutter/material.dart';
import 'package:ok/models/user.dart';

class ProfilePage extends StatelessWidget{
  final User user;

  const ProfilePage({
    super.key,
    required this.user,
});

  @override
  Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(
        title: const Text("Profile"),
        actions: [

        IconButton(
        onPressed:(){
    Navigator
        .of(context)
        .pop();
    print("Retour");
    },
        icon: const Icon(Icons.person)
    )
    ]),);
    //Placeholder();
  }
}