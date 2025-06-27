import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:palm_code_challenge/common/utils/network_error_handler.dart';

class BookDetailError extends StatelessWidget {
  final String message;
  const BookDetailError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.surface.withAlpha(179)
                    : Theme.of(context).colorScheme.primary.withAlpha(102),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: FlexibleSpaceBar(
                  title: const Text(
                    'Book Details',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
                  background: Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        NetworkErrorHandler.isNetworkConnectivityError(message)
                            ? Icons.wifi_off
                            : Icons.error,
                        size: 64,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      NetworkErrorHandler.isNetworkConnectivityError(message)
                          ? Icons.wifi_off
                          : Icons.error,
                      size: 64,
                      color: Colors.grey[500],
                    ),
                    const Gap(16),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
