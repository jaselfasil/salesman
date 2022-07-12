import 'package:path_provider/path_provider.dart';
import 'package:salesman/Model/UserModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DbHelper {
  static Database _db;
  static const DB_Name = "salesMan.db";
  static const String Table_Login = "login";
  static const String Table_User = "user";
  static const int Version = 1;

  static const String C_UName = 'u_name';
  static const String C_Password = 'u_password';

  static const String C_UserID = 'user_id';
  static const String C_UserName = 'user_name';
  static const String C_Dob = 'dob';
  static const String C_Salary = 'salary';
  static const String C_Nationality = 'nationality';
  static const String C_Gender = 'gender';
  static const String C_Photo = 'photo_name';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_Name);
    var db = await openDatabase(path, version: Version, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int intVersion) async {
    await db.execute("CREATE TABLE $Table_User ("
        " $C_UserID INTEGER PRIMARY KEY AUTOINCREMENT, "
        " $C_UserName TEXT, "
        " $C_Dob TEXT,"
        " $C_Salary TEXT, "
        " $C_Nationality TEXT,"
        " $C_Gender TEXT,"
        " $C_Photo TEXT"
        ")");

    await db.execute("CREATE TABLE $Table_Login ("
        " $C_UName TEXT, "
        " $C_Password TEXT"
        ")");
  }

  Future<int> saveData(UserModel user) async {
    var dbClient = await db;
    var res = await dbClient.insert(Table_User, user.toMap());
    return res;
  }

  Future<int> insertUser() async {
    var dbClient = await db;
    var res = await dbClient.insert(
        Table_Login, {'u_name': "JaselFasil", 'u_password': "test1234"});
    return res;
  }

  Future<LoginModel> getLoginUser(String userId, String password) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $Table_Login WHERE "
        "$C_UName = '$userId' AND "
        "$C_Password = '$password'");

    if (res.length > 0) {
      return LoginModel.fromMap(res.first);
    }

    return null;
  }
  Future<List<UserModel>> getUserData() async {
    List<UserModel> userList = [];
    var dbClient = await db;
    List<Map> res = await dbClient.query(DbHelper.Table_User);
    res.forEach((row) {
      userList.add(UserModel.fromMap(row));
    });

    return userList;
  }
}
