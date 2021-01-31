import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testapp/models/item_model.dart';

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
        actions: [
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: (){
              var name = _nameController.text;
              var description = _descriptionController.text;
              var date = DateTime.now().millisecondsSinceEpoch.toString(); 
              var id = "10100";
              var image = _image.path;
              Item newItem = Item(
                itemId: id, 
                name: name, 
                description: description,
                time: date,
                image: image
              );
              Navigator.of(context).pop(newItem);
            }
          )
        ], 
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
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
                  _nameField(),

                  _separator(),
                  _descriptionField()

                ],
              ),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: (width-20)/2,
          child: TextButton(
            onPressed: () => getImage(ImageSource.gallery),
            child: Row(
              children: [
                Icon(Icons.photo),
                Expanded(child: Text(" Image from gallery"))
              ],
            )
          ),
        ),
        _separator(),
        SizedBox(
          width: (width-20)/2,
          child: TextButton(
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

  Widget _nameField(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.grey),
        child: TextField(
          controller: _nameController,
          // cursorColor: greyColor2,
          decoration: InputDecoration(
            hintText: 'Name',
            labelText: 'Name',
            contentPadding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 13.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }

  Widget _descriptionField(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.grey),
        child: TextField(
          controller: _descriptionController,
          decoration: InputDecoration(
            hintText: 'Description',
            labelText: 'Description',
            contentPadding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 13.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }

}