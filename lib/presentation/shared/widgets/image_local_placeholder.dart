import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageLocalPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;

  const ImageLocalPlaceholder({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Icon(
        Icons.book,
        color: Colors.grey[600],
        size:
            (width != null && height != null)
                ? (width! < height! ? width! * 0.4 : height! * 0.4)
                : 24.sp,
      ),
    );
  }
}
