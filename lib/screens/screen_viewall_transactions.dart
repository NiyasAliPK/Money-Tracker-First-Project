import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management_app_using_flutter/functions/db/db_transaction_functions.dart';
import 'package:money_management_app_using_flutter/screens/screen_navigation.dart';
import 'package:money_management_app_using_flutter/widgets/screen_viewall_transactions/expense_tab_viewall.dart';
import 'package:money_management_app_using_flutter/widgets/screen_viewall_transactions/income_tab_viewall.dart';
import 'package:money_management_app_using_flutter/widgets/screen_viewall_transactions/overall_tab_viewall.dart';

class ScreenViewAllTransactions extends StatefulWidget {
  const ScreenViewAllTransactions({Key? key}) : super(key: key);

  @override
  State<ScreenViewAllTransactions> createState() =>
      _ScreenViewAllTransactionsState();
}

class _ScreenViewAllTransactionsState extends State<ScreenViewAllTransactions> {
  List<String> periods = ['All', 'Today', 'Yesterday', 'Month', 'Custom'];
  dynamic dropdownvalue = 'All';
  int selectedPageIndex = 0;
  static DateTimeRange? range;
  static DateTime startDate = DateTime.now().add(const Duration(days: -5));
  static DateTime endDate = DateTime.now();

  @override
  void initState() {
    TransactionDatabase.instance.getAlltransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: selectedPageIndex,
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF6DD5ED), Color(0xFF2193B0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size(100, 170),
            child: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                    onPressed: () {
                      Get.offAll(() => ScreenNavigation());
                    },
                    icon: const Icon(Icons.arrow_back))
              ],
              backgroundColor: Colors.transparent,
              title: const Text('View All',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1)),
              elevation: 0,
              flexibleSpace: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.01,
                      top: MediaQuery.of(context).size.height * 0.10,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      margin: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                      child: DropdownButton(
                        underline: const SizedBox(),
                        alignment: AlignmentDirectional.center,
                        hint: Text(dropdownvalue),
                        items: periods.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) async {
                          setState(() {
                            dropdownvalue = newValue!;
                            TransactionDatabase.instance.sortorPeriod(
                                selectedPeriod: dropdownvalue,
                                selectedPageIndex: selectedPageIndex,
                                start: startDate,
                                end: endDate);
                          });
                          if (dropdownvalue == 'Custom') {
                            await dateRangePicker();
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
              bottom: TabBar(
                onTap: ((index) {
                  setState(() {
                    selectedPageIndex = index;
                  });
                  TransactionDatabase.instance.sortorPeriod(
                      selectedPeriod: dropdownvalue,
                      selectedPageIndex: selectedPageIndex,
                      start: startDate,
                      end: endDate);
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
          body: TabBarView(
            children: [
              OverallTabViewAll(selectedPeriod: dropdownvalue),
              IncomeTabViewAll(selectedPeriod: dropdownvalue),
              ExpenseTabViewAll(selectedPeriod: dropdownvalue)
            ],
            physics: const NeverScrollableScrollPhysics(),
          ),
        ),
      ),
    );
  }

  Future dateRangePicker() async {
    final _initialDateRange = DateTimeRange(
        start: DateTime.now().add(const Duration(days: -2)),
        end: DateTime.now());
    final newdateRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 10),
        lastDate: DateTime.now(),
        initialDateRange: range ?? _initialDateRange);
    if (newdateRange == null) return;
    setState(() {
      range = newdateRange;
      startDate = range!.start;
      endDate = range!.end;
    });
    TransactionDatabase.instance
        .sorbyCustomDate(startDate, endDate, selectedPageIndex);
  }
}
