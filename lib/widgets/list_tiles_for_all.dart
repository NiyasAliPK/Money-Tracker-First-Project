import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_management_app_using_flutter/Screens/screen_edit_transaction.dart';
import 'package:money_management_app_using_flutter/Screens/screen_navigation.dart';
import 'package:money_management_app_using_flutter/Screens/screen_show_bill.dart';
import 'package:money_management_app_using_flutter/functions/db/db_transaction_functions.dart';
import 'package:money_management_app_using_flutter/functions/functions.dart';
import 'package:money_management_app_using_flutter/models/transaction_model.dart';
import 'package:money_management_app_using_flutter/screens/screen_details.dart';
import 'package:money_management_app_using_flutter/screens/screen_home.dart';

class ListCards extends StatefulWidget {
  final Color? textColor;
  final TransactionModel data;
  final bool isViewAllPage;
  final String selectedPeriod;
  final int selectedPageIndex;
  const ListCards(
      {Key? key,
      required this.isViewAllPage,
      this.textColor,
      required this.data,
      this.selectedPageIndex = 0,
      this.selectedPeriod = "All"})
      : super(key: key);

  @override
  State<ListCards> createState() => _ListCardsState();
}

class _ListCardsState extends State<ListCards> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
      child: Slidable(
        actionPane: const SlidableDrawerActionPane(),
        actions: [
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete'),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              await TransactionDatabase.instance
                                  .deleteSelectedTransaction(widget.data.id);
                              await TransactionDatabase.instance.piedata();
                              await TransactionDatabase.instance.sortorPeriod(
                                  selectedPeriod: widget.selectedPeriod,
                                  selectedPageIndex: widget.selectedPageIndex);
                              widget.isViewAllPage == true ? null : Get.back();
                              totalBalaceCalculation(TransactionDatabase
                                  .instance.allTransactionList);
                              if (widget.isViewAllPage == true) {
                                Get.back();
                              } else if (widget.isViewAllPage == false) {
                                Get.off(() => ScreenNavigation());
                              }
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
          ),
          IconSlideAction(
            caption: 'Edit',
            color: Colors.green,
            icon: Icons.edit,
            onTap: () {
              Get.to(() => ScreenEditTransactions(
                  data: widget.data, isViewAllPage: widget.isViewAllPage));
            },
          )
        ],
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            onLongPress: (() {
              if (widget.data.image == null ||
                  widget.data.image.toString().trim().isEmpty) {
                CommonFunctions.instance.infoSnackBar(context);
              } else {
                Get.to(() => ScreenBillImage(image: widget.data.image!));
              }
            }),
            onTap: (() => Get.to(() => ScreenDetails(
                  data: widget.data,
                ))),
            textColor: widget.textColor,
            leading: CircleAvatar(
                radius: 30,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      parseDate(widget.data.date),
                      style: const TextStyle(fontSize: 14),
                    ),
                    widget.data.image == null ||
                            widget.data.image.toString().trim().isEmpty
                        ? Container()
                        : const Icon(
                            Icons.image,
                            size: 20,
                          ),
                  ],
                )),
            title: AutoSizeText(
              '${widget.data.amount}',
              style: const TextStyle(fontSize: 17),
              minFontSize: 12,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: AutoSizeText(
              widget.data.remarks,
              style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontFamily: 'Releway',
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              minFontSize: 12,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: AutoSizeText(
              widget.data.category.name,
              style: const TextStyle(
                  fontSize: 17,
                  fontFamily: 'Releway',
                  fontWeight: FontWeight.w900),
              minFontSize: 7,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  String parseDate(DateTime date) {
    return DateFormat("dd\nMMM").format(date);
  }
}
