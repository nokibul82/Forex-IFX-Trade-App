import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/bloc/account/account_bloc.dart';
import 'presentation/bloc/promo/promo_bloc.dart';
import 'presentation/pages/dashboard_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/promotions_page.dart';
import 'data/repositories/account_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/promo_repository.dart';
import 'presentation/bloc/auth/auth_bloc.dart';

import 'core/di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(getIt<AuthRepository>())
            ..add(CheckAuthStatus()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Peanut Trading',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const AppWrapper(),
      ),
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  int _currentIndex = 0;
  String? _login;
  String? _token;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Get saved login
          getIt<AuthRepository>().getSavedLogin().then((login) {
            setState(() {
              _login = login;
              _token = state.token;
            });
          });
        } else if (state is Unauthenticated ||
            state is AuthFailure ||
            state is SessionExpiredState) {
          setState(() {
            _login = null;
            _token = null;
            _currentIndex = 0;
          });
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is AuthSuccess && _login != null && _token != null) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<AccountBloc>(
                create: (context) => AccountBloc(
                  accountRepository: getIt<AccountRepository>(),
                  login: _login!,
                  token: _token!,
                ),
              ),
              BlocProvider<PromoBloc>(
                create: (context) => PromoBloc(getIt<PromoRepository>()),
              ),
            ],
            child: Scaffold(
              body: IndexedStack(
                index: _currentIndex,
                children: [
                  DashboardPage(login: _login!),
                  const PromotionsPage(),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.campaign),
                    label: 'Promotions',
                  ),
                ],
              ),
            ),
          );
        }

        return const LoginPage();
      },
    );
  }
}