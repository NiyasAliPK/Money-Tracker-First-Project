import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management_app_using_flutter/Screens/screen_navigation.dart';
import 'package:money_management_app_using_flutter/Widgets/screen_add_transactions/text_fields.dart';
import 'package:money_management_app_using_flutter/functions/db/db_category_functions.dart';
import 'package:money_management_app_using_flutter/functions/db/db_transaction_functions.dart';
import 'package:money_management_app_using_flutter/functions/functions.dart';
import 'package:money_management_app_using_flutter/models/category_model.dart';
import 'package:money_management_app_using_flutter/models/transaction_model.dart';
import 'package:money_management_app_using_flutter/screens/screen_viewall_transactions.dart';

class ScreenEditTransactions extends StatefulWidget {
  final TransactionModel data;
  final bool isViewAllPage;
  const ScreenEditTransactions(
      {Key? key, required this.data, required this.isViewAllPage})
      : super(key: key);

  @override
  State<ScreenEditTransactions> createState() =>
      _ScreenEditTransactionssState();
}

class _ScreenEditTransactionssState extends State<ScreenEditTransactions> {
  Object? selectedCatModelID;
  late CategoryModel selectedCategoryModel;
  final amountFromController = TextEditingController();
  final remarksFromController = TextEditingController();
  DateTime datePicked = DateTime.now();
  bool dateChanged = false;
  @override
  @override
  void initState() {
    super.initState();
    amountFromController.text = widget.data.amount.toString();
    remarksFromController.text = widget.data.remarks;
    selectedCategoryModel = widget.data.category;
  }

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
          title: const Text("Edit Transactions"),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Container(
              width: 350,
              height: 350,
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
                    end: Alignment.bottomCenter),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          _datePicker(context);
                        },
                        icon: const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.white,
                        ),
                        label: Text(
                          dateChanged == false
                              ? "${widget.data.date.day}-${widget.data.date.month}-${widget.data.date.year}"
                              : "${datePicked.day}-${datePicked.month}-${datePicked.year}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Category',
                              style: TextStyle(color: Colors.white),
                            ),
                            Flexible(child: Obx(() {
                              WidgetsBinding.instance!.addPostFrameCallback(
                                (timeStamp) {
                                  CategoryDatabase.instance.refreshUi();
                                  CategoryDatabase.instance.getAllCategories();
                                },
                              );
                              return DropdownButton(
                                  hint: Text(widget.data.category.name),
                                  value: selectedCatModelID,
                                  items: widget.data.type ==
                                          CategoryType.expense
                                      ? CategoryDatabase
                                          .instance.expenseCatsList
                                          .map((e) {
                                          return DropdownMenuItem<String>(
                                            onTap: () {
                                              selectedCategoryModel = e;
                                            },
                                            child: Text(e.name),
                                            value: e.id,
                                          );
                                        }).toList()
                                      : CategoryDatabase.instance.incomeCatsList
                                          .map((e) {
                                          return DropdownMenuItem<String>(
                                            onTap: () {
                                              selectedCategoryModel = e;
                                            },
                                            child: Text(e.name),
                                            value: e.id,
                                          );
                                        }).toList(),
                                  onChanged: (selectedValue) {
                                    setState(() {
                                      selectedCatModelID = selectedValue;
                                    });
                                  });
                            }))
                          ],
                        ),
                        InputFields(
                            controller: amountFromController,
                            titleText: 'Amount',
                            isDense: false,
                            keyboardType: TextInputType.number),
                        const SizedBox(height: 15),
                        InputFields(
                          controller: remarksFromController,
                          titleText: 'Remarks',
                          isDense: true,
                          keyboardType: TextInputType.text,
                          sizeForTextField: 30.0,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.black),
                                  onPressed: () async {
                                    await checkBeforeAdding();

                                    widget.isViewAllPage == true
                                        ? Get.off(() =>
                                            const ScreenViewAllTransactions())
                                        : Get.offAll(() => ScreenNavigation());
                                  },
                                  icon: const Icon(Icons.update),
                                  label: const Text('Update')),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _datePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != datePicked) {
      setState(() {
        datePicked = picked;
        dateChanged = true;
      });
    }
  }

  checkBeforeAdding() async {
    final parsedAmount = double.tryParse(amountFromController.text);
    if (parsedAmount == null) {
      return;
    }

    if (remarksFromController.text.isEmpty) {
      return;
    }
    final newTrans = TransactionModel(
        id: widget.data.id,
        date: datePicked,
        type: widget.data.type,
        category: selectedCategoryModel,
        amount: parsedAmount,
        remarks: remarksFromController.text.toString(),
        image: widget.data.image);

    await TransactionDatabase.instance.editTransactions(newTrans);

    await TransactionDatabase.instance.piedata();
    CommonFunctions.instance.successSnackBar(context);
  }
}
