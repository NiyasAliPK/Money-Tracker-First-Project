import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management_app_using_flutter/Widgets/screen_add_transactions/add_categories.dart';
import 'package:money_management_app_using_flutter/Widgets/screen_categories/expense_cats.dart';
import 'package:money_management_app_using_flutter/Widgets/screen_categories/income_cats.dart';

// ignore: must_be_immutable
class ScreenCategories extends StatelessWidget {
  ScreenCategories({Key? key}) : super(key: key);
  int selectedPageIndex = 1;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: selectedPageIndex,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size(100, 170),
          child: AppBar(
            actions: [
              TextButton.icon(
                  style: TextButton.styleFrom(primary: Colors.black),
                  onPressed: () {
                    Get.to(AddNewCats(
                      pageNumber: -1,
                      fromcatPage: true,
                    ));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add New'))
            ],
            title: const Text('All Categories',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Tooltip(
                    showDuration: Duration(seconds: 3),
                    margin: EdgeInsets.all(30),
                    child: Icon(Icons.question_mark_outlined),
                    message: 'Click on category name to show transactions.',
                    triggerMode: TooltipTriggerMode.tap,
                  ),
                )
              ],
            ),
            bottom: TabBar(
              onTap: (index) {
                selectedPageIndex = index;
              },
              indicatorColor: Colors.black,
              tabs: const [Tab(text: "Income"), Tab(text: "Expense")],
            ),
          ),
        ),
        body: const SafeArea(
          child: TabBarView(children: [IncomeCats(), ExpenseCats()]),
        ),
      ),
    );
  }
}
