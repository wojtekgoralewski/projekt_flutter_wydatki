import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projekt/app/config/color_schemes.dart';
import 'package:projekt/presentation/pages/auth_page/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:projekt/presentation/pages/extracted_history_page.dat/extracted_history_page.dart';
import 'package:projekt/presentation/pages/home_page/home_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wydatki-Projekt',
        darkTheme: ThemeData.dark().copyWith(
          useMaterial3: true,
          colorScheme: darkColorScheme,
          cardTheme: const CardTheme().copyWith(
            color: Colors.teal,
          ),
          textTheme: ThemeData().textTheme.copyWith(
            bodySmall: const TextStyle(color: Colors.white70),
            bodyMedium: const TextStyle(color: Colors.white70),
            titleMedium:  const TextStyle(color: Colors.white70),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.teal.shade200,
          ),
        ),
        theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: colorScheme,
        ),

        // Stream bedzie budował wiele wartości w czasie. Stream z SDK firebase da
        // nowe wartości(w zaleznosci od tokenu) w snapshocie --> da dostep do danych
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            //TODO: ekran ładowania
            if (snapshot.hasData){
              return HomePage();
            }
            // Automatyczny powrót do strony logowania ponieważ firebase wyemituje
            // nowe zdarzenie kiedy klikniemy logout bo token nie bedzie juz istniał
            return AuthPage();
          },
        ),
    );
  }
}
