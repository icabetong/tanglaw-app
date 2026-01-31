import 'package:flutter/material.dart';

class EmptyViewWidget extends StatelessWidget {
  const EmptyViewWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .center,
      mainAxisAlignment: .center,
      children: [Center(child: Text(title))],
    );
  }
}
