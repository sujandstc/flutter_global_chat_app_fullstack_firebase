import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:globalchat/providers/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Map<String, dynamic>? userData = {};

  var db = FirebaseFirestore.instance;

  TextEditingController nameText = TextEditingController();

  var editProfileForm = GlobalKey<FormState>();
  @override
  void initState() {
    nameText.text = Provider.of<UserProvider>(context, listen: false).userName;
    // TODO: implement initState
    super.initState();
  }

  void updateData() {
    Map<String, dynamic> dataToUpdate = {
      "name": nameText.text,
    };

    db
        .collection("users")
        .doc(Provider.of<UserProvider>(context, listen: false).userId)
        .update(dataToUpdate);

    Provider.of<UserProvider>(context, listen: false).getUserDetails();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: [
          InkWell(
            onTap: () {
              if (editProfileForm.currentState!.validate()) {
                updateData();
                // updating of the data on database
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.check),
            ),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: editProfileForm,
            child: Column(children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name cannot be empty.";
                  }
                },
                controller: nameText,
                decoration: InputDecoration(label: Text("Name")),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
