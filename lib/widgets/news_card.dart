import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String title;
  final String content;
  final String category;
  final String? thumbnail;
  final bool isFeatured;

  const NewsCard({
    super.key,
    required this.title,
    required this.content,
    required this.category,
    this.thumbnail,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: thumbnail != null && thumbnail!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  thumbnail!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(Icons.article, size: 40, color: Colors.grey),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isFeatured ? Colors.blueAccent : Colors.black87,
          ),
        ),
        subtitle: Text(
          content.length > 60 ? '${content.substring(0, 60)}...' : content,
          style: const TextStyle(fontSize: 13),
        ),
        trailing: Text(
          category.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }
}