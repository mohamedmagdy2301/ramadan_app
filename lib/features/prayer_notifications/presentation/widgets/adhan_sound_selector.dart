import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_style.dart';
import '../../domain/entities/adhan_sound.dart';
import '../../services/adhan_player_service.dart';

/// Widget for selecting and previewing Adhan sounds
class AdhanSoundSelector extends StatefulWidget {
  const AdhanSoundSelector({
    super.key,
    required this.selectedAdhan,
    required this.soundEnabled,
    required this.onAdhanChanged,
    required this.onSoundEnabledChanged,
  });

  final AdhanSound? selectedAdhan;
  final bool soundEnabled;
  final ValueChanged<AdhanSound?> onAdhanChanged;
  final ValueChanged<bool> onSoundEnabledChanged;

  @override
  State<AdhanSoundSelector> createState() => _AdhanSoundSelectorState();
}

class _AdhanSoundSelectorState extends State<AdhanSoundSelector> {
  AdhanSound? _playingAdhan;
  bool _isPlaying = false;

  @override
  void dispose() {
    // Stop any playing adhan when widget is disposed
    AdhanPlayerService.instance.stop();
    super.dispose();
  }

  Future<void> _togglePreview(AdhanSound adhan) async {
    final player = AdhanPlayerService.instance;

    if (_isPlaying && _playingAdhan == adhan) {
      // Stop the current adhan
      await player.stop();
      setState(() {
        _isPlaying = false;
        _playingAdhan = null;
      });
    } else {
      // Play the selected adhan
      setState(() {
        _isPlaying = true;
        _playingAdhan = adhan;
      });

      try {
        await player.play(adhan);
        // Listen for completion
        Future.delayed(const Duration(seconds: 30), () {
          if (mounted && _playingAdhan == adhan) {
            setState(() {
              _isPlaying = false;
              _playingAdhan = null;
            });
          }
        });
      } catch (e) {
        if (mounted) {
          setState(() {
            _isPlaying = false;
            _playingAdhan = null;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: context.onPrimaryColor.withAlpha(30),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sound enabled toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.enableSound,
                style: StyleText.regular18().copyWith(
                  color: context.onPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Switch.adaptive(
                value: widget.soundEnabled,
                onChanged: widget.onSoundEnabledChanged,
                activeColor: context.primaryColor,
              ),
            ],
          ),

          if (widget.soundEnabled) ...[
            SizedBox(height: 16.h),

            // Title
            Text(
              AppStrings.selectAdhan,
              style: StyleText.regular16().copyWith(
                color: context.onPrimaryColor.withAlpha(180),
              ),
            ),

            SizedBox(height: 12.h),

            // Adhan options
            ...AdhanSound.values.map((adhan) => _AdhanSoundTile(
                  adhan: adhan,
                  isSelected: widget.selectedAdhan == adhan,
                  isPlaying: _isPlaying && _playingAdhan == adhan,
                  onSelect: () => widget.onAdhanChanged(adhan),
                  onPreview: () => _togglePreview(adhan),
                )),
          ],
        ],
      ),
    );
  }
}

class _AdhanSoundTile extends StatelessWidget {
  const _AdhanSoundTile({
    required this.adhan,
    required this.isSelected,
    required this.isPlaying,
    required this.onSelect,
    required this.onPreview,
  });

  final AdhanSound adhan;
  final bool isSelected;
  final bool isPlaying;
  final VoidCallback onSelect;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: isSelected
            ? context.primaryColor.withAlpha(20)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected
              ? context.primaryColor
              : context.onPrimaryColor.withAlpha(30),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSelect,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                // Radio indicator
                Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? context.primaryColor
                          : context.onPrimaryColor.withAlpha(100),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.primaryColor,
                            ),
                          ),
                        )
                      : null,
                ),

                SizedBox(width: 14.w),

                // Adhan name
                Expanded(
                  child: Text(
                    adhan.arabicName,
                    style: StyleText.regular16().copyWith(
                      color: isSelected
                          ? context.primaryColor
                          : context.onPrimaryColor,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),

                // Preview button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onPreview,
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: isPlaying
                            ? Colors.red.withAlpha(20)
                            : context.primaryColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                            size: 18.sp,
                            color: isPlaying ? Colors.red : context.primaryColor,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            isPlaying ? AppStrings.stop : AppStrings.preview,
                            style: StyleText.regular12().copyWith(
                              color: isPlaying ? Colors.red : context.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
