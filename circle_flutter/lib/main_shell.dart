import 'package:flutter/material.dart';
import '../features/circles/presentation/screens/circles_screen.dart';
import '../features/create_habit/presentation/screens/create_habit_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/leaderboard/presentation/screens/leaderboard_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 1; // Circles active on cold start

  // IndexedStack keeps every tab's state alive → instant tab switching.
  static const _tabs = <Widget>[
    HomeScreen(),
    CirclesScreen(),
    LeaderboardScreen(),
    ProfileScreen(),
  ];

  void _openCreateHabit() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CreateHabitScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showFab = _index == 0 || _index == 1;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: IndexedStack(index: _index, children: _tabs),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 220),
        offset: showFab ? Offset.zero : const Offset(0, 1.5),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: showFab ? 1 : 0,
          child: IgnorePointer(
            ignoring: !showFab,
            child: FloatingActionButton(
              onPressed: _openCreateHabit, // ← wired up
              backgroundColor: const Color(0xFF7C4DFF),
              elevation: 8,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, size: 30, color: Colors.white),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _BottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF080F20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onTap,
        selectedItemColor: const Color(0xFF7C4DFF),
        unselectedItemColor: const Color(0xFF6F7B9A),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            activeIcon: Icon(Icons.group_rounded),
            label: 'Circles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart_rounded),
            activeIcon: Icon(Icons.insert_chart_rounded),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
