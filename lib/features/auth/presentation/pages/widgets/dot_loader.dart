import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DotLoader extends StatelessWidget {
  final double? size;
  final Color? color;

  const DotLoader({
    super.key,
    this.size ,        
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      color: color??Colors.white,
      size: size??10,
    );
  }
}
