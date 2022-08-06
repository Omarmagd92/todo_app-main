import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'layout/todoapp/todo_layout.dart';


void main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ar', 'EG'), // English, no country code
        // Spanish, no country code
      ],
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}

