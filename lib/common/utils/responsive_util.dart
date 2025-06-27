import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Utility class for responsive design using flutter_screenutil
/// Makes it easier to work with responsive dimensions across the app
class ResponsiveUtil {
  ResponsiveUtil._();

  /// Screen dimensions
  static double get screenWidth => 1.sw;
  static double get screenHeight => 1.sh;
  static double get statusBarHeight => ScreenUtil().statusBarHeight;
  static double get bottomBarHeight => ScreenUtil().bottomBarHeight;
  static double get devicePixelRatio => ScreenUtil().pixelRatio ?? 1.0;

  /// Text scaling
  static double scaledText(double fontSize) => fontSize.sp;

  /// Responsive widths
  static double width(double width) => width.w;
  static double height(double height) => height.h;
  static double radius(double radius) => radius.r;

  /// Common responsive sizes
  static double get smallPadding => 8.w;
  static double get mediumPadding => 16.w;
  static double get largePadding => 24.w;
  static double get extraLargePadding => 32.w;

  static double get smallMargin => 8.h;
  static double get mediumMargin => 16.h;
  static double get largeMargin => 24.h;
  static double get extraLargeMargin => 32.h;

  static double get smallRadius => 8.r;
  static double get mediumRadius => 12.r;
  static double get largeRadius => 16.r;
  static double get extraLargeRadius => 24.r;

  /// Common font sizes
  static double get captionText => 10.sp;
  static double get bodySmallText => 12.sp;
  static double get bodyText => 14.sp;
  static double get bodyLargeText => 16.sp;
  static double get titleSmallText => 18.sp;
  static double get titleText => 20.sp;
  static double get titleLargeText => 24.sp;
  static double get headlineText => 28.sp;
  static double get displayText => 32.sp;

  /// Icon sizes
  static double get smallIcon => 16.sp;
  static double get mediumIcon => 24.sp;
  static double get largeIcon => 32.sp;
  static double get extraLargeIcon => 48.sp;

  /// Common responsive edge insets
  static EdgeInsets get smallPaddingAll => EdgeInsets.all(smallPadding);
  static EdgeInsets get mediumPaddingAll => EdgeInsets.all(mediumPadding);
  static EdgeInsets get largePaddingAll => EdgeInsets.all(largePadding);

  static EdgeInsets get smallPaddingHorizontal =>
      EdgeInsets.symmetric(horizontal: smallPadding);
  static EdgeInsets get mediumPaddingHorizontal =>
      EdgeInsets.symmetric(horizontal: mediumPadding);
  static EdgeInsets get largePaddingHorizontal =>
      EdgeInsets.symmetric(horizontal: largePadding);

  static EdgeInsets get smallPaddingVertical =>
      EdgeInsets.symmetric(vertical: smallMargin);
  static EdgeInsets get mediumPaddingVertical =>
      EdgeInsets.symmetric(vertical: mediumMargin);
  static EdgeInsets get largePaddingVertical =>
      EdgeInsets.symmetric(vertical: largeMargin);

  /// Device type checking
  static bool get isMobile => screenWidth < 768;
  static bool get isTablet => screenWidth >= 768 && screenWidth < 1024;
  static bool get isDesktop => screenWidth >= 1024;

  /// Screen size categories
  static bool get isSmallScreen => screenWidth < 360;
  static bool get isMediumScreen => screenWidth >= 360 && screenWidth < 768;
  static bool get isLargeScreen => screenWidth >= 768;

  /// Helper methods for responsive layouts
  static T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  static double responsiveValue({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return responsive<double>(mobile: mobile, tablet: tablet, desktop: desktop);
  }

  /// Responsive grid columns
  static int responsiveColumns({int mobile = 1, int? tablet, int? desktop}) {
    return responsive<int>(
      mobile: mobile,
      tablet: tablet ?? mobile * 2,
      desktop: desktop ?? mobile * 3,
    );
  }

  /// Safe area helpers
  static EdgeInsets get safeAreaPadding => EdgeInsets.only(
    top: ScreenUtil().statusBarHeight,
    bottom: ScreenUtil().bottomBarHeight,
  );
}

/// Extension on BuildContext for easy access to responsive utilities
extension ResponsiveContext on BuildContext {
  /// Quick access to screen dimensions
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Theme-aware responsive text styles
  TextStyle? get responsiveHeadline => Theme.of(
    this,
  ).textTheme.headlineMedium?.copyWith(fontSize: ResponsiveUtil.headlineText);

  TextStyle? get responsiveTitle => Theme.of(
    this,
  ).textTheme.titleLarge?.copyWith(fontSize: ResponsiveUtil.titleText);

  TextStyle? get responsiveBody => Theme.of(
    this,
  ).textTheme.bodyLarge?.copyWith(fontSize: ResponsiveUtil.bodyText);

  TextStyle? get responsiveCaption => Theme.of(
    this,
  ).textTheme.bodySmall?.copyWith(fontSize: ResponsiveUtil.captionText);
}
