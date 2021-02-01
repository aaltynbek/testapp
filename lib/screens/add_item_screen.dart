import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testapp/db/items_db.dart';
import 'package:testapp/models/item_model.dart';
import 'package:testapp/screens/list_screen.dart';
import 'package:testapp/services/network_services.dart';
import 'package:testapp/services/storage_manager.dart';
import 'package:testapp/widgets/progress_indicator.dart';

class AddItemScreen extends StatefulWidget {
  final Item item;
  const AddItemScreen({Key key, this.item}) : super(key: key);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  File _image;
  final picker = ImagePicker();
  var db = ItemsDB();
  var isEdit = false;
  Item currentItem;
  bool isLoading = false;

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        if(isEdit){
          setState(() {
            currentItem.image = pickedFile.path;
          });
        }
      } else {
        print('No image selected.');
      }
    });
  }
  
  @override
  void initState() {
    super.initState();
    _checkEdit(widget.item);
  }

  _checkEdit(Item item){
    if(item != null){
      setState(() {
        currentItem = item;
        _nameController.text = item.name;
        _descriptionController.text = item.description;
        isEdit = true;
      });
    }
  }

  _itemCheck({json}){
    StorageManager.read('id').then((savedId) async {
      var name = _nameController.text;
      var description = _descriptionController.text;
      var date = DateTime.now().millisecondsSinceEpoch.toString(); 
      var id = isEdit? currentItem.itemId : (int.parse(savedId)+1).toString();
      var image = isEdit?currentItem.image:"http://sxdm.kz${json['path']}";
      Item newItem = Item(
        itemId: id, 
        name: name, 
        description: description,
        time: date,
        image: image
      );

      if(!isEdit) StorageManager.save('id', id);

      setState(() {
        isLoading = false;
      });

      await db.updateOrInsert(newItem).whenComplete(() => 
        isEdit?
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListScreen()),
        )
        :
        Navigator.of(context).pop(newItem)
      );  
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit?"Edit item":"Add item"),
        actions: [
          IconButton(
            icon: Icon(Icons.save), 
            onPressed: () async {
              bool isEmptyImage = isEdit?false:_image == null?true:false;
              if(_nameController.text.isEmpty || _descriptionController.text.isEmpty || isEmptyImage){
                _showMyDialog();
                return;
              }
              setState(() {
                isLoading = true;
              });

              isEdit?_itemCheck():
              NetworkServices.uploadFile(_image.path).then((response) async {
                Map<String, dynamic> json = jsonDecode(response);
                print("image uploaded $json");
                if(json.containsKey('path')){
                  _itemCheck(json: json);
                }
              });
              
            }
          )
        ], 
      ),
      body: Stack(
        children: [
          SafeArea(
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

          isLoading?CustomProgressIndicator():SizedBox()
        ],
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
        child: _image == null? isEdit?
        !Uri.parse(currentItem.image).isAbsolute?
          Image.file(
            File(currentItem.image),
            fit: BoxFit.cover
          )
          :
          CachedNetworkImage(
            imageUrl: currentItem.image,
            fit: BoxFit.cover,
          )
        :
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Error'),
          content: Text('One of the required elements is empty'),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}