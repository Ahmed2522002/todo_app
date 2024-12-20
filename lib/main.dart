import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/layout/home_layout.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/cubit.dart';

import 'componants/bloc_observer_class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  
  final prefs = await SharedPreferences.getInstance();
  final bool isDark = prefs.getBool('isDark') ?? true;
  
  runApp(MyApp(isDark: isDark, prefs: prefs));
}

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.deepOrange,
  scaffoldBackgroundColor: const Color(0xFF1E1E1E),
  colorScheme: const ColorScheme.dark(
    primary: Colors.deepOrange,
    secondary: Colors.deepOrangeAccent,
    surface: Color(0xFF2C2C2C),
    background: Color(0xFF1E1E1E),
    error: Colors.redAccent,
  ),
  appBarTheme: const AppBarTheme(
    titleSpacing: 20.0,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    backgroundColor: Color(0xFF2C2C2C),
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
  ),
  cardTheme: const CardTheme(
    color: Color(0xFF2C2C2C),
    elevation: 4.0,
    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.deepOrange,
    foregroundColor: Colors.white,
    elevation: 6.0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.deepOrange,
    unselectedItemColor: Colors.grey[400],
    elevation: 8.0,
    backgroundColor: const Color(0xFF2C2C2C),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2C2C2C),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey[700]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey[700]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Colors.deepOrange),
    ),
    labelStyle: TextStyle(color: Colors.grey[400]),
    hintStyle: TextStyle(color: Colors.grey[600]),
  ),
  textTheme: TextTheme(
    displayLarge: const TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displayMedium: const TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displaySmall: const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontSize: 16.0,
      color: Colors.grey[300],
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      color: Colors.grey[300],
    ),
  ),
  dividerTheme: DividerThemeData(
    color: Colors.grey[700],
    thickness: 1.0,
  ),
);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.deepOrange,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme.light(
    primary: Colors.deepOrange,
    secondary: Colors.deepOrangeAccent,
    surface: Colors.white,
    background: Colors.white,
    error: Colors.redAccent,
  ),
  appBarTheme: const AppBarTheme(
    titleSpacing: 20.0,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.deepOrange,
    unselectedItemColor: Colors.grey,
    elevation: 8.0,
    backgroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 16.0,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      color: Colors.black,
    ),
  ),
);

class MyApp extends StatefulWidget {
  final bool isDark;
  final SharedPreferences prefs;
  
  const MyApp({super.key, required this.isDark, required this.prefs});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDark;

  @override
  void initState() {
    super.initState();
    isDark = widget.isDark;
  }

  void toggleTheme() async {
    setState(() {
      isDark = !isDark;
    });
    await widget.prefs.setBool('isDark', isDark);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: isDark ? darkTheme : lightTheme,
      builder: (_, myTheme) {
        return BlocProvider(
          create: (context) => TodoCubit()..CreateDB(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: myTheme,
            home: ThemeSwitchingArea(
              child: Builder(
                builder: (context) => HomeScreen(),
              ),
            ),
          ),
        );
      },
    );
  }
}
