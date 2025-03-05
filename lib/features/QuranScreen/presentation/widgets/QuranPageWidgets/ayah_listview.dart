// ignore_for_file: must_be_immutable

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/extensions/int_extensions.dart' as ext;
import 'package:ramadan_app/core/extensions/widget_extensions.dart';
import 'package:ramadan_app/features/QuranScreen/data/models/ayah_model.dart';
import 'package:ramadan_app/features/QuranScreen/data/models/quran_chapter_model.dart';
import 'package:ramadan_app/features/QuranScreen/presentation/widgets/QuranPageWidgets/number_widget.dart';

class AyahListViewWidget extends StatefulWidget {
  final int suraNumber;

  final List<AyahModel> ayahAudioData;
  // final List<QuranChapter> chapters;
  final List<QuranVerse> verses;
  bool isPlaying;
  AyahListViewWidget({
    super.key,
    required this.suraNumber,
    required this.ayahAudioData,
    required this.verses,
    required this.isPlaying,
  });

  @override
  State<AyahListViewWidget> createState() => _AyahListViewWidgetState();
}

class _AyahListViewWidgetState extends State<AyahListViewWidget> {
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        widget.isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.verses.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              color:
                  widget.verses[index].text.contains("۞")
                      ? context.backgroundColor.withAlpha(120)
                      : context.backgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NumberWidget(num: widget.verses[index].id),
                  10.wSpace,
                  Text(
                    widget.verses[index].text,
                    style: StyleText.regular22().copyWith(
                      color: context.onPrimaryColor,
                      fontFamily: 'Amiri',
                      height: 2.2.h,
                    ),
                    textAlign: TextAlign.start,
                  ).withWidth(context.W * 0.7),

                  Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed:
                        !widget.isPlaying
                            ? () {
                              if (widget.isPlaying) {
                                audioPlayer.pause();
                              } else {
                                audioPlayer.play(
                                  UrlSource(widget.ayahAudioData[index].audio),
                                );
                                print('========playing AudioAyah==========!');
                              }

                              setState(() {
                                widget.isPlaying = !widget.isPlaying;
                              });
                            }
                            : () {
                              print(
                                '========No Ui playing AudioAyah==========!',
                              );
                            },
                    icon: Icon(
                      CupertinoIcons.play_circle,
                      size: 25.sp,
                      color: context.primaryColor.withAlpha(160),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 4.h,
              thickness: .5.h,
              color: context.onPrimaryColor.withAlpha(100),
            ),
          ],
        );
      },
    );
  }
}
