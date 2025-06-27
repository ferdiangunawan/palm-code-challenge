import 'package:flutter_test/flutter_test.dart';
import 'package:palm_code_challenge/common/utils/view_data.dart';

void main() {
  group('ViewData Tests', () {
    group('Factory constructors', () {
      test('should create loaded ViewData with data', () {
        const testData = 'test data';
        final viewData = ViewData.loaded(data: testData);

        expect(viewData.status, equals(ViewState.hasData));
        expect(viewData.data, equals(testData));
        expect(viewData.message, equals(''));
        expect(viewData.subMessage, equals(''));
      });

      test('should create loaded ViewData without data', () {
        final ViewData<String> viewData = ViewData.loaded();

        expect(viewData.status, equals(ViewState.hasData));
        expect(viewData.data, isNull);
        expect(viewData.message, equals(''));
        expect(viewData.subMessage, equals(''));
      });

      test('should create error ViewData with message', () {
        const errorMessage = 'Something went wrong';
        const subMessage = 'Please try again';
        const testData = 'fallback data';

        final viewData = ViewData.error(
          message: errorMessage,
          subMessage: subMessage,
          data: testData,
        );

        expect(viewData.status, equals(ViewState.error));
        expect(viewData.message, equals(errorMessage));
        expect(viewData.subMessage, equals(subMessage));
        expect(viewData.data, equals(testData));
      });

      test('should create error ViewData with null message', () {
        final ViewData<String> viewData = ViewData.error(message: null);

        expect(viewData.status, equals(ViewState.error));
        expect(viewData.message, equals('null'));
        expect(viewData.subMessage, equals(''));
        expect(viewData.data, isNull);
      });

      test('should create loading ViewData with message', () {
        const loadingMessage = 'Loading data...';
        final viewData = ViewData.loading(message: loadingMessage);

        expect(viewData.status, equals(ViewState.loading));
        expect(viewData.message, equals(loadingMessage));
        expect(viewData.subMessage, equals(''));
        expect(viewData.data, isNull);
      });

      test('should create loading ViewData without message', () {
        final ViewData<String> viewData = ViewData.loading();

        expect(viewData.status, equals(ViewState.loading));
        expect(viewData.message, equals(''));
        expect(viewData.subMessage, equals(''));
        expect(viewData.data, isNull);
      });

      test('should create initial ViewData', () {
        final ViewData<String> viewData = ViewData.initial();

        expect(viewData.status, equals(ViewState.initial));
        expect(viewData.message, equals(''));
        expect(viewData.subMessage, equals(''));
        expect(viewData.data, isNull);
      });

      test('should create noData ViewData with message', () {
        const noDataMessage = 'No data available';
        final viewData = ViewData.noData(message: noDataMessage);

        expect(viewData.status, equals(ViewState.noData));
        expect(viewData.message, equals(noDataMessage));
        expect(viewData.subMessage, equals(''));
        expect(viewData.data, isNull);
      });
    });

    group('Status check getters', () {
      test('isLoading should return true for loading state', () {
        final ViewData<String> viewData = ViewData.loading();
        expect(viewData.isLoading, isTrue);
      });

      test('isLoading should return false for non-loading states', () {
        final ViewData<String> initial = ViewData.initial();
        final ViewData<String> loaded = ViewData.loaded();
        final ViewData<String> error = ViewData.error(message: 'error');
        final viewDataNoData = ViewData.noData(message: 'no data');

        expect(initial.isLoading, isFalse);
        expect(loaded.isLoading, isFalse);
        expect(error.isLoading, isFalse);
        expect(viewDataNoData.isLoading, isFalse);
      });

      test('isInitial should return true for initial state', () {
        final ViewData<String> viewData = ViewData.initial();
        expect(viewData.isInitial, isTrue);
      });

      test('isInitial should return false for non-initial states', () {
        final ViewData<String> loading = ViewData.loading();
        final ViewData<String> loaded = ViewData.loaded();
        final ViewData<String> error = ViewData.error(message: 'error');
        final viewDataNoData = ViewData.noData(message: 'no data');

        expect(loading.isInitial, isFalse);
        expect(loaded.isInitial, isFalse);
        expect(error.isInitial, isFalse);
        expect(viewDataNoData.isInitial, isFalse);
      });

      test('isError should return true for error state', () {
        final ViewData<String> viewData = ViewData.error(message: 'error');
        expect(viewData.isError, isTrue);
      });

      test('isError should return false for non-error states', () {
        final ViewData<String> initial = ViewData.initial();
        final ViewData<String> loading = ViewData.loading();
        final ViewData<String> loaded = ViewData.loaded();
        final viewDataNoData = ViewData.noData(message: 'no data');

        expect(initial.isError, isFalse);
        expect(loading.isError, isFalse);
        expect(loaded.isError, isFalse);
        expect(viewDataNoData.isError, isFalse);
      });

      test('isHasData should return true for hasData state', () {
        final ViewData<String> viewData = ViewData.loaded();
        expect(viewData.isHasData, isTrue);
      });

      test('isHasData should return false for non-hasData states', () {
        final ViewData<String> initial = ViewData.initial();
        final ViewData<String> loading = ViewData.loading();
        final ViewData<String> error = ViewData.error(message: 'error');
        final viewDataNoData = ViewData.noData(message: 'no data');

        expect(initial.isHasData, isFalse);
        expect(loading.isHasData, isFalse);
        expect(error.isHasData, isFalse);
        expect(viewDataNoData.isHasData, isFalse);
      });

      test('isNoData should return true for noData state', () {
        final viewData = ViewData.noData(message: 'no data');
        expect(viewData.isNoData, isTrue);
      });

      test('isNoData should return false for non-noData states', () {
        final ViewData<String> initial = ViewData.initial();
        final ViewData<String> loading = ViewData.loading();
        final ViewData<String> loaded = ViewData.loaded();
        final ViewData<String> error = ViewData.error(message: 'error');

        expect(initial.isNoData, isFalse);
        expect(loading.isNoData, isFalse);
        expect(loaded.isNoData, isFalse);
        expect(error.isNoData, isFalse);
      });
    });

    group('Equality', () {
      test('should be equal for same state and data', () {
        final viewData1 = ViewData.loaded(data: 'test');
        final viewData2 = ViewData.loaded(data: 'test');

        expect(viewData1, equals(viewData2));
      });

      test('should not be equal for different states', () {
        final viewData1 = ViewData.loaded(data: 'test');
        final ViewData<String> viewData2 = ViewData.loading(message: 'loading');

        expect(viewData1, isNot(equals(viewData2)));
      });

      test('should not be equal for different data', () {
        final viewData1 = ViewData.loaded(data: 'test1');
        final viewData2 = ViewData.loaded(data: 'test2');

        expect(viewData1, isNot(equals(viewData2)));
      });

      test('should not be equal for different messages', () {
        final ViewData<String> viewData1 = ViewData.error(message: 'error1');
        final ViewData<String> viewData2 = ViewData.error(message: 'error2');

        expect(viewData1, isNot(equals(viewData2)));
      });

      test('should be equal for complex data types', () {
        final list1 = ['item1', 'item2'];
        final list2 = ['item1', 'item2'];
        final viewData1 = ViewData.loaded(data: list1);
        final viewData2 = ViewData.loaded(data: list2);

        expect(viewData1, equals(viewData2));
      });
    });

    group('Generic type handling', () {
      test('should handle String type', () {
        final viewData = ViewData.loaded(data: 'test string');
        expect(viewData.data, isA<String>());
        expect(viewData.data, equals('test string'));
      });

      test('should handle int type', () {
        final viewData = ViewData.loaded(data: 42);
        expect(viewData.data, isA<int>());
        expect(viewData.data, equals(42));
      });

      test('should handle List type', () {
        final testList = [1, 2, 3];
        final viewData = ViewData.loaded(data: testList);
        expect(viewData.data, isA<List<int>>());
        expect(viewData.data, equals(testList));
      });

      test('should handle Map type', () {
        final testMap = {'key': 'value'};
        final viewData = ViewData.loaded(data: testMap);
        expect(viewData.data, isA<Map<String, String>>());
        expect(viewData.data, equals(testMap));
      });

      test('should handle null data with specified type', () {
        final ViewData<String> viewData = ViewData.loaded();
        expect(viewData.data, isNull);
        expect(viewData, isA<ViewData<String>>());
      });
    });

    group('ViewState enum', () {
      test('should have all expected values', () {
        expect(ViewState.initial, isA<ViewState>());
        expect(ViewState.loading, isA<ViewState>());
        expect(ViewState.error, isA<ViewState>());
        expect(ViewState.hasData, isA<ViewState>());
        expect(ViewState.noData, isA<ViewState>());
      });

      test('should have unique values', () {
        final states = {
          ViewState.initial,
          ViewState.loading,
          ViewState.error,
          ViewState.hasData,
          ViewState.noData,
        };
        expect(states.length, equals(5));
      });
    });
  });
}
