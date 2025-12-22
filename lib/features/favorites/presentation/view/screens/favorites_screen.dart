import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_strings.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/features/favorites/domain/entities/favorite_type.dart';
import 'package:ramadan_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:ramadan_app/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:ramadan_app/features/favorites/presentation/widgets/empty_favorites_widget.dart';
import 'package:ramadan_app/features/favorites/presentation/widgets/favorite_list_tile.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  static const routeName = '/favorites';

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.favorites,
          style: StyleText.regular20().copyWith(
            color: context.onPrimaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: context.onPrimaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: context.primaryColor,
              ),
            );
          }

          if (state is FavoritesError) {
            return Center(
              child: Text(
                state.message,
                style: StyleText.regular16().copyWith(
                  color: context.onPrimaryColor,
                ),
              ),
            );
          }

          if (state is FavoritesLoaded) {
            return Column(
              children: [
                // Filter chips
                _buildFilterChips(context, state),
                // Favorites list
                Expanded(
                  child: state.filteredFavorites.isEmpty
                      ? const EmptyFavoritesWidget()
                      : ListView.builder(
                          padding: EdgeInsets.all(16.w),
                          itemCount: state.filteredFavorites.length,
                          itemBuilder: (context, index) {
                            final item = state.filteredFavorites[index];
                            return FavoriteListTile(
                              item: item,
                              onRemove: () {
                                context
                                    .read<FavoritesCubit>()
                                    .removeFromFavorites(item.id);
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const EmptyFavoritesWidget();
        },
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, FavoritesLoaded state) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            _buildFilterChip(
              context,
              label: AppStrings.all,
              isSelected: state.filterType == null,
              onTap: () => context.read<FavoritesCubit>().setFilter(null),
            ),
            SizedBox(width: 8.w),
            ...FavoriteType.values.map((type) => Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: _buildFilterChip(
                    context,
                    label: type.arabicName,
                    isSelected: state.filterType == type,
                    onTap: () => context.read<FavoritesCubit>().setFilter(type),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color:
              isSelected ? context.primaryColor : context.primaryColor.withAlpha(20),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: context.primaryColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: StyleText.regular14().copyWith(
            color: isSelected ? Colors.white : context.onPrimaryColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
