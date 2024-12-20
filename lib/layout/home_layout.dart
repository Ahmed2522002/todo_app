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
  HomeScreen({Key? key}) : super(key: key);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {
        print("State changed to: ${state.runtimeType}");
      },
      builder: (context, state) {
        print("Current state: ${state.runtimeType}");

        TodoCubit todoCubit = TodoCubit.get(context);

        return Scaffold(
          key: scaffoldKey,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  titleController.text = '';
                  timeController.text = '';
                  dateController.text = '';
                  Navigator.pop(context);
                  todoCubit.changeBottomSheetSt(
                      isShow: false, icon: Icons.edit);
                }
              } else {
                scaffoldKey.currentState
                    ?.showBottomSheet(
                      (context) => Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                          bottom: 40,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 40,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Text(
                              'Add New Task',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Form(
                              key: formkey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defualtFormfeild(
                                    context: context,
                                    controller: titleController,
                                    type: TextInputType.text,
                                    valid: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This field must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task Title',
                                    prefix: Icons.title,
                                  ),
                                  defualtFormfeild(
                                    context: context,
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
                                    prefix: Icons.access_time_rounded,
                                  ),
                                  defualtFormfeild(
                                    context: context,
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
                                    prefix: Icons.calendar_today_outlined,
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (formkey.currentState?.validate() ?? false) {
                                          todoCubit.InsertIntoDB(
                                            title: titleController.text,
                                            date: dateController.text,
                                            time: timeController.text,
                                          );
                                          titleController.text = '';
                                          timeController.text = '';
                                          dateController.text = '';
                                          Navigator.pop(context);
                                          todoCubit.changeBottomSheetSt(
                                            isShow: false,
                                            icon: Icons.edit,
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepOrange,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: const Text(
                                        'Add Task',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                    )
                    .closed
                    .then((value) {
                  todoCubit.changeBottomSheetSt(
                      isShow: false, icon: Icons.edit);
                });
                todoCubit.changeBottomSheetSt(isShow: true, icon: Icons.add);
              }
            },
            child: Icon(
              todoCubit.fabIcon,
              color: Colors.white,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done Tasks'),
            ],
            currentIndex: todoCubit.currentIndex,
            onTap: todoCubit.changeIndex,
            type: BottomNavigationBarType.fixed,
          ),
          body: todoCubit.currentIndex == 0
              ? TasksScreen()
              : const DoneTaskScreen(),
        );
      },
    );
  }
}
