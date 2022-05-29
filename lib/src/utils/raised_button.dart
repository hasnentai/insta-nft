import 'package:flutter/material.dart';

class RaisedGradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const RaisedGradientButton({
    Key? key,
    required this.child,
    required this.gradient,
    this.width = double.infinity,
    this.height = 55.0,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 55.0,
      decoration: BoxDecoration(
          gradient: gradient, borderRadius: BorderRadius.circular(8.0)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}
