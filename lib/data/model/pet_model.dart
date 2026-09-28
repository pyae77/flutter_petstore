import 'package:my_test_app/domain/entity/pet_entity.dart';

import 'category_model.dart';
import 'tag_model.dart';

class PetModel extends PetEntity {
  const PetModel({
    required super.id,
    super.category,
    required super.name,
    required super.photoUrls,
    required super.tags,
    required super.status,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      category: json['category'] != null && json['category'] is Map<String, dynamic>
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      name: json['name']?.toString() ?? '',
     
      photoUrls: json['photoUrls'] != null && json['photoUrls'] is List
          ? (json['photoUrls'] as List)
              .map((e) => e?.toString() ?? '')
              .where((e) => e.isNotEmpty)
              .toList()
          : [],
      tags: json['tags'] != null && json['tags'] is List
          ? (json['tags'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => TagModel.fromJson(e))
              .toList()
          : [],
      status: json['status']?.toString() ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category != null
          ? CategoryModel(id: category!.id, name: category!.name).toJson()
          : null,
      'name': name,
      'photoUrls': photoUrls,
      'tags': tags
          .map((e) => TagModel(id: e.id, name: e.name).toJson())
          .toList(),
      'status': status,
    };
  }
}