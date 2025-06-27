import 'dart:io';

class ImageUtils {
  static const String _fallbackImageUrl = 'https://picsum.photos/150/200';

  // List of problematic hosts that cause DNS issues
  static const List<String> _problematicHosts = [
    'via.placeholder.com',
    'placeholder.com',
    'dummyimage.com',
  ];

  /// Get a safe image URL that handles offline scenarios
  static String getSafeImageUrl(String? originalUrl, {int? bookId}) {
    // If no URL provided, return empty to show local placeholder
    if (originalUrl == null || originalUrl.isEmpty) {
      return '';
    }

    // Check for problematic URLs that cause DNS lookup failures
    final lowerUrl = originalUrl.toLowerCase();
    for (final host in _problematicHosts) {
      if (lowerUrl.contains(host)) {
        // Return a working alternative URL
        return bookId != null
            ? 'https://picsum.photos/150/200?random=$bookId'
            : _fallbackImageUrl;
      }
    }

    return originalUrl;
  }

  /// Check if we have internet connectivity (basic check)
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get placeholder image URL that works offline
  static String getOfflinePlaceholder() {
    return ''; // Return empty string to trigger local placeholder
  }
}
