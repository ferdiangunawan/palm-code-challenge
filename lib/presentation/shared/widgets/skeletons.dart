import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonLoader extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const SkeletonLoader({super.key, required this.child, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(enabled: enabled, child: child);
  }
}

class SkeletonText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  const SkeletonText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text, style: style, maxLines: maxLines, overflow: overflow);
  }
}

class SkeletonImage extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonImage({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: borderRadius,
      ),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const SkeletonCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Padding(padding: padding ?? EdgeInsets.all(12.w), child: child),
    );
  }
}

class SkeletonAvatar extends StatelessWidget {
  final double radius;
  final bool isCircular;

  const SkeletonAvatar({
    super.key,
    required this.radius,
    this.isCircular = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircular ? null : BorderRadius.circular(8.r),
      ),
    );
  }
}

class SkeletonLine extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;

  const SkeletonLine({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height.h,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: borderRadius ?? BorderRadius.circular(4.r),
      ),
    );
  }
}

class SkeletonParagraph extends StatelessWidget {
  final int lines;
  final double? lineHeight;
  final double? spacing;

  const SkeletonParagraph({
    super.key,
    this.lines = 3,
    this.lineHeight,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        final isLastLine = index == lines - 1;
        return Container(
          margin: EdgeInsets.only(bottom: isLastLine ? 0 : (spacing ?? 8.h)),
          child: SkeletonLine(
            width:
                isLastLine
                    ? MediaQuery.of(context).size.width * 0.6
                    : double.infinity,
            height: lineHeight ?? 16,
          ),
        );
      }),
    );
  }
}
