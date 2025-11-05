import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:football_news/widgets/left_drawer.dart';
import 'package:football_news/widgets/news_card.dart';

List<Map<String, dynamic>> newsList = [];

class NewsFormPage extends StatefulWidget {
  const NewsFormPage({super.key});

  @override
  State<NewsFormPage> createState() => _NewsFormPageState();
}

class _NewsFormPageState extends State<NewsFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _content = "";
  String _category = "update";
  String _thumbnail = "";
  bool _isFeatured = false;

  final List<String> _categories = [
    'transfer',
    'update',
    'exclusive',
    'match',
    'rumor',
    'analysis',
  ];

  @override
  void initState() {
    super.initState();
    _loadNewsFromStorage();
  }

  Future<void> _loadNewsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNews = prefs.getString('newsList');

    if (savedNews != null) {
      final decoded = jsonDecode(savedNews) as List<dynamic>;
      setState(() {
        newsList = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
      });
    }
  }

  Future<void> _saveNewsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('newsList', jsonEncode(newsList));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Form Tambah Berita')),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Judul Berita",
                    labelText: "Judul Berita",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => setState(() => _title = value),
                  validator: (value) => value == null || value.isEmpty
                      ? "Judul tidak boleh kosong!"
                      : null,
                ),
              ),

              // Isi berita
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Isi Berita",
                    labelText: "Isi Berita",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => setState(() => _content = value),
                  validator: (value) => value == null || value.isEmpty
                      ? "Isi berita tidak boleh kosong!"
                      : null,
                ),
              ),

              // Dropdown kategori
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Kategori",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  value: _category,
                  items: _categories
                      .map(
                        (cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat[0].toUpperCase() + cat.substring(1)),
                        ),
                      )
                      .toList(),
                  onChanged: (newValue) =>
                      setState(() => _category = newValue!),
                ),
              ),

              // URL thumbnail
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "URL Thumbnail (opsional)",
                    labelText: "URL Thumbnail",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => setState(() => _thumbnail = value),
                ),
              ),

              // Switch featured
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SwitchListTile(
                  title: const Text("Tandai sebagai Berita Unggulan"),
                  value: _isFeatured,
                  onChanged: (value) => setState(() => _isFeatured = value),
                ),
              ),

              // Tombol Simpan
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.blueAccent,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        newsList.add({
                          "title": _title,
                          "content": _content,
                          "category": _category,
                          "thumbnail": _thumbnail,
                          "isFeatured": _isFeatured,
                        });

                        await _saveNewsToStorage();

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Berita berhasil disimpan!'),
                            content: Text('Judul: $_title'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );

                        _formKey.currentState!.reset();
                      }
                    },
                    child: const Text(
                      "Simpan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),

              // Daftar berita
              if (newsList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text(
                        "Daftar Berita Tersimpan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (final news in newsList)
                        NewsCard(
                          title: news['title'],
                          content: news['content'],
                          category: news['category'],
                          thumbnail: news['thumbnail'],
                          isFeatured: news['isFeatured'],
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}