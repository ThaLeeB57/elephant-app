import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tp_flutter/providers/tasks_provider.dart';
import 'Elephant_App.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL', fallback: 'null'),
    // anonKey: dotenv.get('SUPABASE_ANON_KEY', fallback: 'null'),
    anonKey: dotenv.get('SUPABASE_PRIVATE_KEY', fallback: 'null'),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TasksProvider()..init(),
        ),
      ],
      child: ElephantApp(),
    ),
  );
}
