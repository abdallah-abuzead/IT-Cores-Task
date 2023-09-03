import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

///

/// Using [GoRouter] global redirect feature
/// to guard [GuardedPage] to be only accessible
/// if the user is authenticated, so clicking
/// `login` on [AuthPage] should trigger a redirect to [GuardedPage]
/// clicking `logout` on [GuardedPage] should redirect the user to
/// [AuthPage]
///
/// Everything is wired, you only need to add the redirection logic
///
/// You are only allowed to use [GoRouter] redirect to solve this
///

/// Copy the content of this file and past it into main file

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isAuthenticated;
  @override
  void initState() {
    isAuthenticated = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            name: 'auth',
            builder: (context, state) => AuthPage(login),
          ),
          GoRoute(
            path: '/gaurded',
            name: 'guarded',
            builder: (context, state) => GuardedPage(
              logout,
            ),
          )
        ],
        redirect: (context, state) => isAuthenticated ? '/gaurded' : '/',
      ),
    );
  }

  void login() {
    setState(() {
      isAuthenticated = true;
    });
  }

  void logout() {
    setState(() {
      isAuthenticated = false;
    });
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage(
    this._login, {
    super.key,
  });
  final VoidCallback _login;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ElevatedButton(onPressed: _login, child: const Text('Log In'))],
        ),
      ),
    );
  }
}

class GuardedPage extends StatelessWidget {
  const GuardedPage(this._logout, {super.key});

  final VoidCallback _logout;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: const Text('Guarded page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ElevatedButton(onPressed: _logout, child: const Text('Log Out'))],
        ),
      ),
    );
  }
}
