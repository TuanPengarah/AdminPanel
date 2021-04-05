import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

const String DB1_NAME = 'CashFlow.db';
const int DB1_VERSION = 1;
const String _tableName = 'cashflow';
const String _tableList = 'pricelist';

class DBProvider {
  static final columnId = '_id';
  static final columnPrice = 'cash';
  static final columnName = 'spareparts';
  static final columnTarikh = 'tarikh';
  static final dahBayar = 'dahBayar';
  static final columnModel = 'Model';
  static final columnPriceSupplier = 'hargasupplier';
  static final columnSupplier = 'supplier';
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/$DB1_NAME';
    return await openDatabase(path, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE $_tableName (
          $columnId INTEGER PRIMARY KEY autoincrement, $columnPrice INTEGER 
          NO NULL, $columnName TEXT, $columnTarikh TEXT NO NULL, $dahBayar 
          INTEGER NO NULL
          )
          ''');
      await db.execute('''
      CREATE TABLE $_tableList (
      id INTEGER PRIMARY KEY autoincrement, price INTEGER NO NULL,
     jenis TEXT NO NULL, tarikh TEXT NO NULL, model TEXT 
     NO NULL, hargasupplier INTEGER NO NULL, supplier TEXT NO NULL
      )
      ''');
    }, version: DB1_VERSION);
  }

  Future<int> insert(CashFlow cashflow) async {
    final db = await database;
    return await db.insert(_tableName, cashflow.toMap());
  }

  Future<List> calculateTotal() async {
    final db = await database;
    var result = await db.rawQuery('SELECT*FROM $_tableName');
    return result.toList();
  }

  Future<List<CashFlow>> queryAll(String orderby) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('$_tableName', orderBy: orderby);
    return List.generate(maps.length, (i) {
      return CashFlow(
        dahBayar: maps[i][dahBayar],
        tarikh: maps[i][columnTarikh],
        id: maps[i][columnId],
        price: maps[i][columnPrice],
        spareparts: maps[i][columnName],
      );
    });
  }

  Future<List<PriceList>> queryAllPL(String orderby, String groupby) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('$_tableList',
        orderBy: orderby, where: 'model LIKE ?', whereArgs: ['%$groupby%']);
    return List.generate(maps.length, (i) {
      return PriceList(
        jenis: maps[i]['jenis'],
        model: maps[i]['model'],
        supplierPrice: maps[i]['hargasupplier'],
        supplier: maps[i]['supplier'],
        id: maps[i]['id'],
        tarikh: maps[i]['tarikh'],
        price: maps[i]['price'],
      );
    });
  }

  Future<int> update(Map<String, dynamic> row) async {
    final db = await database;
    int id = row[columnId];
    return await db
        .update(_tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(_tableName, where: '$columnId = ?', whereArgs: [id]);
  }

//PRICE LIST///
  Future<int> insertPL(PriceList pricelist) async {
    final db = await database;
    return await db.insert(_tableList, pricelist.toMap());
  }

  Future<List> calculateTotalPL() async {
    final db = await database;
    var result = await db.rawQuery('SELECT*FROM $_tableList');
    return result.toList();
  }

  Future<int> updatePL(Map<String, dynamic> row) async {
    final db = await database;
    int id = row[columnId];
    return await db
        .update(_tableList, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deletePL(int id) async {
    final db = await database;
    return await db.delete(_tableList, where: '$columnId = ?', whereArgs: [id]);
  }
}

class CashFlow {
  int id;
  int price;
  String spareparts;
  String tarikh;
  int dahBayar;

  CashFlow(
      {@required this.price,
      @required this.spareparts,
      this.id,
      @required this.tarikh,
      @required this.dahBayar});

  Map<String, dynamic> toMap() {
    return {
      DBProvider.columnPrice: price,
      DBProvider.columnName: spareparts,
      DBProvider.columnTarikh: tarikh,
      DBProvider.dahBayar: dahBayar,
    };
  }
}

class PriceList {
  int id;
  int price;
  int supplierPrice;
  String jenis;
  String tarikh;
  String model;
  String supplier;

  PriceList({
    this.id,
    @required this.price,
    @required this.supplierPrice,
    @required this.jenis,
    @required this.tarikh,
    @required this.model,
    @required this.supplier,
  });

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'jenis': jenis,
      'tarikh': tarikh,
      'model': model,
      'supplier': supplier,
      'hargasupplier': supplierPrice,
    };
  }
}
