import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../user/user.dart';
import '../widget/appbar_widget.dart';

class EditImagePage extends StatefulWidget {
  final User user;
  const EditImagePage({Key? key, required this.user}) : super(key: key);

  @override
  State<EditImagePage> createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  setUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('user', json.encode(widget.user));
  }

  void updateUserValue(String image) {
    setState(() {
      widget.user.image = image;
      setUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    navigate() {
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            width: 330,
            child: Text(
              "Upload a photo of yourself:",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 20),
          //   child: SizedBox(
          //     width: 330,
          //     child: GestureDetector(
          //       onTap: () async {
          //         final image = await ImagePicker()
          //             .pickImage(source: ImageSource.gallery);

          //         if (image == null) return;

          //         final location = await getApplicationDocumentsDirectory();
          //         final name = basename(image.path);
          //         final imageFile = File('${location.path}/$name');
          //         final newImage = await File(image.path).copy(imageFile.path);
          //         setState(() {
          //           // widget.user = widget.user.copy(image: newImage.path);
          //           // user.image = newImage.path;
          //           updateUserValue(newImage.path);
          //         });
          //       },
          //       child: widget.user.image.contains('https')
          //           ? Image.network(widget.user.image)
          //           : Image.file(File(widget.user.image)),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 330,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    navigate();
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
