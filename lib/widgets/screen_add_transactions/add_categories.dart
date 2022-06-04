import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management_app_using_flutter/functions/db/db_category_functions.dart';
import 'package:money_management_app_using_flutter/functions/db/db_transaction_functions.dart';
import 'package:money_management_app_using_flutter/functions/functions.dart';
import 'package:money_management_app_using_flutter/models/category_model.dart';
import 'package:money_management_app_using_flutter/screens/screen_add_transactions.dart';

// ignore: must_be_immutable
class AddNewCats extends StatefulWidget {
  bool fromcatPage;
  int pageNumber;
  AddNewCats({Key? key, required this.fromcatPage, required this.pageNumber})
      : super(key: key);
  @override
  State<AddNewCats> createState() => _AddNewCatsState();
}

class _AddNewCatsState extends State<AddNewCats> {
  CategoryType _selectedType = CategoryType.expense;

  final _newCatName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF2193B0), Color(0xFF6DD5ED)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Add New Categories"),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(255, 161, 161, 161),
                        spreadRadius: 1,
                        blurStyle: BlurStyle.normal,
                        blurRadius: 20)
                  ],
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                      colors: [Color(0xFF6DD5ED), Color(0xFF2193B0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      controller: _newCatName,
                      maxLength: 10,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'New Category',
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                          value: CategoryType.income,
                          groupValue: _selectedType,
                          onChanged: (CategoryType? value) {
                            setState(() {
                              _selectedType = value!;
                            });
                          }),
                      const Text('Income'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                          value: CategoryType.expense,
                          groupValue: _selectedType,
                          onChanged: (CategoryType? value) {
                            setState(() {
                              _selectedType = value!;
                            });
                          }),
                      const Text('Expense'),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _checkBeforeAdd();
                    },
                    child: const Text('Add'),
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _checkBeforeAdd() async {
    final name = _newCatName.text;
    if (name.isEmpty) {
      CommonFunctions.instance
          .failedSnackBar(context, "Please enter a Category name.");
      return;
    }
    await TransactionDatabase.instance.getAlltransactions();
    for (var data in TransactionDatabase.instance.allTransactionList) {
      if (data.category.name.toString().trim().toLowerCase() ==
              name.toString().trim().toLowerCase() &&
          data.category.type == _selectedType) {
        CommonFunctions.instance
            .failedSnackBar(context, "The entered Category already exist.");
        return;
      }
    }
    final CategoryModel newCat = CategoryModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name,
        type: _selectedType);
    await CategoryDatabase.instance.addCategories(newCat);
    if (widget.fromcatPage == true) {
      setState(() {});
      Get.back();
      CategoryDatabase.instance.refreshUi();
    } else {
      if (_selectedType == CategoryType.income) {
        setState(() {
          widget.pageNumber = 0;
        });
      } else if (_selectedType == CategoryType.expense) {
        setState(() {
          widget.pageNumber = 1;
        });
      }
      Get.offAll(() => ScreenAddTransactions(
            selectedpage: widget.pageNumber,
          ));
      CategoryDatabase.instance.refreshUi();
      setState(() {});
    }
  }
}
