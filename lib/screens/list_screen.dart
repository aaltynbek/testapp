import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:testapp/db/items_db.dart';
import 'package:testapp/models/item_model.dart';
import 'package:testapp/screens/add_item_screen.dart';
import 'package:testapp/screens/item_screen.dart';
import 'package:testapp/services/network_services.dart';
import 'package:testapp/services/storage_manager.dart';
import 'package:testapp/services/theme_manager.dart';
import 'package:testapp/widgets/progress_indicator.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  var db = ItemsDB();
  List<Item> itemsList = [];
  bool isLoading = false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _getItems();
  }

  _getItems() async {
    StorageManager.save('id', "12345");
    setState(() {
      isLoading = true;
    });
    await db.getAllItems().then(
      (value) {
        setState(() {
          itemsList = value;
          isLoading = false;
        });
      }
    );
    if(itemsList.isEmpty){
      NetworkServices.getUsers().then((response) async {
        //--- if i will use http://test.php-cd.attractgroup.com/test.json ---
        // final String res = response.body.replaceAll('\\"', '');
        // LineSplitter ls = new LineSplitter();
        // List<String> lines = ls.convert(res);
        // String newStr = '';
        // for (var i = 0; i < lines.length; i++) {
        //   var str = !(i==27 || i == 56 || i ==85)?'${lines[i]}':'",';
        //   newStr = newStr + str;
        // }
        // final resJson = jsonDecode(newStr);
        //--- if i will use http://test.php-cd.attractgroup.com/test.json ---

        final resJson = jsonDecode(response.body);
        await db.insertItems(itemFromList(resJson));
        setState(() {
          itemsList = itemFromList(resJson);
          isLoading = false;
        });
      });
    }
  }
  
  _onRefresh(){
    NetworkServices.getUsers().then((response) async {
      //--- if i will use http://test.php-cd.attractgroup.com/test.json ---
      // final String res = response.body.replaceAll('\\"', '');
      // LineSplitter ls = new LineSplitter();
      // List<String> lines = ls.convert(res);
      // String newStr = '';
      // for (var i = 0; i < lines.length; i++) {
      //   var str = !(i==27 || i == 56 || i ==85)?'${lines[i]}':'",';
      //   newStr = newStr + str;
      // }
      // final resJson = jsonDecode(newStr);
      //--- if i will use http://test.php-cd.attractgroup.com/test.json ---

      final resJson = jsonDecode(response.body);

      await db.insertItems(itemFromList(resJson)).whenComplete(() async {
        await db.getAllItems().then(
          (value) {
            print("refreshed");
            setState(() {
              itemsList = value;
            });
          }
        );
      });
      
      _refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>ThemeNotifier(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("List"),
          leading: Switch(
            value: context.read<ThemeNotifier>().isDarkMode,
            onChanged: (value){
              setState(() {
                context.read<ThemeNotifier>().isDarkMode ? context.read<ThemeNotifier>().setLightMode() : context.read<ThemeNotifier>().setDarkMode();
              });
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add), 
              onPressed: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddItemScreen()),
                );

                if(result is Item){
                  setState(() {
                    itemsList.insert(0, result);
                  });
                }
              }
            )
          ], 
        ),
        body: SafeArea(
          bottom: false,
          child: isLoading? 
          CustomProgressIndicator()
          :
          SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            controller: _refreshController,
            onRefresh: _onRefresh,
            header: WaterDropHeader(
              complete: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.done,
                    color: Colors.grey,
                  ),
                  Container(
                    width: 15.0,
                  ),
                  Text('Обновление завершено',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            child: ListView.separated(
              padding: EdgeInsets.only(top: 20),
              itemCount: itemsList.length,
              itemBuilder: (context, i) => _item(i),
              separatorBuilder: (context, i) => SizedBox(height:20),
            ),
          ),
        ),
      ),
    );
  }

  _item(i){
    return Dismissible(
      key: Key(itemsList[i].itemId),
      onDismissed: (direction) async {
        await db.deleteItem(itemsList[i]);
        setState(() {
          itemsList.removeAt(i);
        });
      },
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width*0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset.zero,
              ),
            ],
          ),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () async{
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemScreen(items: itemsList, itemIndex: i)),
                );

                print("Edit result is $result");
              },
              child: _itemBody(itemsList[i]),
            ),
          ),
        ),
      )
    );
  }

  _itemBody(Item item){
    final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(item.time));
    final format = DateFormat('dd - MMMM - y HH:mm');
    final date = format.format(dateTime.toLocal());

    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image(
              image: _image(item.image),
              width: 120,
              height: 85,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 15),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                
                Text(
                  "${item.name}",
                  maxLines: 1,
                  style: Theme.of(context).primaryTextTheme.bodyText1,
                ),

                SizedBox(height: 8),
                Text(
                  "${item.description}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey
                  ),
                ),

                SizedBox(height: 8),
                Text(
                  "$date",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _image(String image){
    return !Uri.parse(image).isAbsolute?
    FileImage(File(image))
    :
    CachedNetworkImageProvider(image);
  }

}