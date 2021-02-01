import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:testapp/models/item_model.dart';
import 'package:testapp/screens/add_item_screen.dart';

class ItemScreen extends StatelessWidget {
  final List<Item> items;
  final itemIndex;
  const ItemScreen({Key key, this.items, this.itemIndex}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return CarouselSlider.builder(
      options: CarouselOptions(
        height: h,
        viewportFraction: 1,
        initialPage: itemIndex,
        enableInfiniteScroll: true,
        scrollDirection: Axis.horizontal,
      ),
      itemCount: items.length,
      itemBuilder: (context, i, realIndex) {
        return Scaffold(
          appBar: AppBar(
            title: Text(items[i].name),
            actions: [
              IconButton(
                icon: Icon(Icons.edit), 
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddItemScreen(item: items[i])),
                  );
                }
              )
            ],
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _image(items[i].image, height: h, width: w),
                    _body(items[i])
                  ],
                ),
              ),
            ),
          ),
        );
      }, 
    );
  }

  _image(image, {width, height}) {
    return SizedBox(
      height: height/3,
      width: width,
      child: !Uri.parse(image).isAbsolute?
      Image.file(
        File(image),
        fit: BoxFit.cover
      )
      :
      CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
      )
    );
  }

  _body(item) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),


          SizedBox(height: 15),
          Text(
            item.description,
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }

}