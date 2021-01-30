import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:testapp/models/item_model.dart';
import 'package:testapp/screens/add_item_screen.dart';
import 'package:testapp/services/network_services.dart';
import 'package:testapp/services/theme_manager.dart';
import 'package:testapp/widgets/progress_indicator.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {

  bool _isDark = false;
  List<Item> itemsList = [];
  bool isLoading = false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();    
    _getItems();
  }

  _getItems() {
    setState(() {
      isLoading = true;
    });
    NetworkServices.getUsers().then((response) {
      final String res = response.body.replaceAll('\\"', '');
      LineSplitter ls = new LineSplitter();
      List<String> lines = ls.convert(res);
      String newStr = '';
      for (var i = 0; i < lines.length; i++) {
        var str = !(i==27 || i == 56 || i ==85)?'${lines[i]}':'",';
        newStr = newStr + str;
      }
      final resJson = jsonDecode(newStr);
      setState(() {
        itemsList = itemFromList(resJson);
        isLoading = false;
      });
    });
  }
  
  _onRefresh(){
    NetworkServices.getUsers().then((response) {
      final String res = response.body.replaceAll('\\"', '');
      LineSplitter ls = new LineSplitter();
      List<String> lines = ls.convert(res);
      String newStr = '';
      for (var i = 0; i < lines.length; i++) {
        var str = !(i==27 || i == 56 || i ==85)?'${lines[i]}':'",';
        newStr = newStr + str;
      }
      final resJson = jsonDecode(newStr);
      setState(() {
        itemsList = itemFromList(resJson);
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
            value: _isDark,
            onChanged: (value){
              setState(() {
                _isDark ? context.read<ThemeNotifier>().setLightMode() : context.read<ThemeNotifier>().setDarkMode();
                _isDark = value;
              });
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add), 
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddItemScreen()),
                );
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
      onDismissed: (direction){
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
              onTap: (){

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
              image: CachedNetworkImageProvider(item.image),
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

}