import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

/// Enum for different cache strategies
enum CacheStrategy {
  /// Cache first, then network if cache miss
  cacheFirst,

  /// Network first, then cache if network fails
  networkFirst,

  /// Cache only, no network requests
  cacheOnly,

  /// Network only, no caching
  networkOnly,

  /// Always fetch from network, but cache the result
  refresh,
}

/// Configuration for individual API endpoints
class ApiCacheConfig {
  final String endpoint;
  final Duration duration;
  final CacheStrategy strategy;
  final bool ignoreQuery;
  final List<String>? ignoreHeaders;

  const ApiCacheConfig({
    required this.endpoint,
    required this.duration,
    this.strategy = CacheStrategy.cacheFirst,
    this.ignoreQuery = false,
    this.ignoreHeaders,
  });
}

/// Cache manager that handles API-specific caching configurations
class ApiCacheManager {
  static final ApiCacheManager _instance = ApiCacheManager._internal();
  factory ApiCacheManager() => _instance;
  ApiCacheManager._internal();

  final Map<String, ApiCacheConfig> _cacheConfigs = {};

  /// Register cache configuration for an API endpoint
  void registerApiCache(ApiCacheConfig config) {
    _cacheConfigs[config.endpoint] = config;
  }

  /// Register multiple cache configurations
  void registerMultipleApiCaches(List<ApiCacheConfig> configs) {
    for (final config in configs) {
      registerApiCache(config);
    }
  }

  /// Get cache configuration for a specific endpoint
  ApiCacheConfig? getCacheConfig(String endpoint) {
    // Try exact match first
    if (_cacheConfigs.containsKey(endpoint)) {
      return _cacheConfigs[endpoint];
    }

    // Try pattern matching for endpoints with parameters
    for (final registeredEndpoint in _cacheConfigs.keys) {
      if (_matchesPattern(endpoint, registeredEndpoint)) {
        return _cacheConfigs[registeredEndpoint];
      }
    }

    return null;
  }

  /// Check if an endpoint matches a registered pattern
  bool _matchesPattern(String endpoint, String pattern) {
    // Simple pattern matching for common cases
    // You can extend this with more sophisticated pattern matching
    if (pattern.contains('*')) {
      final regexPattern = pattern.replaceAll('*', '.*');
      return RegExp(regexPattern).hasMatch(endpoint);
    }

    // Check if endpoint starts with the pattern (for REST APIs)
    return endpoint.startsWith(pattern);
  }

  /// Convert cache strategy to dio cache policy
  CachePolicy _strategyToPolicy(CacheStrategy strategy) {
    switch (strategy) {
      case CacheStrategy.cacheFirst:
        return CachePolicy.forceCache;
      case CacheStrategy.networkFirst:
        return CachePolicy.request;
      case CacheStrategy.cacheOnly:
        return CachePolicy.forceCache; // Use forceCache for cache-only
      case CacheStrategy.networkOnly:
        return CachePolicy.noCache;
      case CacheStrategy.refresh:
        return CachePolicy.refresh;
    }
  }

  /// Create cache options for a specific request
  CacheOptions? createCacheOptions(String endpoint, CacheStore cacheStore) {
    final config = getCacheConfig(endpoint);
    if (config == null) return null;

    return CacheOptions(
      store: cacheStore,
      policy: _strategyToPolicy(config.strategy),
      hitCacheOnErrorCodes: [401, 403, 404, 500, 502, 503, 504],
      maxStale: config.duration,
      priority: CachePriority.normal,
    );
  }

  /// Clear cache for specific endpoint
  Future<void> clearCacheForEndpoint(
    String endpoint,
    CacheStore cacheStore,
  ) async {
    try {
      // For simple cache clearing, we can delete based on endpoint pattern
      await cacheStore.clean(staleOnly: false);
    } catch (e) {
      // Handle cache clearing errors
    }
  }

  /// Clear all cache
  Future<void> clearAllCache(CacheStore cacheStore) async {
    try {
      await cacheStore.clean(staleOnly: false);
    } catch (e) {
      // Handle cache clearing errors
    }
  }

  /// Clear all registered cache configurations (useful for testing)
  void clearAllConfigurations() {
    _cacheConfigs.clear();
  }

  /// Get all registered endpoints
  List<String> getRegisteredEndpoints() {
    return _cacheConfigs.keys.toList();
  }

  /// Remove cache configuration for an endpoint
  void unregisterApiCache(String endpoint) {
    _cacheConfigs.remove(endpoint);
  }

  /// Get cache statistics (if needed for debugging)
  Map<String, dynamic> getCacheStats() {
    return {
      'total_endpoints': _cacheConfigs.length,
      'endpoints': _cacheConfigs.keys.toList(),
      'configurations': _cacheConfigs.map(
        (key, value) => MapEntry(key, {
          'duration': value.duration.inSeconds,
          'strategy': value.strategy.toString(),
          'ignore_query': value.ignoreQuery,
        }),
      ),
    };
  }
}
