import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palm_code_challenge/presentation/shared/widgets/image_loading_placeholder.dart';
import 'package:palm_code_challenge/presentation/shared/widgets/image_local_placeholder.dart';

class SafeCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const SafeCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // If image URL is empty or contains problematic hosts, show local placeholder immediately
    if (imageUrl.isEmpty || !imageUrl.isSafeImageUrl) {
      return ImageLocalPlaceholder(width: width, height: height);
    }

    Widget child = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder:
          placeholder ??
          (context, url) =>
              ImageLoadingPlaceholder(width: width, height: height),
      errorWidget: (context, url, error) {
        // Log error for debugging but don't show it to user
        debugPrint('Image loading failed for $url: ${error.toString()}');
        return errorWidget ??
            ImageLocalPlaceholder(width: width, height: height);
      },
      // Add cache options to reduce network calls
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 200),
    );

    if (borderRadius != null) {
      child = ClipRRect(borderRadius: borderRadius!, child: child);
    }

    return child;
  }
}

/// Extension to provide easy access to safe image loading
extension SafeImageUrl on String {
  static const List<String> _problematicHosts = [
    'via.placeholder.com',
    'placeholder.com',
    'dummyimage.com',
  ];

  bool get isSafeImageUrl {
    if (isEmpty) return false;

    final lowerUrl = toLowerCase();
    for (final host in _problematicHosts) {
      if (lowerUrl.contains(host)) return false;
    }

    return true;
  }
}
