import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  File _image;
  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Add item"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: w,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _separator(),
                _imageBlock(
                  width: w,
                  height: h
                ),

                _separator(),
                _buttons(
                  width: w,
                  height: h
                ),

                _separator(),

              ],
            ),
          ),
        ),
      ),
    );
  }

  _separator()=>SizedBox(height: 20);

  _imageBlock({width, height}){
    return SizedBox(
      width: width*0.8,
      height: width*0.55,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: _image == null?
        Image(
          image: AssetImage('assets/image.png'),
          fit: BoxFit.contain,
        )
        :
        Image.file(_image, fit: BoxFit.cover,),
      ),
    );  
  }

  _buttons({width, height}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: (width-20)/2,
          child: FlatButton(
            onPressed: () => getImage(ImageSource.gallery),
            child: Row(
              children: [
                Icon(Icons.photo),
                Expanded(child: Text(" Image from gallery"))
              ],
            )
          ),
        ),
        SizedBox(width: 20),
        SizedBox(
          width: (width-20)/2,
          child: FlatButton(
            onPressed: () => getImage(ImageSource.camera),
            child: Row(
              children: [
                Icon(Icons.camera_alt),
                Expanded(child: Text(" Image from camera")),
              ],
            )
          ),
        )
      ],
    );
  }

}