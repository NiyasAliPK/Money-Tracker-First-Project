import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management_app_using_flutter/Widgets/screen_add_transactions/text_fields.dart';
import 'package:money_management_app_using_flutter/controller/getx_controller.dart';
import 'package:money_management_app_using_flutter/functions/db/db_category_functions.dart';
import 'package:money_management_app_using_flutter/functions/db/db_transaction_functions.dart';
import 'package:money_management_app_using_flutter/functions/functions.dart';
import 'package:money_management_app_using_flutter/models/category_model.dart';
import 'package:money_management_app_using_flutter/models/transaction_model.dart';
import 'package:money_management_app_using_flutter/screens/screen_navigation.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({Key? key}) : super(key: key);

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  DateTime datePicked = DateTime.now();
  dynamic dropdownvalue = 'Select Category';
  Object? selectedCatModelID;
  CategoryModel? selectedCategoryModel;
  final amountFromController = TextEditingController();
  final remarksFromController = TextEditingController();
  String hintText = 'Select Category';
  bool addBillClicked = false;
  final ControllerGetX _controller = Get.put(ControllerGetX());
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(20, 80, 20, 0),
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
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
          child: Column(
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
                      "${datePicked.day}-${datePicked.month}-${datePicked.year}",
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
                              TransactionDatabase.instance.getAlltransactions();
                              CategoryDatabase.instance.refreshUi();
                            },
                          );
                          return DropdownButton(
                              hint: Text(hintText),
                              value: selectedCatModelID,
                              items: CategoryDatabase.instance.expenseCatsList
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
                        })),
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
                      titleText: 'Remark',
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
                              onPressed: () {
                                _checkBeforeAdding();
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add')),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.black),
                onPressed: () async {
                  setState(() {
                    addBillClicked = true;
                    img = '';
                  });
                  await _controller.pickimage();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text(img.isEmpty ? "No image added" : "Image added"),
                    action: SnackBarAction(
                      label: 'Ok',
                      onPressed: () {},
                    ),
                  ));
                },
                child: const Text(
                  'Add Bill (optional)',
                )),
          ],
        )
      ],
    );
  }

  _datePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != datePicked) {
      setState(() {
        datePicked = picked;
      });
    }
  }

  _checkBeforeAdding() async {
    final parsedAmount = double.tryParse(amountFromController.text);
    if (parsedAmount == null) {
      CommonFunctions.instance
          .failedSnackBar(context, "Please input a proper amount.");
      return;
    }
    if (selectedCategoryModel == null) {
      CommonFunctions.instance
          .failedSnackBar(context, "Please select a category.");
      return;
    }
    if (remarksFromController.text.isEmpty) {
      CommonFunctions.instance
          .failedSnackBar(context, "Please add a remark to your transaction.");
      return;
    }
    final newTrans = TransactionModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        category: selectedCategoryModel!,
        date: datePicked,
        type: CategoryType.expense,
        amount: parsedAmount,
        remarks: remarksFromController.text.toString(),
        image: addBillClicked == true ? img : '');

    await TransactionDatabase.instance.addTransactions(newTrans);
    await TransactionDatabase.instance.piedata();
    CommonFunctions.instance.successSnackBar(context);
    setState(() {});
    Get.off(() => ScreenNavigation());
  }
}
