import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management_app_using_flutter/Widgets/list_tiles_for_all.dart';
import 'package:money_management_app_using_flutter/Widgets/screen_home/amount_cards.dart';
import 'package:money_management_app_using_flutter/functions/db/db_category_functions.dart';
import 'package:money_management_app_using_flutter/functions/db/db_transaction_functions.dart';
import 'package:money_management_app_using_flutter/functions/functions.dart';
import 'package:money_management_app_using_flutter/models/category_model.dart';
import 'package:money_management_app_using_flutter/models/transaction_model.dart';
import 'package:money_management_app_using_flutter/screens/screen_viewall_transactions.dart';
import 'package:lottie/lottie.dart';

double totalAmount = 0;

double totalIncome = 0;

double totalExpense = 0;

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  @override
  @override
  Widget build(BuildContext context) {
    CategoryDatabase.instance.getAllCategories();
    totalBalaceCalculation(TransactionDatabase.instance.allTransactionList);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              height: 70,
            ),
            Text(
              'MONEY TRACKER',
              style: TextStyle(
                  fontFamily: 'ZenDots', fontSize: 30, color: Colors.white),
            ),
          ],
        ),
        Column(
          children: [
            AmountCards(
              cardWidth: 350,
              cardheight: 140,
              cardColor: const Color.fromARGB(255, 244, 247, 159),
              title: 'Total Balance',
              amount: totalAmount,
              textSize: 25,
              titleColor: Colors.black,
              amountColor: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AmountCards(
                  cardWidth: 150,
                  cardheight: 100,
                  cardColor: const Color.fromARGB(255, 172, 250, 194),
                  title: 'Income',
                  amount: totalIncome,
                  textSpacing: 15,
                  textSize: 20,
                  titleColor: const Color.fromARGB(255, 0, 165, 5),
                  amountColor: const Color.fromARGB(255, 0, 165, 5),
                ),
                AmountCards(
                  cardWidth: 150,
                  cardheight: 100,
                  cardColor: const Color.fromARGB(255, 245, 173, 173),
                  title: 'Expense',
                  amount: totalExpense,
                  textSpacing: 15,
                  textSize: 20,
                  titleColor: const Color.fromARGB(255, 255, 17, 0),
                  amountColor: const Color.fromARGB(255, 255, 17, 0),
                )
              ],
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Recent Transactions'),
            TextButton.icon(
                style: TextButton.styleFrom(primary: Colors.black),
                onPressed: () {
                  Get.to(() => const ScreenViewAllTransactions());
                },
                icon: const Icon(
                  Icons.remove_red_eye,
                ),
                label: const Text('View All'))
          ],
        ),
        Expanded(
          child: Container(
              width: 350,
              height: 234,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                      colors: [Color(0xFF6DD5ED), Color(0xFF2193B0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)),
              child: Obx(() {
                TransactionDatabase.instance.getAlltransactions();
                return TransactionDatabase.instance.allTransactionList.isEmpty
                    ? Center(
                        child: Lottie.asset(
                            'assets/animations/85023-no-data.json'),
                      )
                    : ListView.builder(
                        itemCount: TransactionDatabase
                                    .instance.allTransactionList.length <
                                5
                            ? TransactionDatabase
                                .instance.allTransactionList.length
                            : 5,
                        itemBuilder: (BuildContext context, int index) {
                          final newList = TransactionDatabase
                              .instance.allTransactionList.reversed;
                          final data = newList.elementAt(index);
                          totalBalaceCalculation(
                              TransactionDatabase.instance.allTransactionList);
                          return ListCards(
                            isViewAllPage: false,
                            textColor: data.type == CategoryType.income
                                ? Colors.green
                                : Colors.red,
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

totalBalaceCalculation(RxList allTransactionList) {
  totalAmount = 0;
  totalExpense = 0;
  totalIncome = 0;
  CommonFunctions.instance.totalExpense = 0;
  CommonFunctions.instance.totalIncome = 0;
  for (TransactionModel data in allTransactionList) {
    if (data.category.type == CategoryType.income) {
      totalIncome = totalIncome + data.amount;
      totalAmount = totalAmount + data.amount;
    } else {
      totalExpense = totalExpense + data.amount;
      totalAmount = totalAmount - data.amount;
    }
  }
  CommonFunctions.instance.totalExpense = totalExpense;
  CommonFunctions.instance.totalIncome = totalIncome;
}
