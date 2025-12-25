import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_strings.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/features/favorites/domain/entities/favorite_item.dart';
import 'package:ramadan_app/features/favorites/domain/entities/favorite_type.dart';

class FavoriteListTile extends StatelessWidget {
  final FavoriteItem item;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const FavoriteListTile({
    super.key,
    required this.item,
    this.onTap,
    this.onRemove,
  });

  IconData _getIconForType(FavoriteType type) {
    switch (type) {
      case FavoriteType.azkar:
        return Icons.auto_awesome;
      case FavoriteType.dua:
        return Icons.volunteer_activism;
      case FavoriteType.surah:
        return Icons.menu_book;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${item.title} - ${item.type.arabicName}',
      child: Dismissible(
        key: Key(item.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20.w),
          decoration: BoxDecoration(
            color: Colors.red.withAlpha(30),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.delete,
            color: Colors.red,
            size: 24.sp,
          ),
        ),
        confirmDismiss: (direction) async {
          onRemove?.call();
          return false; // Don't dismiss, let the cubit handle it
        },
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: context.primaryColor.withAlpha(15),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: context.primaryColor.withAlpha(30),
              ),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    _getIconForType(item.type),
                    color: context.primaryColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: StyleText.bold16().copyWith(
                          color: context.onPrimaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        item.type.arabicName,
                        style: StyleText.regular12().copyWith(
                          color: context.onPrimaryColor.withAlpha(150),
                        ),
                      ),
                    ],
                  ),
                ),
                // Remove button
                IconButton(
                  onPressed: onRemove,
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 24.sp,
                  ),
                  tooltip: AppStrings.removeFromFavorites,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
