import 'package:client/feature/core/theme/app_pallette.dart';
import 'package:client/feature/home/view/pages/library_page.dart';
import 'package:client/feature/home/view/pages/songs_page.dart';
import 'package:client/feature/home/view/widgets/music_slab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIndex = 0;
  final pages = const [SongPage(), LibraryPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[selectedIndex],

          const Positioned(bottom: 0, child: MusicSlab()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: selectedIndex == 0
                ? Icon(Icons.home_filled)
                : Icon(
                    Icons.home_outlined,
                    color: selectedIndex == 0
                        ? Pallete.whiteColor
                        : Pallete.inactiveBottomBarItemColor,
                  ),
            // icon: Image.asset(
            //   selectedIndex == 0
            //       ? 'assets/ima/home_filled.png'
            //       : 'assets/ima/home_unfilled.png',
            //   color: selectedIndex == 0
            //       ? Pallete.whiteColor
            //       : Pallete.inactiveBottomBarItemColor,
            // ),
          ),
          BottomNavigationBarItem(
            label: 'Library',
            icon: Icon(
              Icons.library_music,
              // icon: Image.asset(
              //   'assets/images/library.png',
              color: selectedIndex == 1
                  ? Pallete.whiteColor
                  : Pallete.inactiveBottomBarItemColor,
            ),
          ),
        ],
      ),
    );
  }
}
