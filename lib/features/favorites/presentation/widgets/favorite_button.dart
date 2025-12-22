import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_strings.dart';
import 'package:ramadan_app/core/di/injection_container.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/features/favorites/data/favorites_local_datasource.dart';
import 'package:ramadan_app/features/favorites/domain/entities/favorite_item.dart';

/// A heart-shaped button for toggling favorite status
class FavoriteButton extends StatefulWidget {
  final FavoriteItem item;
  final VoidCallback? onToggle;
  final double size;

  const FavoriteButton({
    super.key,
    required this.item,
    this.onToggle,
    this.size = 24,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isFavorite = false;
  final IFavoritesLocalDatasource _datasource = sl<IFavoritesLocalDatasource>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _checkFavoriteStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkFavoriteStatus() async {
    final isFav = await _datasource.isFavorite(widget.item.id);
    if (mounted) {
      setState(() => _isFavorite = isFav);
    }
  }

  Future<void> _toggleFavorite() async {
    // Play animation
    await _controller.forward();
    await _controller.reverse();

    // Toggle favorite
    if (_isFavorite) {
      await _datasource.removeFavorite(widget.item.id);
    } else {
      await _datasource.addFavorite(widget.item);
    }

    if (mounted) {
      setState(() => _isFavorite = !_isFavorite);
    }

    widget.onToggle?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _isFavorite
          ? AppStrings.removeFromFavorites
          : AppStrings.addToFavorites,
      button: true,
      child: GestureDetector(
        onTap: _toggleFavorite,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : context.onPrimaryColor.withAlpha(150),
            size: widget.size.sp,
          ),
        ),
      ),
    );
  }
}
