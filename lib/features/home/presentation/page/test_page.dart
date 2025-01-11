import 'package:akemha/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        left: context.canPop(),
      ),
      body: const Center(
        child: Text("test"),
      ),
    );
  }
}
