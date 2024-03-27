// import 'package:fip_my_version/core/AppLocalizations.dart';
// import 'package:flutter/material.dart';
// import 'package:fip_my_version/pages/sign_in.dart';
// import 'package:fip_my_version/core/language_provider.dart';
// import 'package:fip_my_version/core/core.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

// // void main() {
// //   runApp(
// //     ChangeNotifierProvider(
// //       create: (context) => ThemeProvider(),
// //       child: MyApp(),
// //     ),
// //   );
// // }

// // Future<void> initializeFlutterDownloader() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await FlutterDownloader.initialize(debug: true); // Set to false for release builds
// // }
// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => LanguageProvider(),
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<ThemeProvider>(
//       create: (context) => ThemeProvider(),
//       child: Builder(
//         builder: (newContext) {
//           return MaterialApp(
//             title: 'OMNI-APP',
//             theme: ThemeData.light(),
//             darkTheme: ThemeData.dark(),
//             themeMode: Provider.of<ThemeProvider>(newContext).isDarkMode
//                 ? ThemeMode.dark
//                 : ThemeMode.light,
//             localizationsDelegates: [
//               AppLocalizationsDelegate(),
//               GlobalMaterialLocalizations.delegate,
//               GlobalWidgetsLocalizations.delegate,
//               GlobalCupertinoLocalizations.delegate
//             ],
//             supportedLocales: [
//               const Locale('en'),
//               const Locale('ru'),
//               const Locale('fr'),
//             ],
//             locale: Provider.of<LanguageProvider>(newContext).locale,
//             home: SignIn(),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:fip_my_version/pages/sign_in.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fip_my_version/core/core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'OMNI-APP',
            theme: ThemeData(
              fontFamily: 'K2D',
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              fontFamily: 'K2D',
              brightness: Brightness.dark,
            ),
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            localizationsDelegates: [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en'),
              const Locale('ru'),
              const Locale('fr'),
              const Locale('kg'),
            ],
            locale: Provider.of<LanguageProvider>(context).locale,
            home: SignIn(),
            routes: {
              '/signIn': (context) => SignIn(),
              '/settings': (context) => SettingsScreen(),
              '/home': (context) => HomePage(),
              '/changeLanguage': (context) => ChangeLanguage(),
              '/editProfile': (context) => EditProfScreen(),
              '/privacyPolicy': (context) => PrivacyPolicyScreen(),
              '/changePassword': (context) => ChangePassword(),
              // '/aboutUs': (context) => AboutUsScreen(),
              '/chatsScreen': (context) => ChatsScreen(),
              '/chatScreen': (context) => ChatPage(),
              '/createReport': (context) => CreateReport(),
              // Add other routes here
            },
          );
        },
      ),
    );
  }
}
