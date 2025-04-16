import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

import '../lib/screens/create_post_screen.dart';
import '../lib/providers/swap_post_provider.dart';

class MockSwapPostProvider extends Mock implements SwapPostProvider {}

void main() {
  group('CreatePostScreen Tests', () {
    late MockSwapPostProvider mockProvider;

    setUp(() {
      mockProvider = MockSwapPostProvider();
    });

    Widget createTestWidget() {
      return ChangeNotifierProvider<SwapPostProvider>.value(
        value: mockProvider,
        child: const MaterialApp(
          home: CreatePostScreen(),
        ),
      );
    }

    testWidgets('should call createPost when fields are filled', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // 填入标题和描述
      await tester.enterText(find.widgetWithText(TextField, 'Title'), 'Test Post');
      await tester.enterText(find.widgetWithText(TextField, 'Description'), 'This is a test post.');

      // 点击发布按钮
      final publishButton = find.byType(ElevatedButton);
      await tester.tap(publishButton);

      // 触发动画
      await tester.pump(const Duration(seconds: 1));

      verify(mockProvider.createPost('Test Post', 'This is a test post.')).called(1);
      expect(find.text('Post created!'), findsOneWidget);
    });
  });
}
