import 'package:flutter_test/flutter_test.dart';
import 'package:palm_code_challenge/core/network/cache_manager.dart';
import 'package:palm_code_challenge/core/network/cache_config.dart';

void main() {
  group('Cache Manager Tests', () {
    late ApiCacheManager cacheManager;

    setUp(() {
      cacheManager = ApiCacheManager();
      // Clear any existing configurations from previous tests
      cacheManager.clearAllConfigurations();
    });

    test('should register and retrieve cache configuration', () {
      // Arrange
      const config = ApiCacheConfig(
        endpoint: '/test',
        duration: Duration(minutes: 30),
        strategy: CacheStrategy.cacheFirst,
      );

      // Act
      cacheManager.registerApiCache(config);
      final retrievedConfig = cacheManager.getCacheConfig('/test');

      // Assert
      expect(retrievedConfig, isNotNull);
      expect(retrievedConfig!.endpoint, equals('/test'));
      expect(retrievedConfig.duration, equals(const Duration(minutes: 30)));
      expect(retrievedConfig.strategy, equals(CacheStrategy.cacheFirst));
    });

    test('should match wildcard patterns', () {
      // Arrange
      const config = ApiCacheConfig(
        endpoint: '/books/*',
        duration: Duration(hours: 1),
        strategy: CacheStrategy.cacheFirst,
      );

      // Act
      cacheManager.registerApiCache(config);
      final retrievedConfig = cacheManager.getCacheConfig('/books/123');

      // Assert
      expect(retrievedConfig, isNotNull);
      expect(retrievedConfig!.endpoint, equals('/books/*'));
    });

    test('should register multiple cache configurations', () {
      // Arrange
      final configs = [
        const ApiCacheConfig(
          endpoint: '/books',
          duration: Duration(minutes: 30),
          strategy: CacheStrategy.cacheFirst,
        ),
        const ApiCacheConfig(
          endpoint: '/authors',
          duration: Duration(hours: 2),
          strategy: CacheStrategy.networkFirst,
        ),
      ];

      // Act
      cacheManager.registerMultipleApiCaches(configs);

      // Assert
      expect(cacheManager.getRegisteredEndpoints(), hasLength(2));
      expect(cacheManager.getRegisteredEndpoints(), contains('/books'));
      expect(cacheManager.getRegisteredEndpoints(), contains('/authors'));
    });

    test('should provide cache statistics', () {
      // Arrange
      final configs = CacheConfigurations.getAllConfigurations();
      cacheManager.registerMultipleApiCaches(configs);

      // Act
      final stats = cacheManager.getCacheStats();

      // Assert
      expect(stats['total_endpoints'], equals(configs.length));
      expect(stats['endpoints'], isA<List>());
      expect(stats['configurations'], isA<Map>());
    });

    test('should unregister cache configuration', () {
      // Arrange
      const config = ApiCacheConfig(
        endpoint: '/test',
        duration: Duration(minutes: 30),
        strategy: CacheStrategy.cacheFirst,
      );
      cacheManager.registerApiCache(config);

      // Act
      cacheManager.unregisterApiCache('/test');

      // Assert
      expect(cacheManager.getCacheConfig('/test'), isNull);
      expect(cacheManager.getRegisteredEndpoints(), isEmpty);
    });
  });

  group('Cache Configurations Tests', () {
    test('should return all predefined configurations', () {
      // Act
      final configs = CacheConfigurations.getAllConfigurations();

      // Assert
      expect(configs, isNotEmpty);
      expect(configs.any((c) => c.endpoint == '/books'), isTrue);
      expect(configs.any((c) => c.endpoint == '/books/*'), isTrue);
    });

    test('should filter configurations by strategy', () {
      // Act
      final cacheFirstConfigs = CacheConfigurations.getByStrategy(
        CacheStrategy.cacheFirst,
      );
      final networkFirstConfigs = CacheConfigurations.getByStrategy(
        CacheStrategy.networkFirst,
      );

      // Assert
      expect(cacheFirstConfigs, isNotEmpty);
      expect(networkFirstConfigs, isNotEmpty);

      // Verify all returned configs have the correct strategy
      for (final config in cacheFirstConfigs) {
        expect(config.strategy, equals(CacheStrategy.cacheFirst));
      }
      for (final config in networkFirstConfigs) {
        expect(config.strategy, equals(CacheStrategy.networkFirst));
      }
    });

    test('should filter configurations by duration range', () {
      // Act
      final shortLivedConfigs = CacheConfigurations.getByDurationRange(
        maxDuration: const Duration(hours: 1),
      );
      final longLivedConfigs = CacheConfigurations.getByDurationRange(
        minDuration: const Duration(hours: 1),
      );

      // Assert
      expect(shortLivedConfigs, isNotEmpty);
      expect(longLivedConfigs, isNotEmpty);

      // Verify duration constraints
      for (final config in shortLivedConfigs) {
        expect(
          config.duration.inMilliseconds,
          lessThanOrEqualTo(const Duration(hours: 1).inMilliseconds),
        );
      }
      for (final config in longLivedConfigs) {
        expect(
          config.duration.inMilliseconds,
          greaterThanOrEqualTo(const Duration(hours: 1).inMilliseconds),
        );
      }
    });
  });

  group('Cache Extension Tests', () {
    late ApiCacheManager cacheManager;

    setUp(() {
      cacheManager = ApiCacheManager();
      // Clear any existing configurations from previous tests
      cacheManager.clearAllConfigurations();
    });

    test('should register default configurations via extension', () {
      // Act
      cacheManager.registerDefaultConfigurations();

      // Assert
      expect(cacheManager.getRegisteredEndpoints(), isNotEmpty);
      expect(cacheManager.getCacheConfig('/books'), isNotNull);
      expect(cacheManager.getCacheConfig('/books/*'), isNotNull);
    });

    test('should register configurations by strategy via extension', () {
      // Act
      cacheManager.registerByStrategy(CacheStrategy.cacheFirst);

      // Assert
      final endpoints = cacheManager.getRegisteredEndpoints();
      expect(endpoints, isNotEmpty);

      // Verify all registered configs have the specified strategy
      for (final endpoint in endpoints) {
        final config = cacheManager.getCacheConfig(endpoint);
        expect(config?.strategy, equals(CacheStrategy.cacheFirst));
      }
    });
  });
}
