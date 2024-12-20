import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/states.dart';

DateTime now = DateTime.now();
String currentDate = DateFormat('MMMM d, yyyy').format(now);
String currentDay = DateFormat('EEEE').format(now);

Widget defualtFormfeild({
  required TextEditingController controller,
  required TextInputType type,
  required BuildContext context,
  void Function(String)? onSubmit,
  void Function(String)? onChange,
  required String? Function(String?) valid,
  required String label,
  required IconData prefix,
  IconData? sufix,
  bool isPassword = false,
  void Function()? onPressed,
  void Function()? ontap,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        onFieldSubmitted: onSubmit,
        onChanged: onChange,
        onTap: ontap,
        validator: valid,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[300]
                : Colors.grey[700],
          ),
          prefixIcon: Icon(
            prefix,
            color: Colors.deepOrange,
          ),
          suffixIcon: sufix != null
              ? IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    sufix,
                    color: Colors.deepOrange,
                  ),
                )
              : null,
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[700]!
                  : Colors.grey[300]!,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.deepOrange,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        obscureText: isPassword,
      ),
    );

Widget BuildTaskItem(Map model, BuildContext context) => Dismissible(
      key: Key(model['id'].toString()),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 32,
        ),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.green.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.check_circle_outline,
          color: Colors.white,
          size: 32,
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Delete task
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: const Text("Delete Task"),
                content:
                    const Text("Are you sure you want to delete this task?"),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  TextButton(
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              );
            },
          );
        } else {
          // Mark as completed
         if(model['status'] == 'new'){
           return true;
         }else {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: const Text('Task Already completed'),
               behavior: SnackBarBehavior.floating,
               backgroundColor: Colors.green.shade400,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(10),
               ),
               duration: const Duration(seconds: 2),
             ),
           );
            return false;
         }
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Handle delete using Cubit
          TodoCubit.get(context).deleteDatabase(model['id']);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Task deleted'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.red.shade400,
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          TodoCubit.get(context).updateData(
            status: 'done',
            id: model['id'],
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Task completed'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
          // Handle complete

        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF2C2C2C)
              : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFF7043), // Deep Orange lighter
                    Color(0xFFFF5722), // Deep Orange primary
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepOrange.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${model['time']}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Colors.grey[700],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${model['date']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey[700],
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );

Widget BuildTasksScreen() {
  return  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Hello Friend👋'),
              const Spacer(),
              ThemeSwitcher(
                builder: (context) => IconButton(
                  icon: Icon(
                    Theme.of(context).brightness == Brightness.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  onPressed: () async {
                    final switcher = ThemeSwitcher.of(context);
                    final prefs = await SharedPreferences.getInstance();
                    final isDark =
                        Theme.of(context).brightness == Brightness.dark;

                    switcher.changeTheme(
                      theme: isDark ? lightTheme : darkTheme,
                    );
                    await prefs.setBool('isDark', !isDark);
                  },
                ),
              ),
            ],
          ),
          const Text(
            'Ready to do your Daily Tasks??',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Today\'s '),
              Text(
                currentDay,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange),
              )
            ],
          ),
          Text(
            currentDate,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                const SizedBox(width: 90),
                const CircleAvatar(
                  radius: 2,
                  backgroundColor: Colors.black,
                ),
                Container(
                  color: Colors.black,
                  height: 1.5,
                  width: 260,
                )
              ],
            ),
          ),
          const Row(
            children: [
              Text(
                'Ongoing',
                style:
                TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Icon(
                Icons.task,
                color: Colors.deepOrange,
                size: 30,
              )
            ],
          ),
        ],
      ),
    ],
  );
}