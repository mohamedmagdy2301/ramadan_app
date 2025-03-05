// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:quran_library/quran.dart';
// import 'package:ramadan_app/core/extensions/context_extensions.dart';
// import 'package:ramadan_app/core/utils/widgets/custom_loading_widget.dart';
// import 'package:ramadan_app/features/QuranScreen/Service/AyahService.dart';

// class AyahScreens extends StatefulWidget {
//   final int suraNumber;

//   const AyahScreens({super.key, required this.suraNumber});

//   @override
//   State<AyahScreens> createState() => _AyahScreensState();
// }

// class _AyahScreensState extends State<AyahScreens> {
//   final AyahService _ayahService = AyahService();
//   bool isPlaying = false;
//   AudioPlayer audioPlayerSurah = AudioPlayer();

//   @override
//   void initState() {
//     super.initState();
//     audioPlayerSurah.onPlayerComplete.listen((event) {
//       setState(() {
//         isPlaying = false;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     audioPlayerSurah.dispose();
//     super.dispose();
//   }

//   String selectedValue = 'mahermuaiqly';

//   final List<Map> _dropdownItems = [
//     {"value": 'mahermuaiqly', "name": "ماهر المعيقلي"},
//     {"value": 'abdulsamad', "name": "عبدالباسط عبدالصمد"},
//     {"value": 'abdurrahmaansudais', "name": "عبدالرحمن السديس"},
//     {"value": 'alafasy', "name": "مشاري العفاسي"},
//     {"value": 'ahmedajamy', "name": "أحمد بن علي العجمي"},
//     {"value": 'husary', "name": "محمود خليل الحصري"},
//     {"value": 'minshawi', "name": "محمد صديق المنشاوي"},
//     {"value": 'muhammadjibreel', "name": "محمد جبريل"},
//     {"value": 'mahermuaiqly', "name": "ماهر المعيقلي"},
//     {"value": 'abdulsamad', "name": "عبد الباسط عبدالصمد"},
//     {"value": 'abdurrahmaansudais', "name": "عبدالرحمن السديس"},
//     {"value": 'alafasy', "name": "مشاري العفاسي"},
//     {"value": 'ahmedajamy', "name": "أحمد بن علي العجمي"},
//     {"value": 'husary', "name": "محمود خليل الحصري"},
//     {"value": 'minshawi', "name": "محمد صديق المنشاوي"},
//     {"value": 'muhammadjibreel', "name": "محمد جبريل"},
//     {"value": 'mahermuaiqly', "name": "ماهر المعيقلي"},
//     {"value": 'abdulsamad', "name": "عبدالباسط عبدالصمد"},
//     {"value": 'abdurrahmaansudais', "name": "عبدالرحمن السديس"},
//     {"value": 'alafasy', "name": "مشاري العفاسي"},
//     {"value": 'ahmedajamy', "name": "أحمد بن علي العجمي"},
//     {"value": 'husary', "name": "محمود خليل الحصري"},
//     {"value": 'minshawi', "name": "محمد صديق المنشاوي"},
//     {"value": 'muhammadjibreel', "name": "محمد جبريل"},
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: QuranLibraryScreen(
//         ayahIconColor: context.primaryColor,
//         ayahSelectedBackgroundColor: context.primaryColor,
//         backgroundColor: context.backgroundColor,
//         basmalaStyle: BasmalaStyle(basmalaColor: context.primaryColor),
//         isDark: context.isDark,
//         circularProgressWidget: const Center(child: CustomLoadingWidget()),
//         textColor: context.onPrimaryColor,
//       ),
//     );

//     // return Scaffold(
//     //   floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
//     //   floatingActionButton: FutureBuilder<List>(
//     //     future: SuraAudioService().getSuraAudio(editor: "728787"),
//     //     builder: (context, snapshot) {
//     //       // if (snapshot.connectionState == ConnectionState.waiting) {
//     //       //   return const Padding(
//     //       //     padding: EdgeInsets.only(top: 300),
//     //       //     child: Center(child: CircularProgressIndicator()),
//     //       //   );
//     //       // } else if (snapshot.hasError) {
//     //       //   return Center(
//     //       //       child: Padding(
//     //       //     padding: const EdgeInsets.all(8.0),
//     //       //     child: Text('Error: ${snapshot.error}'),
//     //       //   ));
//     //       // } else if (!snapshot.hasData) {
//     //       //   return const Center(child: Text('No data available'));
//     //       // } else {
//     //       return FloatingActionButton(
//     //         onPressed:
//     //             !isPlaying
//     //                 ? () {
//     //                   if (isPlaying) {
//     //                     audioPlayerSurah.pause();
//     //                   } else {
//     //                     audioPlayerSurah.play(UrlSource(snapshot.data![0]));
//     //                     print('========Ui playing AudioSura==========!');
//     //                   }
//     //                   setState(() {
//     //                     isPlaying = !isPlaying;
//     //                   });
//     //                 }
//     //                 : () {
//     //                   print('========No Ui playing AudioSura==========!');
//     //                 },
//     //         backgroundColor: const Color.fromARGB(255, 180, 100, 14),
//     //         foregroundColor: Colors.white,
//     //         child:
//     //             isPlaying == false
//     //                 ? const Icon(Icons.play_arrow)
//     //                 : const Icon(Icons.pause),
//     //       );
//     //       // }
//     //     },
//     //   ),
//     //   body: CustomScrollView(
//     //     slivers: [
//     //       SliverAppBar(
//     //         floating: true,
//     //         pinned: true,
//     //         foregroundColor: context.onPrimaryColor,
//     //         backgroundColor: context.primaryColor,
//     //         centerTitle: true,
//     //         expandedHeight: 120.h,
//     //         title: Text(
//     //           quranData[widget.suraNumber - 1].name,
//     //           style: StyleText.bold26().copyWith(
//     //             color: context.onPrimaryColor,
//     //             fontFamily: 'Noto_Nastaliq_Urdu',
//     //           ),
//     //           textAlign: TextAlign.center,
//     //         ),
//     //         bottom: AppBar(
//     //           backgroundColor: context.backgroundColor,
//     //           centerTitle: true,
//     //           elevation: 0,
//     //           automaticallyImplyLeading: false,
//     //           flexibleSpace: Container(color: context.primaryColor),
//     //           title: Text(
//     //             "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
//     //             style: StyleText.bold22().copyWith(
//     //               color: context.onPrimaryColor,
//     //               fontFamily: 'Noto_Nastaliq_Urdu',
//     //             ),
//     //           ),
//     //         ),
//     //         actions: [
//     //           IconButton(
//     //             onPressed: () {
//     //               showDialog(
//     //                 context: context,
//     //                 builder: (BuildContext context) {
//     //                   return AlertDialog(
//     //                     titlePadding: EdgeInsets.symmetric(
//     //                       horizontal: MediaQuery.of(context).size.width * 0.1,
//     //                       vertical: 15,
//     //                     ),
//     //                     title: const Text(
//     //                       'تغير القارء',
//     //                       locale: Locale("ar"),
//     //                       textAlign: TextAlign.right,
//     //                       style: TextStyle(fontWeight: FontWeight.bold),
//     //                     ),
//     //                     content: SizedBox(
//     //                       height: 300,
//     //                       child: ListView.builder(
//     //                         itemCount: _dropdownItems.length,
//     //                         itemBuilder:
//     //                             (context, index) => TextButton(
//     //                               onPressed: () {
//     //                                 setState(() {
//     //                                   selectedValue =
//     //                                       _dropdownItems[index]["value"];
//     //                                 });
//     //                                 Navigator.of(context).pop();
//     //                               },
//     //                               child: Text(
//     //                                 _dropdownItems[index]["name"],
//     //                                 style: TextStyle(
//     //                                   color:
//     //                                       selectedValue ==
//     //                                               _dropdownItems[index]["value"]
//     //                                           ? const Color.fromARGB(
//     //                                             255,
//     //                                             180,
//     //                                             96,
//     //                                             1,
//     //                                           )
//     //                                           : const Color.fromARGB(
//     //                                             255,
//     //                                             0,
//     //                                             0,
//     //                                             0,
//     //                                           ),
//     //                                 ),
//     //                               ),
//     //                             ),
//     //                       ),
//     //                     ),
//     //                   );
//     //                 },
//     //               );
//     //             },
//     //             icon: const Icon(Icons.person, color: Colors.white),
//     //           ),
//     //         ],
//     //       ),
//     //       // SliverToBoxAdapter(
//     //       //   child:
//     //       // ),
//     //       SliverList(
//     //         delegate: SliverChildBuilderDelegate(childCount: 1, (
//     //           context,
//     //           index,
//     //         ) {
//     //           return FutureBuilder(
//     //             future: _ayahService.getAyahData(
//     //               widget.suraNumber,
//     //               selectedValue,
//     //             ),
//     //             builder: (context, snapshot) {
//     //               if (snapshot.connectionState == ConnectionState.waiting) {
//     //                 return const Padding(
//     //                   padding: EdgeInsets.only(top: 300),
//     //                   child: Center(child: CircularProgressIndicator()),
//     //                 );
//     //               } else if (snapshot.hasError) {
//     //                 return Center(
//     //                   child: Padding(
//     //                     padding: const EdgeInsets.all(8.0),
//     //                     child: Text('Error: ${snapshot.error}'),
//     //                   ),
//     //                 );
//     //               } else if (!snapshot.hasData) {
//     //                 return const Center(child: Text('No data available'));
//     //               } else {
//     //                 return AyahListViewWidget(
//     //                   ayahAudioData: snapshot.data ?? [],
//     //                   suraNumber: widget.suraNumber,
//     //                   verses: quranData[widget.suraNumber - 1].verses,
//     //                   isPlaying: isPlaying,
//     //                 );
//     //               }
//     //             },
//     //           );
//     //         }),
//     //       ),
//     //     ],
//     //   ),
//     // )
//   }
// }
