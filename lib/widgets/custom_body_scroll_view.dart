import 'package:flutter/material.dart';

class CustomBodyScrollView extends StatelessWidget {
  final Widget child;

  const CustomBodyScrollView({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: child,
        ),
      ),
    );
  }
}
