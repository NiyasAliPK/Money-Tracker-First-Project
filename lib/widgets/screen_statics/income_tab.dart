import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:money_management_app_using_flutter/Widgets/list_tiles_for_all.dart';
import 'package:money_management_app_using_flutter/functions/db/db_transaction_functions.dart';
import 'package:pie_chart/pie_chart.dart';

// ignore: must_be_immutable
class IncomeTab extends StatelessWidget {
  final Map<String, double> dataMap = {
    'category': 60.0,
    'Category1': 20.0,
    'Category2': 10.0,
    'Category3': 10.0
  };

  IncomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                Obx(() {
                  return PieChart(
                    chartRadius: MediaQuery.of(context).size.width / 2.5,
                    dataMap: TransactionDatabase.instance.incallMap.isEmpty
                        ? dataMap
                        : TransactionDatabase.instance.incallMap,
                  );
                })
              ],
            )),
        Expanded(
          child: Container(
              width: 350,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                      colors: [Color(0xFF6DD5ED), Color(0xFF2193B0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)),
              child: Obx(() {
                WidgetsBinding.instance!.addPostFrameCallback(
                  (timeStamp) {
                    TransactionDatabase.instance.getAlltransactions();
                    TransactionDatabase.instance.refreshUiForTransaction();
                  },
                );
                return (TransactionDatabase
                        .instance.incomeTransactionList.isEmpty)
                    ? Center(
                        child: Lottie.asset(
                            'assets/animations/85023-no-data.json'),
                      )
                    : ListView.builder(
                        itemCount: TransactionDatabase
                                    .instance.incomeTransactionList.length <
                                5
                            ? TransactionDatabase
                                .instance.incomeTransactionList.length
                            : 5,
                        itemBuilder: (BuildContext context, int index) {
                          final newList = TransactionDatabase
                              .instance.incomeTransactionList.reversed;
                          final data = newList.elementAt(index);
                          return ListCards(
                            selectedPeriod: "All",
                            selectedPageIndex: 1,
                            isViewAllPage: false,
                            textColor: Colors.green,
                            data: data,
                          );
                        },
                      );
              })),
        )
      ],
    );
  }
}
