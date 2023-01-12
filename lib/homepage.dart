import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? file;
  ImagePicker image = ImagePicker();

  checkPermission(){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Permission is Recommended.")));
  }

  requestFilePermission() async {
    PermissionStatus storageStatus = await Permission.storage.request();

    if (storageStatus == PermissionStatus.granted) {
      var img = await image.getImage(source: ImageSource.gallery);

      setState(() {
        file = File(img!.path);
      });
    }
    if (storageStatus == PermissionStatus.denied) {
      checkPermission();
    }

    if (storageStatus == PermissionStatus.permanentlyDenied) {

      openAppSettings();
    }
  }

  @override
  void initState() {
    requestFilePermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Select Image")
        ),
        body: Column(
          children: [
            const Padding(padding: EdgeInsetsDirectional.only(top: 20)),
            Container(
                height: 500,
                width: 400,
                color: Colors.white24,
                child: file == null
                    ? const Icon(Icons.image, size:50,) : Image.file(
                    file!,
                    fit: BoxFit.contain
                )
            ),
            const Spacer(),
            SizedBox(
              child: Center(
                  child: Padding(padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(onPressed: () {
                      requestFilePermission();
                    },
                      child: const Text("Select Image"),
                    )
                    ,)
              ),
            )
          ],
        )
    );
  }
}


