import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:palm_code_challenge/common/utils/index.dart';

class ViewDataBuilder<T> extends StatelessWidget {
  final ViewData<T> viewData;
  final Widget Function(BuildContext context, T data) onData;
  final Widget Function(BuildContext context)? onLoading;
  final Widget Function(BuildContext context, String message)? onError;
  final Widget Function(BuildContext context, String message)? onNoData;
  final Widget Function(BuildContext context)? onInitial;

  const ViewDataBuilder({
    super.key,
    required this.viewData,
    required this.onData,
    this.onLoading,
    this.onError,
    this.onNoData,
    this.onInitial,
  });

  @override
  Widget build(BuildContext context) {
    if (viewData.isInitial) {
      return onInitial?.call(context) ?? const SizedBox.shrink();
    }

    if (viewData.isLoading) {
      return onLoading?.call(context) ??
          const Center(child: CircularProgressIndicator());
    }

    if (viewData.isError) {
      // If there's cached data available during error, show the data with error indicator
      if (viewData.data != null) {
        final isNetworkError = NetworkErrorHandler.isNetworkConnectivityError(
          viewData.message,
        );
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isNetworkError
                        ? Colors.orange.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                border: Border(
                  bottom: BorderSide(
                    color: isNetworkError ? Colors.orange : Colors.red,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isNetworkError ? Icons.wifi_off : Icons.error,
                    size: 16,
                    color: isNetworkError ? Colors.orange : Colors.red,
                  ),
                  Gap(8),
                  Expanded(
                    child: Text(
                      viewData.message,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            isNetworkError
                                ? Colors.orange.shade700
                                : Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: onData(context, viewData.data as T)),
          ],
        );
      }

      // No cached data available, show error UI
      return onError?.call(context, viewData.message) ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  NetworkErrorHandler.isNetworkConnectivityError(
                        viewData.message,
                      )
                      ? Icons.wifi_off
                      : Icons.error,
                  size: 48,
                  color:
                      NetworkErrorHandler.isNetworkConnectivityError(
                            viewData.message,
                          )
                          ? Colors.orange
                          : Colors.red,
                ),
                Gap(16),
                Text(
                  viewData.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
    }

    if (viewData.isNoData) {
      return onNoData?.call(context, viewData.message) ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.inbox, size: 48, color: Colors.grey),
                Gap(16),
                Text(
                  viewData.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
    }

    if (viewData.isHasData && viewData.data != null) {
      return onData(context, viewData.data ?? T as T);
    }

    return const SizedBox.shrink();
  }
}
