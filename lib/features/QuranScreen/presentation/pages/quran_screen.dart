import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:quran_library/quran.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/extensions/int_extensions.dart';
import 'package:ramadan_app/core/extensions/widget_extensions.dart';
import 'package:ramadan_app/features/QuranScreen/presentation/pages/surah_screen.dart';
import 'package:ramadan_app/features/QuranScreen/presentation/widgets/bookmark_listview.dart';
import 'package:ramadan_app/features/QuranScreen/presentation/widgets/jozz_listview.dart';
import 'package:ramadan_app/features/QuranScreen/presentation/widgets/surah_listview.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_text_style.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: _selectedIndex,
      vsync: this,
      length: 3,
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  final List<Widget> _bodyList = [
    JozzListViewWidget(),
    SuraListViewWidget(),
    BookMarkListViewWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _buildAppBar(context),
        // drawer: DrawarQuran("ar", context.isDark),
        body: _bodyList[_selectedIndex],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        AppStrings.quran,
        style: StyleText.extraBold34().copyWith(
          color: Colors.white,
          fontFamily: "Amiri",
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            showSearch(
              context: context,
              delegate: CustomSearchDelegate(context: context),
            );
          },
          // => PersistentNavBarNavigator.pushNewScreen(
          //   context,
          //   withNavBar: true,
          //   screen: QuranSearchScreen(),
          // ),
        ),
      ],
      centerTitle: true,
      elevation: 0,
      backgroundColor: context.primaryColor.withAlpha(120),
      toolbarHeight: 98.h,
      bottom: TabBar(
        controller: _tabController,
        onTap: _onItemTapped,
        indicatorColor: context.primaryColor,
        unselectedLabelColor: context.onPrimaryColor,
        labelColor: context.primaryColor,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerHeight: 1.5.h,
        indicator: BoxDecoration(
          color: context.primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r),
            topRight: Radius.circular(10.r),
          ),
        ),
        dividerColor: context.primaryColor,
        tabs: [
          _buildTab('الأجزاء'),
          _buildTab("السور"),
          _buildTab("المحفوظات"),
        ],
      ),
    );
  }

  Tab _buildTab(String title) {
    return Tab(
      icon: Text(
        title,
        style: StyleText.medium18().copyWith(color: Colors.white),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final BuildContext context;

  CustomSearchDelegate({required this.context});
  @override
  String? get searchFieldLabel => "ابحث عن أيه..";
  @override
  bool get enableSuggestions => true;
  @override
  TextStyle? get searchFieldStyle => StyleText.regular20().copyWith(
    color: context.onPrimaryColor,
    fontFamily: "Amiri",
  );
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      inputDecorationTheme: InputDecorationTheme(border: InputBorder.none),
      brightness: context.isDark ? Brightness.dark : Brightness.light,
      appBarTheme: AppBarTheme(
        backgroundColor: context.primaryColor.withAlpha(200),
        foregroundColor: context.onPrimaryColor,
        toolbarHeight: 75.h,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Text(
          "مسح",
          style: StyleText.regular18().copyWith(
            color: context.onPrimaryColor,
            fontFamily: "Amiri",
          ),
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("test");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    String removeDiacritics(String text) {
      final diacritics = RegExp(r'[\u064B-\u0652]');
      return text.replaceAll(diacritics, '');
    }

    query = query.trim();
    query = removeDiacritics(query);
    List<AyahModel> searchResult = QuranLibrary().search(query);
    return query.isEmpty
        ? Center(
          child: Column(
            children: [
              200.hSpace,
              Text(
                "أبدء بالبحث الان عن اي أيه تريدها...",
                textAlign: TextAlign.center,
                style: StyleText.medium22().copyWith(
                  fontFamily: "Amiri",
                  color: context.onPrimaryColor,
                ),
              ),
            ],
          ),
        )
        : searchResult.isEmpty
        ? Center(
          child: Column(
            children: [
              200.hSpace,
              Text(
                "لا يوجد نتائج بحث بهذه الكلمات\nجرب مرة اخرى !!!",
                textAlign: TextAlign.center,
                style: StyleText.medium22().copyWith(
                  fontFamily: "Amiri",
                  color: context.onPrimaryColor,
                ),
              ).paddingAll(20),
            ],
          ),
        )
        : ListView.builder(
          itemCount: searchResult.length,
          itemBuilder:
              (context, index) => Container(
                color:
                    index.isEven
                        ? context.primaryColor.withAlpha(30)
                        : Colors.transparent,
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        searchResult[index].text.replaceAll('\n', ' '),
                        style: QuranLibrary().hafsStyle.copyWith(
                          color: context.onPrimaryColor,
                        ),
                      ),
                      subtitle: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "سورة ${searchResult[index].arabicName}",
                          style: StyleText.medium16().copyWith(
                            fontFamily: "Amiri",
                            color: context.onPrimaryColor,
                          ),
                        ).paddingSymmetric(horizontal: 10.w, vertical: 5.h),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 5.h,
                      ),
                      onTap: () async {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          withNavBar: false,
                          screen: SurahScreen(),
                        );
                        QuranLibrary().jumpToAyah(searchResult[index]);
                      },
                    ),
                    Divider(
                      color: context.onPrimaryColor.withAlpha(110),
                      thickness: .5,
                      height: 1,
                    ),
                  ],
                ),
              ),
        );
  }
}
