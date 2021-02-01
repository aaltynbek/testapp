import 'package:sembast/sembast.dart';
import 'package:testapp/models/item_model.dart';
import 'DatabaseSetup.dart';

class ItemsDB {
  static const String folderName = "Items";
  final _itemsFolder = intMapStoreFactory.store(folderName);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insertItem(Item item) async {
    await _itemsFolder.add(await _db, item.toJson());
    print('$item Inserted successfully !!');
  }

  Future updateOrInsert(Item item) async {
    await _itemsFolder
        .record(int.parse('${item.itemId}'))
        .put(await _db, item.toJson());
    print("${item.name} ${item.itemId} is inserted");
  }

  Future insertItems(List<Item> items) async {
    for(Item item in items) {
      await _itemsFolder
        .record(int.parse('${item.itemId}'))
        .put(await _db, item.toJson());
    }

    print('$items Inserted successfully !!');
  }

  Future<List<Item>> getAllItems() async {
    final recordSnapshot = await _itemsFolder.find(await _db);
    return recordSnapshot.map((snapshot) {
      final items = Item.fromJson(snapshot.value);
      return items;
    }).toList().reversed.toList();
  }

  Future<List<Item>> getAllSortedByTime() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('time', false, false),
    ]);

    final recordSnapshots = await _itemsFolder.find(
      await _db,
      finder: finder,
    );

    // Making a List<Item> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final items = Item.fromJson(snapshot.value);
      return items;
    }).toList();
  }

  Future deleteItem(Item item) async {
    print("Deleted ${item.name} ${item.itemId} data from local db");
    await _itemsFolder.record(int.parse('${item.itemId}')).delete(await _db);
  }

  Future deleteAll() async {
    print("Deleted all data from local db");
    await _itemsFolder.delete(await _db);
  }
}
