import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management_app_using_flutter/Screens/screen_add_transactions.dart';
import 'package:money_management_app_using_flutter/Screens/screen_categories.dart';
import 'package:money_management_app_using_flutter/Screens/screen_home.dart';
import 'package:money_management_app_using_flutter/Screens/screen_settings.dart';
import 'package:money_management_app_using_flutter/Screens/screen_statics.dart';

class ScreenNavigation extends StatelessWidget {
  ScreenNavigation({Key? key}) : super(key: key);
  static ValueNotifier<int> selectedPageIndex = ValueNotifier(0);
  final _pages = [
    const ScreenHome(),
    const ScreenStatics(),
    ScreenCategories(),
    const ScreenSettings()
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF2193B0), Color(0xFF6DD5ED)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Get.to(() => const ScreenAddTransactions());
          },
          child: const Icon(
            Icons.add,
            size: 40,
          ),
        ),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: ScreenNavigation.selectedPageIndex,
          builder: (BuildContext context, int updatedIndex, Widget? _) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BottomNavigationBar(
                    currentIndex: updatedIndex,
                    onTap: ((newIndex) {
                      ScreenNavigation.selectedPageIndex.value = newIndex;
                    }),
                    type: BottomNavigationBarType.fixed,
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: 'Home'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.pie_chart), label: 'Stats'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.category), label: 'Category'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.settings), label: 'Settings'),
                    ]),
              ),
            );
          },
        ),
        body: SafeArea(
          child: ValueListenableBuilder(
            valueListenable: selectedPageIndex,
            builder: (BuildContext context, int updatedIndex, Widget? _) {
              return _pages[updatedIndex];
            },
          ),
        ),
      ),
    );
  }
}
