import 'package:flutter/material.dart';
import 'package:football_news/screens/menu.dart';
import 'package:football_news/screens/newslist_form.dart';
import 'package:football_news/screens/news_entry_list.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[100],
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Center(
              child: Text(
                "Football News App",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text("Add News"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NewsFormPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_reaction_rounded),
            title: const Text('News List'),
            onTap: () {
              // Route to news list page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewsEntryListPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}