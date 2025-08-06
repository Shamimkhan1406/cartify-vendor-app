import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  // create an instanse of image picker to handle image picking
  final ImagePicker picker = ImagePicker();
  // initialize a empty list to store selected images
  List<File> images = [];
  // define a function to choose image from gallery
  chooseImage() async{
    // use the picker to choose the image from gallery
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null){
      print('no image is picked');
    }
    else{
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true, // allow the gridview to fit the content
          itemCount: images.length+1, // +1 grid for the add image button
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 1,
          ), itemBuilder: (context, index){
            return index == 0 ? Center(
              child: IconButton(
                onPressed: chooseImage,
                icon: Icon(Icons.add),
              ),
            
            ) 
            : SizedBox(
              width: 50,
              height: 50,
              child: Image.file(images[index-1])
            );
          }
        ),
      ],
    );
  }
}