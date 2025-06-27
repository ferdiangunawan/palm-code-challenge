import 'package:palm_code_challenge/core/network/cache_manager.dart';

/// Predefined cache configurations for different types of API endpoints
class CacheConfigurations {
  /// Cache configuration for book listings
  static const ApiCacheConfig booksList = ApiCacheConfig(
    endpoint: '/books',
    duration: Duration(minutes: 30),
    strategy: CacheStrategy.cacheFirst,
    ignoreQuery: false,
  );

  /// Cache configuration for individual book details
  static const ApiCacheConfig bookDetails = ApiCacheConfig(
    endpoint: '/books/*',
    duration: Duration(hours: 2),
    strategy: CacheStrategy.cacheFirst,
    ignoreQuery: true,
  );

  /// Cache configuration for search results
  static const ApiCacheConfig searchResults = ApiCacheConfig(
    endpoint: '/books?search=*',
    duration: Duration(minutes: 15),
    strategy: CacheStrategy.networkFirst,
    ignoreQuery: false,
  );

  /// Cache configuration for author information
  static const ApiCacheConfig authorInfo = ApiCacheConfig(
    endpoint: '/authors/*',
    duration: Duration(hours: 4),
    strategy: CacheStrategy.cacheFirst,
    ignoreQuery: true,
  );

  /// Cache configuration for subjects/categories
  static const ApiCacheConfig subjects = ApiCacheConfig(
    endpoint: '/books?topic=*',
    duration: Duration(hours: 1),
    strategy: CacheStrategy.cacheFirst,
    ignoreQuery: false,
  );

  /// Get all default cache configurations
  static List<ApiCacheConfig> getAllConfigurations() {
    return [booksList, bookDetails, searchResults, authorInfo, subjects];
  }

  /// Get configurations for specific cache strategies
  static List<ApiCacheConfig> getByStrategy(CacheStrategy strategy) {
    return getAllConfigurations()
        .where((config) => config.strategy == strategy)
        .toList();
  }

  /// Get configurations by duration range
  static List<ApiCacheConfig> getByDurationRange({
    Duration? minDuration,
    Duration? maxDuration,
  }) {
    return getAllConfigurations().where((config) {
      if (minDuration != null && config.duration < minDuration) {
        return false;
      }
      if (maxDuration != null && config.duration > maxDuration) {
        return false;
      }
      return true;
    }).toList();
  }
}

/// Extension methods for easier cache configuration management
extension CacheConfigurationExtensions on ApiCacheManager {
  /// Register all default cache configurations
  void registerDefaultConfigurations() {
    registerMultipleApiCaches(CacheConfigurations.getAllConfigurations());
  }

  /// Register configurations for specific strategies
  void registerByStrategy(CacheStrategy strategy) {
    registerMultipleApiCaches(CacheConfigurations.getByStrategy(strategy));
  }

  /// Register configurations for short-lived cache (< 1 hour)
  void registerShortLivedCache() {
    registerMultipleApiCaches(
      CacheConfigurations.getByDurationRange(
        maxDuration: const Duration(hours: 1),
      ),
    );
  }

  /// Register configurations for long-lived cache (> 1 hour)
  void registerLongLivedCache() {
    registerMultipleApiCaches(
      CacheConfigurations.getByDurationRange(
        minDuration: const Duration(hours: 1),
      ),
    );
  }
}
