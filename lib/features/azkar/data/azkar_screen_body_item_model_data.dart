import '../../../core/constants/app_strings.dart';

class AzkarScreenBodyItemModel {
  final String title, image;
  final int id;

  AzkarScreenBodyItemModel({
    required this.title,
    required this.image,
    required this.id,
  });
}

List<AzkarScreenBodyItemModel> azkarScreenBodyItemModel = [
  AzkarScreenBodyItemModel(
    title: AppStrings.azkarAlsabah,
    image: "assets/images/1.jpg",
    id: 0,
  ),
  AzkarScreenBodyItemModel(
    title: AppStrings.azkarAlmasaa,
    image: "assets/images/2.jpg",
    id: 1,
  ),
  AzkarScreenBodyItemModel(
    title: AppStrings.tsabha,
    image: "assets/images/9.jpg",
    id: 2,
  ),
  AzkarScreenBodyItemModel(
    title: AppStrings.azkarAlIstikhaz,
    image: "assets/images/5.jpg",
    id: 3,
  ),
  AzkarScreenBodyItemModel(
    title: AppStrings.azkarAlslah,
    image: "assets/images/6.jpg",
    id: 4,
  ),
  AzkarScreenBodyItemModel(
    title: AppStrings.azkarAlNoom,
    image: "assets/images/3.jpg",
    id: 5,
  ),
  AzkarScreenBodyItemModel(
    title: AppStrings.adaiaAlnabiya,
    image: "assets/images/7.jpg",
    id: 6,
  ),
  AzkarScreenBodyItemModel(
    title: AppStrings.adaiaQarunia,
    image: "assets/images/4.jpg",
    id: 7,
  ),
];
