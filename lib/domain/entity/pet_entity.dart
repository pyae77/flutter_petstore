
import 'package:my_test_app/domain/entity/category_entity.dart';
import 'package:my_test_app/domain/entity/tag_entity.dart';

class PetEntity {
  final int id;
  final CategoryEntity? category;
  final String name;
  final List<String> photoUrls;
  final List<TagEntity> tags;
  final String status;

  const PetEntity({
    required this.id,
    this.category,
    required this.name,
    required this.photoUrls,
    required this.tags,
    required this.status,
  });
}