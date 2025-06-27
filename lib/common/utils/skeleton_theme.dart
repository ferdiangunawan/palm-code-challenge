import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Utility class for configuring skeleton themes and effects
class SkeletonTheme {
  SkeletonTheme._();

  /// Default skeleton configuration
  static SkeletonizerConfigData get defaultConfig => SkeletonizerConfigData(
    effect: shimmerEffect,
    justifyMultiLineText: true,
    containersColor: Colors.grey[300]!,
  );

  /// Light theme configuration
  static SkeletonizerConfigData get lightConfig => SkeletonizerConfigData(
    effect: shimmerEffect,
    justifyMultiLineText: true,
    containersColor: Colors.grey[200]!,
  );

  /// Dark theme configuration
  static SkeletonizerConfigData get darkConfig => SkeletonizerConfigData(
    effect: ShimmerEffect(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[600]!,
      duration: const Duration(milliseconds: 1000),
    ),
    justifyMultiLineText: true,
    containersColor: Colors.grey[800]!,
  );

  /// Purple theme configuration (matching app theme)
  static SkeletonizerConfigData get purpleConfig => SkeletonizerConfigData(
    effect: ShimmerEffect(
      baseColor: Colors.deepPurple[100]!,
      highlightColor: Colors.deepPurple[50]!,
      duration: const Duration(milliseconds: 1200),
    ),
    justifyMultiLineText: true,
    containersColor: Colors.deepPurple[100]!,
  );

  /// Shimmer effect for skeletons
  static ShimmerEffect get shimmerEffect => ShimmerEffect(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    duration: const Duration(milliseconds: 1000),
  );

  /// Pulse effect for skeletons
  static PulseEffect get pulseEffect => PulseEffect(
    from: Colors.grey[300]!,
    to: Colors.grey[100]!,
    duration: const Duration(milliseconds: 1000),
  );

  /// Get configuration based on theme brightness
  static SkeletonizerConfigData configForBrightness(Brightness brightness) {
    switch (brightness) {
      case Brightness.light:
        return lightConfig;
      case Brightness.dark:
        return darkConfig;
    }
  }

  /// Create a custom skeleton configuration
  static SkeletonizerConfigData createCustomConfig({
    required Color baseColor,
    required Color highlightColor,
    Color? containersColor,
    Duration? duration,
    bool justifyMultiLineText = true,
  }) {
    return SkeletonizerConfigData(
      effect: ShimmerEffect(
        baseColor: baseColor,
        highlightColor: highlightColor,
        duration: duration ?? const Duration(milliseconds: 1000),
      ),
      justifyMultiLineText: justifyMultiLineText,
      containersColor: containersColor ?? baseColor,
    );
  }
}

/// Extension to easily apply skeleton themes
extension SkeletonThemeExtension on BuildContext {
  /// Get skeleton configuration based on current theme
  SkeletonizerConfigData get skeletonConfig {
    final brightness = Theme.of(this).brightness;
    return SkeletonTheme.configForBrightness(brightness);
  }

  /// Create a themed skeleton widget
  Widget createSkeleton({
    required Widget child,
    bool enabled = true,
    SkeletonizerConfigData? config,
  }) {
    return SkeletonizerConfig(
      data: config ?? skeletonConfig,
      child: Skeletonizer(enabled: enabled, child: child),
    );
  }
}
