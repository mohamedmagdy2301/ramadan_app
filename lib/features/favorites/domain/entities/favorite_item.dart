import 'package:equatable/equatable.dart';
import 'package:ramadan_app/features/favorites/domain/entities/favorite_type.dart';

/// Represents a favorited item
class FavoriteItem extends Equatable {
  final String id;
  final FavoriteType type;
  final String title;
  final String? subtitle;
  final DateTime addedAt;

  const FavoriteItem({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [id, type, title, subtitle, addedAt];

  FavoriteItem copyWith({
    String? id,
    FavoriteType? type,
    String? title,
    String? subtitle,
    DateTime? addedAt,
  }) {
    return FavoriteItem(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.value,
      'title': title,
      'subtitle': subtitle,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'] as String,
      type: FavoriteType.fromString(json['type'] as String?) ?? FavoriteType.azkar,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }
}
