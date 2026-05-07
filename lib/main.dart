import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/app_palette.dart';
import 'pages/main_shell.dart';
import 'state/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppState();
  await appState.load();

  runApp(
    ChangeNotifierProvider(
      create: (_) => appState,
      child: const BowwowApp(),
    ),
  );
}

class BowwowApp extends StatelessWidget {
  const BowwowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '강아지 키우기',
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: AppPalette.ivoryBackground,
      ),
      home: const MainShell(),
    );
  }
}
