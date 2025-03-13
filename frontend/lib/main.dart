// 应用入口文件，初始化 Flutter 应用并配置路由和全局状态管理

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/swap_post_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SwapPostProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CourseSwap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/create-post': (context) => CreatePostScreen(),
        '/post-detail': (context) => PostDetailScreen(post: ModalRoute.of(context)!.settings.arguments as SwapPost),
        '/profile': (context) => ProfileScreen(user: ModalRoute.of(context)!.settings.arguments as User),
      },
    );
  }
}