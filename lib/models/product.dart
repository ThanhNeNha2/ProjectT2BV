import 'package:flutter/foundation.dart';

class Product {
  final String? id;
  final String title;
  final String category;
  final String author;
  final String language;
  final String coutry;
  final String description;
  final double price;
  final String imageUrl;
  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.author,
    required this.language,
    required this.coutry,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  Product copyWith({
    String? id,
    String? title,
    String? category,
    String? author,
    String? language,
    String? coutry,
    String? description,
    double? price,
    String? imageUrl,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      author: author ?? this.author,
      language: language ?? this.language,
      coutry: coutry ?? this.coutry,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'author': author,
      'language': language,
      'coutry': coutry,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  static Product fromJson(Map<String, dynamic> json) {
    return Product(
id: json['id'],
title: json['title'],
category: json['category'],
author: json['author'],
language: json['language'],
coutry: json['coutry'],
description: json['description'],
price: json['price'],
imageUrl: json['imageUrl'],
    );
  }
}
