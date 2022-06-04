import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:money_management_app_using_flutter/Widgets/list_tiles_for_all.dart';
import 'package:money_management_app_using_flutter/functions/db/db_transaction_functions.dart';

// ignore: must_be_immutable
class IncomeTabViewAll extends StatelessWidget {
  final String selectedPeriod;

  const IncomeTabViewAll({Key? key, required this.selectedPeriod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
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
        return (TransactionDatabase.instance.incomeTransactionList.isEmpty &&
                TransactionDatabase.instance.periodSortedlsit.isEmpty)
            ? Center(
                child: Lottie.asset('assets/animations/85023-no-data.json'),
              )
            : ListView.builder(
                itemCount: selectedPeriod == 'All'
                    ? TransactionDatabase.instance.incomeTransactionList.length
                    : TransactionDatabase.instance.periodSortedlsit.length,
                itemBuilder: (BuildContext context, int index) {
                  final newList = selectedPeriod == 'All'
                      ? TransactionDatabase
                          .instance.incomeTransactionList.reversed
                      : TransactionDatabase.instance.periodSortedlsit.reversed;
                  final data = newList.elementAt(index);
                  return ListCards(
                    isViewAllPage: true,
                    textColor: Colors.green,
                    data: data,
                    selectedPageIndex: 1,
                    selectedPeriod: selectedPeriod,
                  );
                },
              );
      }),
    );
  }
}
