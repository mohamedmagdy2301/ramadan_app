import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:quran_library/quran.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/extensions/int_extensions.dart';
import 'package:ramadan_app/core/extensions/widget_extensions.dart';
import 'package:ramadan_app/core/utils/functions/convert_num_to_ar.dart';
import 'package:ramadan_app/features/quran/presentation/pages/surah_screen.dart';

class QuranSearchScreen extends StatefulWidget {
  const QuranSearchScreen({super.key});

  @override
  State<QuranSearchScreen> createState() => _QuranSearchScreenState();
}

class _QuranSearchScreenState extends State<QuranSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String query = '';
  @override
  void initState() {
    super.initState();
    query = _controller.text;
  }

  String removeDiacritics(String text) {
    final diacritics = RegExp(r'[\u064B-\u0652]');
    return text.replaceAll(diacritics, '');
  }

  List<AyahModel> searchResults = [];

  @override
  Widget build(BuildContext context) {
    query = query.trim();
    query = removeDiacritics(query);
    searchResults = QuranLibrary().search(query);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          40.hSpace,
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: context.onPrimaryColor),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: StyleText.regular18().copyWith(
                    color: context.onPrimaryColor,
                    fontFamily: "Amiri",
                  ),
                  cursorColor: context.primaryColor,
                  textInputAction: TextInputAction.search,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  textAlignVertical: TextAlignVertical.center,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: false,
                  enableSuggestions: false,
                  autofocus: true,
                  cursorHeight: 25.h,
                  cursorWidth: 1.5.w,
                  cursorRadius: Radius.circular(10.r),
                  showCursor: true,
                  keyboardType: TextInputType.text,
                  onChanged: (value) => setState(() => query = value),
                  onSubmitted: (value) => setState(() => query = value),
                  decoration: InputDecoration(
                    hintText: "ابحث عن ايه في القران",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        width: .4.w,
                        color: context.primaryColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        width: .4.w,
                        color: context.primaryColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        width: .7.w,
                        color: context.primaryColor,
                      ),
                    ),
                    hintStyle: StyleText.regular18().copyWith(
                      color: context.onPrimaryColor,
                      fontFamily: "Amiri",
                    ),
                  ),
                ),
              ),
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
                  setState(() {
                    _controller.clear();
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "نتائج البحث",
                style: StyleText.bold18().copyWith(
                  color: context.onPrimaryColor,
                ),
              ),
              searchResults.isEmpty
                  ? SizedBox()
                  : Text(
                    "${convertNumberToArabic((searchResults.length).toString())} نتائج",
                    style: StyleText.semiBold16().copyWith(
                      color: context.onPrimaryColor,
                    ),
                  ),
            ],
          ).paddingSymmetric(horizontal: 15, vertical: 15),
          Expanded(
            child:
                query.isEmpty
                    ? TextMessageWidget(
                      text: "أبدء بالبحث الان عن اي أيه تريدها...",
                    )
                    : searchResults.isEmpty
                    ? TextMessageWidget(
                      text: "لا يوجد نتائج بحث بهذه الكلمات\nجرب مرة اخرى !!!",
                    )
                    : ListView.builder(
                      itemCount: searchResults.length,
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
                                    searchResults[index].text.replaceAll(
                                      '\n',
                                      ' ',
                                    ),
                                    style: QuranLibrary().hafsStyle.copyWith(
                                      color: context.onPrimaryColor,
                                    ),
                                  ),
                                  subtitle: Row(
                                    spacing: 20.w,
                                    children: [
                                      Text(
                                        "سورة ${searchResults[index].arabicName}",
                                        style: StyleText.bold16().copyWith(
                                          fontFamily: "Amiri",
                                          color: context.onPrimaryColor,
                                        ),
                                      ),
                                      Text(
                                        "رقم الصفحة : ${convertNumberToArabic((searchResults[index].page).toString())}",
                                        style: StyleText.medium16().copyWith(
                                          fontFamily: "Amiri",
                                          color: context.onPrimaryColor,
                                        ),
                                      ),
                                      Text(
                                        "الجزاء رقم : ${convertNumberToArabic((searchResults[index].juz).toString())}",
                                        style: StyleText.medium16().copyWith(
                                          fontFamily: "Amiri",
                                          color: context.onPrimaryColor,
                                        ),
                                      ),
                                    ],
                                  ).paddingTop(20),
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
                                    QuranLibrary().jumpToAyah(
                                      searchResults[index],
                                    );
                                  },
                                ),
                                Divider(
                                  color: context.onPrimaryColor.withAlpha(80),
                                  thickness: .5.w,
                                  height: .5.h,
                                ),
                              ],
                            ),
                          ),
                    ),
          ),
        ],
      ),
    );
  }
}

class TextMessageWidget extends StatelessWidget {
  const TextMessageWidget({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          140.hSpace,
          Text(
            text,
            textAlign: TextAlign.center,
            style: StyleText.medium24().copyWith(
              fontFamily: "Amiri",
              color: context.onPrimaryColor,
            ),
          ),
        ],
      ),
    ).paddingAll(20);
  }
}
