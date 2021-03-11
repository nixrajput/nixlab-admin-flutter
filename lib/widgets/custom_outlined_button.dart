import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final EdgeInsets? padding;
  final double? borderRadius;
  final double? fontSize;

  const CustomOutlinedButton({
    required this.onTap,
    required this.label,
    this.padding,
    this.borderRadius = 24.0,
    this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0.0,
          primary: Theme.of(context).scaffoldBackgroundColor,
          padding: padding != null
              ? padding
              : EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 32.0,
                ),
          side: BorderSide(color: Theme.of(context).accentColor),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius!)))),
      onPressed: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
