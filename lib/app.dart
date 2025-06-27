import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:palm_code_challenge/common/utils/index.dart';
import 'package:palm_code_challenge/core/index.dart';
import 'package:palm_code_challenge/presentation/home/cubit/index.dart';
import 'package:palm_code_challenge/presentation/liked_books/cubit/index.dart';

class PalmCodeChallengeApp extends StatelessWidget {
  const PalmCodeChallengeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<HomeCubit>()),
            BlocProvider(create: (_) => getIt<LikedBooksCubit>()),
            BlocProvider(create: (_) => getIt<ThemeCubit>()..loadTheme()),
          ],
          child: SkeletonizerConfig(
            data: SkeletonTheme.purpleConfig,
            child: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                return MaterialApp.router(
                  title: 'Palm Code Challenge',
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.deepPurple,
                      brightness: Brightness.light,
                    ),
                    useMaterial3: true,
                  ),
                  darkTheme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.deepPurple,
                      brightness: Brightness.dark,
                    ),
                    useMaterial3: true,
                  ),
                  themeMode: themeState.themeMode,
                  routerConfig: AppRouter.router,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
