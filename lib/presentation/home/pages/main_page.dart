import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palm_code_challenge/presentation/home/pages/index.dart';
import 'package:palm_code_challenge/presentation/liked_books/pages/index.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [const HomePage(), const LikedBooksPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 15.sp,
        unselectedFontSize: 12.sp,
        selectedIconTheme: Theme.of(
          context,
        ).iconTheme.copyWith(color: Theme.of(context).colorScheme.primary),
        unselectedIconTheme: Theme.of(
          context,
        ).iconTheme.copyWith(color: Theme.of(context).colorScheme.onSurface),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Liked'),
        ],
      ),
    );
  }
}
