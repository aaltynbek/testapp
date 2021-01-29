import 'dart:convert';

List<Item> itemFromJson(String str) =>
    List<Item>.from(json.decode(str).map((x) => Item.fromJson(x)));

List<Item> itemFromList(List list) =>
    List<Item>.from(list.map((x) => Item.fromJson(x)));

String itemToJson(List<Item> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Item {
  Item({
    this.itemId,
    this.name,
    this.image,
    this.description,
    this.time
  });
  String itemId;
  String name;
  String image;
  String description;
  String time;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    itemId: json["itemId"],
    name: json["name"],
    image: json["image"],
    description: json["description"],
    time: json["time"]
  );
  Map<String, dynamic> toJson() => {
    "itemId": itemId,
    "name": name,
    "image": image,
    "description": description,
    "time": time
  };
}