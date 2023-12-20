import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pos_admin/backend/provider/login_provider.dart';
import 'package:pos_admin/sceens/adminDashboard.dart';
import 'package:pos_admin/sceens/inception.dart';
import 'package:pos_admin/sceens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
      name: 'pos-main',
      options: FirebaseOptions(
        apiKey: "AIzaSyCnPCE-N8H4J_Bw-NTtPeb3n2rXxxua8SA",
        projectId: "mypos-management",
        messagingSenderId: "772150199713",
        appId: "1:772150199713:web:517bd7f39ca12dc39af7e0")
        );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'POS',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  List<SingleChildWidget> providers = [
    //Handling the login info
    ChangeNotifierProvider(create: (context) {
      LoginProvider lp = LoginProvider();
      lp.init();
      return lp;
    }),
  ];
}
