import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management_app_using_flutter/models/category_model.dart';

class CategoryDatabase {
  RxList<CategoryModel> allCatsList = <CategoryModel>[].obs;
  RxList<CategoryModel> incomeCatsList = <CategoryModel>[].obs;
  RxList<CategoryModel> expenseCatsList = <CategoryModel>[].obs;

  CategoryDatabase.internal();
  static CategoryDatabase instance = CategoryDatabase.internal();
  factory CategoryDatabase() {
    return instance;
  }

  addCategories(CategoryModel newCat) async {
    final catsDb = await Hive.openBox<CategoryModel>('TransactionDB');
    await catsDb.put(newCat.id, newCat);
    refreshUi();
  }

  getAllCategories() async {
    final catsDb = await Hive.openBox<CategoryModel>('TransactionDB');
    allCatsList.clear();
    allCatsList.addAll(catsDb.values);
    await refreshUi();
  }

  deleteSelectedCat(CategoryModel value) async {
    final catsDb = await Hive.openBox<CategoryModel>('TransactionDB');
    await catsDb.put(value.id, value);
  }

  Future<void> refreshUi() async {
    expenseCatsList.clear();
    incomeCatsList.clear();
    Future.forEach(allCatsList, (CategoryModel category) {
      if (category.type == CategoryType.income && category.isDeleted == false) {
        incomeCatsList.add(category);
      } else if (category.type == CategoryType.expense &&
          category.isDeleted == false) {
        expenseCatsList.add(category);
      }
    });
  }

  categoryDatabaseClear() async {
    final catsDb = await Hive.openBox<CategoryModel>('TransactionDB');
    await catsDb.clear();
  }
}
