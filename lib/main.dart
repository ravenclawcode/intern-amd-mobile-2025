import 'package:financial_app/views/dasboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/transaction_provider.dart';
import 'views/onboarding/onboarding_screen.dart';
import 'views/transactions/transaction_list_screen.dart';
import 'views/transactions/transaction_form_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool onboardingDone = prefs.getBool("onboarding_done") ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TransactionProvider()..loadData(),
        ),
      ],
      child: MyApp(onboardingDone: onboardingDone),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool onboardingDone;

  const MyApp({super.key, required this.onboardingDone});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Color(0xffFFFFFF)),
      debugShowCheckedModeBanner: false,
      home: onboardingDone ? DashboardScreen() : OnboardingScreen(),
      routes: {
        "/dashboard": (_) => DashboardScreen(),
        "/transactions": (_) => TransactionListScreen(),
        "/add": (_) => TransactionFormScreen(),
      },
    );
  }
}
