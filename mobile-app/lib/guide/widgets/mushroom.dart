import 'package:equatable/equatable.dart';

class Mushroom extends Equatable {
  final String id;
  final String name;
  final String? edibility;
  final String imageUrl;
  final String description;
  final String? mushroomClass;
  final String? phylum;
  final String? order;
  final String? family;
  final String? genus;
  final double? confidence;

  const Mushroom({
    required this.id,
    required this.name,
    this.edibility,
    required this.imageUrl,
    required this.description,
    this.mushroomClass,
    this.phylum,
    this.order,
    this.family,
    this.genus,
    this.confidence,
  });

  factory Mushroom.fromMap(Map<String, dynamic> map) {
    return Mushroom(
      id: map['id']?.toString() ?? '',
      name: map['label'] as String? ?? '',
      description: (map['description'] ?? '') as String,
      imageUrl: (map['image'] ?? '') as String,
      edibility: map['edibility'] as String?,
      mushroomClass: map['class'] as String?,
      phylum: map['phylum'] as String?,
      order: map['order'] as String?,
      family: map['family'] as String?,
      genus: map['genus'] as String?,
      confidence: map['confidence'] as double?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'edibility': edibility,
      'imageUrl': imageUrl,
      'description': description,
      'mushroomClass': mushroomClass,
      'phylum': phylum,
      'order': order,
      'family': family,
      'genus': genus,
      'confidence': confidence,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    edibility,
    imageUrl,
    description,
    mushroomClass,
    phylum,
    order,
    family,
    genus,
    confidence,
  ];
}