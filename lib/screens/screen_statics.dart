import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management_app_using_flutter/Widgets/screen_statics/expense_tab.dart';
import 'package:money_management_app_using_flutter/Widgets/screen_statics/income_tab.dart';
import 'package:money_management_app_using_flutter/Widgets/screen_statics/overall_tab.dart';
import 'package:money_management_app_using_flutter/screens/screen_viewall_transactions.dart';

class ScreenStatics extends StatefulWidget {
  const ScreenStatics({Key? key}) : super(key: key);

  @override
  State<ScreenStatics> createState() => _ScreenStaticsState();
}

class _ScreenStaticsState extends State<ScreenStatics> {
  dynamic dropdownvalue = 'All';
  int selectedPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: selectedPageIndex,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(100, 150),
          child: AppBar(
            actions: [
              TextButton.icon(
                  style: TextButton.styleFrom(primary: Colors.black),
                  onPressed: () {
                    Get.to(() => const ScreenViewAllTransactions());
                  },
                  icon: const Icon(Icons.remove_red_eye),
                  label: const Text('View All'))
            ],
            title: const Text('STATS',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            bottom: TabBar(
              onTap: ((index) {
                setState(() {
                  selectedPageIndex = index;
                });
              }),
              indicatorColor: Colors.black,
              tabs: const [
                Tab(text: "Overall"),
                Tab(text: "Income"),
                Tab(text: "Expense")
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: TabBarView(children: [OverallTab(), IncomeTab(), ExpenseTab()]),
      ),
    );
  }
}
