import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:palm_code_challenge/common/constants/index.dart';
import 'package:palm_code_challenge/core/network/cache_manager.dart'
    as cache_mgr;
import 'package:palm_code_challenge/core/network/cache_config.dart';

class NetworkClient {
  late final Dio _dio;
  late final CacheStore _cacheStore;
  final cache_mgr.ApiCacheManager _cacheManager = cache_mgr.ApiCacheManager();
  bool _initialized = false;
  Future<void>? _initializationFuture;

  NetworkClient();

  Future<void> _initializeDio() async {
    if (_initialized) return;

    // Get application support directory for cache storage
    final cacheDir = await getApplicationSupportDirectory();

    // Initialize cache store with proper directory path
    _cacheStore = HiveCacheStore(
      cacheDir.path,
      hiveBoxName: HiveBoxNames.hiveCacheBoxName,
    );

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectionTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add cache interceptor
    _dio.interceptors.add(
      DioCacheInterceptor(
        options: CacheOptions(
          store: _cacheStore,
          policy:
              CachePolicy
                  .forceCache, // Always try cache first for offline support
          hitCacheOnErrorCodes: [401, 403, 404, 500, 502, 503, 504],
          maxStale: const Duration(
            hours: 24,
          ), // Extended cache duration for offline support
          priority: CachePriority.high,
        ),
      ),
    );

    // Add logging interceptor
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) {
          // You can replace this with your preferred logging solution
        },
      ),
    );

    // Register default cache configurations
    _registerDefaultCacheConfigs();
    _initialized = true;
  }

  /// Register default cache configurations for the application
  void _registerDefaultCacheConfigs() {
    _cacheManager.registerDefaultConfigurations();
  }

  /// Ensure initialization is complete before making requests
  Future<void> _ensureInitialized() async {
    if (_initialized) return;

    // If initialization is already in progress, wait for it
    if (_initializationFuture != null) {
      return _initializationFuture!;
    }

    // Start initialization
    _initializationFuture = _initializeDio();
    return _initializationFuture!;
  }

  /// Public method to ensure initialization is complete
  Future<void> ensureInitialized() async {
    await _ensureInitialized();
  }

  Dio get dio => _dio;

  /// GET request with cache configuration
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    cache_mgr.CacheStrategy? cacheStrategy,
    Duration? cacheDuration,
  }) async {
    await _ensureInitialized();

    // Get cache configuration for this endpoint
    final cacheConfig = _cacheManager.getCacheConfig(path);
    Options finalOptions = options ?? Options();

    if (cacheConfig != null || cacheStrategy != null || cacheDuration != null) {
      // Create custom cache options if specified
      if (cacheStrategy != null || cacheDuration != null) {
        final customConfig = cache_mgr.ApiCacheConfig(
          endpoint: path,
          duration: cacheDuration ?? const Duration(hours: 1),
          strategy: cacheStrategy ?? cache_mgr.CacheStrategy.cacheFirst,
        );
        final cacheOptions = _createCacheOptionsFromConfig(customConfig);
        finalOptions = finalOptions.copyWith(extra: cacheOptions?.toExtra());
      } else {
        // Use registered cache configuration
        final cacheOptions = _cacheManager.createCacheOptions(
          path,
          _cacheStore,
        );
        if (cacheOptions != null) {
          finalOptions = finalOptions.copyWith(extra: cacheOptions.toExtra());
        }
      }
    }

    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: finalOptions,
    );
  }

  /// POST request with optional cache configuration
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    cache_mgr.CacheStrategy? cacheStrategy,
    Duration? cacheDuration,
  }) async {
    await _ensureInitialized();

    Options finalOptions = options ?? Options();

    // POST requests are typically not cached, but we allow it if explicitly requested
    if (cacheStrategy != null || cacheDuration != null) {
      final customConfig = cache_mgr.ApiCacheConfig(
        endpoint: path,
        duration: cacheDuration ?? const Duration(minutes: 10),
        strategy: cacheStrategy ?? cache_mgr.CacheStrategy.networkFirst,
      );
      final cacheOptions = _createCacheOptionsFromConfig(customConfig);
      finalOptions = finalOptions.copyWith(extra: cacheOptions?.toExtra());
    }

    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: finalOptions,
    );
  }

  /// Create cache options from configuration
  CacheOptions? _createCacheOptionsFromConfig(cache_mgr.ApiCacheConfig config) {
    CachePolicy policy;
    switch (config.strategy) {
      case cache_mgr.CacheStrategy.cacheFirst:
        policy = CachePolicy.forceCache;
        break;
      case cache_mgr.CacheStrategy.networkFirst:
        policy = CachePolicy.request;
        break;
      case cache_mgr.CacheStrategy.cacheOnly:
        policy = CachePolicy.forceCache; // Use forceCache for cache-only
        break;
      case cache_mgr.CacheStrategy.networkOnly:
        policy = CachePolicy.noCache;
        break;
      case cache_mgr.CacheStrategy.refresh:
        policy = CachePolicy.refresh;
        break;
    }

    return CacheOptions(
      store: _cacheStore,
      policy: policy,
      hitCacheOnErrorCodes: [401, 403, 404, 500, 502, 503, 504],
      maxStale: config.duration,
      priority: CachePriority.normal,
    );
  }

  /// Register a new cache configuration
  void registerCacheConfig(cache_mgr.ApiCacheConfig config) {
    _cacheManager.registerApiCache(config);
  }

  /// Register multiple cache configurations
  void registerMultipleCacheConfigs(List<cache_mgr.ApiCacheConfig> configs) {
    _cacheManager.registerMultipleApiCaches(configs);
  }

  /// Clear cache for a specific endpoint
  Future<void> clearCacheForEndpoint(String endpoint) async {
    await _ensureInitialized();
    await _cacheManager.clearCacheForEndpoint(endpoint, _cacheStore);
  }

  /// Clear all cache
  Future<void> clearAllCache() async {
    await _ensureInitialized();
    await _cacheManager.clearAllCache(_cacheStore);
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return _cacheManager.getCacheStats();
  }

  /// Get all registered cache endpoints
  List<String> getRegisteredCacheEndpoints() {
    return _cacheManager.getRegisteredEndpoints();
  }

  /// Remove cache configuration for an endpoint
  void removeCacheConfig(String endpoint) {
    _cacheManager.unregisterApiCache(endpoint);
  }

  /// Force refresh an endpoint (bypasses cache)
  Future<Response> forceRefresh(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await get(
      path,
      queryParameters: queryParameters,
      options: options,
      cacheStrategy: cache_mgr.CacheStrategy.refresh,
    );
  }

  /// Get data from cache only (no network request)
  Future<Response> getCacheOnly(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await get(
      path,
      queryParameters: queryParameters,
      options: options,
      cacheStrategy: cache_mgr.CacheStrategy.cacheOnly,
    );
  }
}
