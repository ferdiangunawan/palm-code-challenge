import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_code_challenge/presentation/home/cubit/home_cubit.dart';
import 'package:palm_code_challenge/presentation/shared/widgets/index.dart';
import 'package:palm_code_challenge/presentation/home/widgets/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (mounted) {
      context.read<HomeCubit>().loadBooks();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // Dismiss keyboard on tap
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<HomeCubit>().loadBooks();
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPersistentHeader(
                      floating: true,
                      delegate: HeaderDelegate(title: 'Books'),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: SearchBarDelegate(
                        searchController: _searchController,
                        onChanged: (value) {
                          context.read<HomeCubit>().search(value);
                        },
                        onClear: () {
                          _searchController.clear();
                          context.read<HomeCubit>().clearSearch();
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                    // Books List - Handle different states
                    Builder(
                      builder: (context) {
                        final booksLoadData = state.booksLoadData;

                        // Loading
                        if (booksLoadData.isLoading) {
                          return const SliverSkeletonBookList();
                        }

                        // Error
                        if (booksLoadData.isError) {
                          return SliverFillRemaining(
                            child: ErrorDisplay(
                              message: booksLoadData.message,
                              onRetry:
                                  () => context.read<HomeCubit>().loadBooks(),
                            ),
                          );
                        }

                        // No data
                        if (booksLoadData.isNoData) {
                          return const SliverFillRemaining(
                            child: NoDataDisplay(),
                          );
                        }

                        // Has data
                        if (booksLoadData.isHasData &&
                            booksLoadData.data != null) {
                          return BooksListSection(state: state);
                        }

                        // Default (shouldn't happen)
                        return const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
