import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/blocs/filters/filters_bloc.dart';
import 'package:my_app/repositories/geolocation_repository.dart';
import 'package:my_app/screens/welcome/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GeolocationRepository>(
          create: (_) => GeolocationRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => FiltersBloc()..add(FilterLoad()),
          ),
        ],
        child: MaterialApp(
            title: "Thumbsup",
            theme: ThemeData(fontFamily: "Sofia Pro"),
            debugShowCheckedModeBanner: false,
            home: const Scaffold(
              backgroundColor: Colors.white,
              body: Splash(),
            )),
      ),
    );
  }
}

// class App extends StatelessWidget {
//   const App({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: AppConfig.appName,
//       home: Dashboard(title: AppConfig.appName, version: AppConfig.version,),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }