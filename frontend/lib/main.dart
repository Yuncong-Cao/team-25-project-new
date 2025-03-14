import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/swap_post_provider.dart';
import 'screens/home_screen.dart';
import 'screens/post_detail_screen.dart';
import 'models/swap_post.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
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
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/post-detail': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          final SwapPost? post = args?['post'];
          return PostDetailScreen(post: post!);
        },
      },
    );
  }
}
