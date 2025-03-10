import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/features/quran/presentation/pages/quran_search_screen.dart';
import 'package:ramadan_app/features/quran/presentation/widgets/bookmark_listview.dart';
import 'package:ramadan_app/features/quran/presentation/widgets/jozz_listview.dart';
import 'package:ramadan_app/features/quran/presentation/widgets/surah_listview.dart';

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
            PersistentNavBarNavigator.pushNewScreen(
              context,
              withNavBar: false,
              screen: QuranSearchScreen(),
            );
          },
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
