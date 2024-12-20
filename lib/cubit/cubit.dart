import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/states.dart';

class TodoCubit extends Cubit<TodoStates> {
  //TodoCubit(super.initialState);

  TodoCubit() : super(TodoInitialState());

  static TodoCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  Database? database;
  List<Map> tasks = [];

  void CreateDB() {
    openDatabase('todo.db', version: 1, onCreate: (db, version) {
      print('Database Created');
      db.execute(
          'CREATE TABLE Test (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((_) => print('Table Created'))
          .catchError((error) {
        print('Error creating table: ${error.toString()}');
      });
    }, onOpen: (db) {
      print('Database Opened');
      database = db; // Assign the database here
      getDataFromDB(db).then((value) {
        tasks = value;
        emit(GetDatabaseState());
      });
    }).then((value) {
      database = value;
      print('Database assigned, emitting CreateDatabaseState...');
      emit(CreateDatabaseState());
    }).catchError((error) {
      print('Database error: ${error.toString()}');
    });
  }



  Future InsertIntoDB({
    required String title,
    required String date,
    required String time,
  }) async {
    if (database == null) {
      print("Database is not initialized.");
      return;
    }
    await database!.transaction((txn) async {
      await txn
          .rawInsert(
          'INSERT INTO Test(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print('Inserted successfully: $value');
        emit(InsertDatabaseState());
        getDataFromDB(database).then((value) {
          tasks = value;
          print(tasks);
          emit(GetDatabaseState());
        });
      }).catchError((error) {
        print('Insertion error: ${error.toString()}');
      });
    });
  }

  Future<List<Map>> getDataFromDB(Database? database) async {
    if (database == null) {
      print("Database is null.");
      return [];
    }
    return await database.rawQuery('SELECT * FROM Test');
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheetSt({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(ChangeBottomSheetState());
  }

}
