import 'package:flutter/material.dart';

class ImageLoadingPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;

  const ImageLoadingPlaceholder({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
        ),
      ),
    );
  }
}
