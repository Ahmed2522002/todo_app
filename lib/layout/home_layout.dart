import 'dart:ffi';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';
import 'package:todo_app/screens/done_task_screen.dart';
import 'package:todo_app/screens/tasks_screen.dart';

import '../componants/constants.dart';
import '../componants/shard_componant.dart';

class HomeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  // void initState() {
  //   super.initState();
  //   initializeDatabase();
  // }
  //
  // Future<void> initializeDatabase() async {
  //   await CreateDB();
  //   setState(() {});
  // }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit()..CreateDB(),
      child: BlocConsumer<TodoCubit, TodoStates>(
        listener: (context, state) {
          print("State changed to: ${state.runtimeType}");
        },
        builder: (context, state) {
          print("Current state: ${state.runtimeType}");

          TodoCubit todoCubit = TodoCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                print("FAB fallback action");
                print("FAB pressed!");

                if (todoCubit.isBottomSheetShown) {
                  if (formkey.currentState?.validate() ?? false) {
                    todoCubit.InsertIntoDB(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text);
                    // await InsertIntoDB(
                    //   title: titleController.text,
                    //   date: dateController.text,
                    //   time: timeController.text,
                    // );
                    // Navigator.pop(context);
                    // isBottomSheetShown = false;
                    Navigator.pop(context);
                    todoCubit.changeBottomSheetSt(
                        isShow: false, icon: Icons.edit);
// setState(() {
//   fabIcon = Icons.edit;
// });
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) => Container(
                          padding: const EdgeInsets.all(15),
                          child: Form(
                            key: formkey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defualtFormfeild(
                                    controller: titleController,
                                    type: TextInputType.text,
                                    valid: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This field must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task Title',
                                    prefix: Icons.task),
                                const SizedBox(
                                  height: 15,
                                ),
                                defualtFormfeild(
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    ontap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        if (value != null) {
                                          timeController.text =
                                              value.format(context).toString();
                                        }
                                      });
                                    },
                                    valid: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This field must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task Time',
                                    prefix: Icons.watch_later),
                                const SizedBox(
                                  height: 15,
                                ),
                                defualtFormfeild(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    ontap: () {
                                      showDatePicker(
                                        context: context,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2026-05-05'),
                                      ).then((value) {
                                        if (value != null) {
                                          dateController.text =
                                              DateFormat.yMMMd().format(value);
                                        }
                                      });
                                    },
                                    valid: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This field must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task Date',
                                    prefix: Icons.calendar_today)
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    todoCubit.changeBottomSheetSt(
                        isShow: false, icon: Icons.edit);
                  });
                  todoCubit.changeBottomSheetSt(isShow: true, icon: Icons.add);
                }
              },
              backgroundColor: Colors.blue,
              shape: const CircleBorder(),
              child: Icon(
                todoCubit.fabIcon,
                color: Colors.white,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            backgroundColor: const Color(0xffd1d9e6),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: const Color(0xffd1d9e6),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),
                    label: 'Done Tasks'),
              ],
              currentIndex: todoCubit.currentIndex,
              onTap: todoCubit.changeIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue,
            ),
            body: todoCubit.currentIndex == 0
                ? const TasksScreen()
                : const DoneTaskScreen(),
          );
        },
      ),
    );
  }

// Future InsertIntoDB({
//   required String title,
//   required String date,
//   required String time,
// }) async {
//   return await database?.transaction((txn) async {
//     txn
//         .rawInsert(
//             'INSERT INTO Test(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
//         .then((value) {
//       print('inserted successfully $value inserted');
//     }).catchError((error) {
//       print('inserted error${error.toString()}');
//     });
//     return null;
//   });
//
//   // database?.transaction((txn)  {
//   //    txn.rawInsert(
//   //       'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)')
//   //        .then((onValue){}).catchError((onError){});
//   //    return null;
//   //
//   // });
// }
}
