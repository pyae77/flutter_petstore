class CategoryModel{
  final int id;
  final String  name;

  CategoryModel({required this.id, required this.name});
  factory CategoryModel.fromJson(Map<String,dynamic>json)=>CategoryModel(id: json['id'], name: json['name']);
  Map<String,dynamic> toJson()=>{
    'id':id,
    'name':name,
  };
}
class  TagModel{
  final int id;
  final String name;

  TagModel({required this.id, required this.name});
  factory TagModel.fromJson(Map<String,dynamic>json)=>TagModel(id: json['id'], name: json['name']);
  Map<String,dynamic> toJson()=>{
    'id':id,
    'name':name
  };
}
class PetModel{
  final int id;
  final CategoryModel category;
  final String name;
  final List<String> photoUrls;
  final List<TagModel> tags;
  final String status;

  PetModel({required this.id, required this.category, required this.name, required this.photoUrls, required this.tags, required this.status});
  factory PetModel.fromJson(Map<String,dynamic>json)
  {
    return PetModel(
      id: json['id'], 
      category: CategoryModel.fromJson(json['category']),
      name: json['name'], 
      photoUrls: List<String>.from(json['photoUrls']), 
      tags: (json['tags'] as List).map((e)=>TagModel.fromJson(e)).toList(), 
      status: json['status']);
  }

  Map<String,dynamic> toJson(){
    return {
    'id':id,
    'category':category.toJson(),
    'name':name,
    'photoUrls':photoUrls,
    'tags':tags.map((e)=>e.toJson()).toList(),
    'status':status
    };
  }
}

class InventoryResponseModel{
  final Map<String,int> values;
  factory InventoryResponseModel.fromJson(Map<String, dynamic> json){
    return InventoryResponseModel(values: json.map((key, value) => MapEntry(key, value as int),));
  }
  InventoryResponseModel({required this.values});
  Map<String,int> toJson()=>values;
}