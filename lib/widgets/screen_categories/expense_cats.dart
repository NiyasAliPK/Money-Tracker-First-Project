import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:money_management_app_using_flutter/Widgets/list_tiles_for_all.dart';
import 'package:money_management_app_using_flutter/functions/db/db_category_functions.dart';
import 'package:money_management_app_using_flutter/functions/db/db_transaction_functions.dart';
import 'package:money_management_app_using_flutter/models/category_model.dart';

class ExpenseCats extends StatefulWidget {
  const ExpenseCats({Key? key}) : super(key: key);

  @override
  State<ExpenseCats> createState() => _ExpenseCatsState();
}

class _ExpenseCatsState extends State<ExpenseCats> {
  String catsOfExpense = 'Category';

  int isCatSelected = -1;
  bool isbuttonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        SizedBox(
            height: 180,
            child: Obx(() {
              WidgetsBinding.instance!.addPostFrameCallback(
                (timeStamp) {
                  CategoryDatabase.instance.getAllCategories();
                  CategoryDatabase.instance.refreshUi();
                },
              );
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 50,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 50),
                itemCount: CategoryDatabase.instance.expenseCatsList.length,
                itemBuilder: (BuildContext context, int index) {
                  final data = CategoryDatabase.instance.expenseCatsList[index];
                  final catName = data.name;
                  return ElevatedButton(
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Delete Categories'),
                                content: const Text(
                                    'Do you want to delete this category ? If deleted this category will not be shown in Diagrams.',
                                    style: TextStyle(height: 2)),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        final temp = CategoryModel(
                                            id: data.id,
                                            name: data.name,
                                            type: data.type,
                                            isDeleted: true);
                                        await CategoryDatabase.instance
                                            .deleteSelectedCat(temp);
                                        Get.back();
                                      },
                                      child: const Text('Yes')),
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('No'))
                                ],
                              );
                            });
                      },
                      style: ElevatedButton.styleFrom(
                          primary: isCatSelected == index
                              ? Colors.black
                              : const Color.fromARGB(255, 245, 79, 67)),
                      onPressed: () {
                        setState(() {
                          isCatSelected = index;
                          isbuttonPressed = true;
                        });
                        final selectedCatName = data.name;
                        TransactionDatabase.instance
                            .sortForSelectedCat(selectedCatName, 1);
                      },
                      child: Text(catName));
                },
              );
            })),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                        colors: [Color(0xFF6DD5ED), Color(0xFF2193B0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)),
                child: Obx(() {
                  WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                    TransactionDatabase.instance.getAlltransactions();
                    TransactionDatabase.instance.refreshUiForTransaction();
                  });
                  return (TransactionDatabase
                              .instance.expenseTransactionList.isEmpty ||
                          TransactionDatabase.instance.selectedCatTrans.isEmpty)
                      ? Center(
                          child: Lottie.asset(
                              'assets/animations/85023-no-data.json'),
                        )
                      : ListView.builder(
                          itemCount: isbuttonPressed == false
                              ? TransactionDatabase
                                  .instance.expenseTransactionList.length
                              : TransactionDatabase
                                  .instance.selectedCatTrans.length,
                          itemBuilder: (BuildContext context, int index) {
                            final data = isbuttonPressed == false
                                ? TransactionDatabase
                                    .instance.expenseTransactionList[index]
                                : TransactionDatabase
                                    .instance.selectedCatTrans[index];

                            return ListCards(
                              isViewAllPage: false,
                              textColor: Colors.red,
                              data: data,
                            );
                          },
                        );
                })),
          ),
        )
      ],
    );
  }
}
