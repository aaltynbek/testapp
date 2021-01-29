import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/screens/list_screen.dart';
import 'package:testapp/services/theme_manager.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => new ThemeNotifier(),
      child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => MaterialApp(
        title: 'Test Application',
        theme: theme.getTheme(),
        home: ListScreen(),
      )
    );
  }
}
