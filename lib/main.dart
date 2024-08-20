import 'package:flutter/material.dart';
import 'package:fullme/theme/app_color.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'fullme_card.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  ThemeData _buildLightTheme() {
    return ThemeData.light().copyWith(
      cardTheme: const CardTheme(color: AppColors.white),
      appBarTheme: const AppBarTheme(
        color: AppColors.white,
        titleTextStyle: TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.w400,
          fontSize: 24,
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData.dark().copyWith(
      cardTheme: CardTheme(
        color: AppColors.purpleAccentColor.withOpacity(0.2),
      ),
      appBarTheme: AppBarTheme(
        color: AppColors.purpleAccentColor.withOpacity(0.6),
        titleTextStyle: const TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w400,
          fontSize: 24,
        ),
      ),
    );
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.light, // Change theme mode as needed

      home: const fullme(),
    );
  }
}

class fullme extends StatefulWidget {
  const fullme({super.key});

  @override
  State<fullme> createState() => _fullmeState();
}

class _fullmeState extends State<fullme> {
  late List<fullme_card> items;
  late ScrollController _scrollController;

  late int testId = 1;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void initState() {

      super.initState();
      _scrollController = ScrollController();

      items = [
        fullme_card(id: "pixy$testId",name: "寒冰",taskName: "Fullme",imageUrl: "123",),


      ];

      testId ++;


  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _addNewItem() {
    setState(() {
      items.add(
        fullme_card(
          id: "pixy$testId",
          name: "寒冰",
          taskName: "破阵2",
          imageUrl: "123",
        ),
      );
      testId ++;
      if (items.length > 5) {
        items.removeAt(0);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: [
              Expanded(child: Image.asset(
                'assets/images/logo.jpg', // Replace with your image asset path
              //  height: 50,
              ),
            ),

            IconButton(
              icon: const Icon(Icons.settings,color: Colors.black45,),
              onPressed: () {
                // Handle settings button press
                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return SettingsDialog();
                //   },
                // );

                _addNewItem();


              },
            ),

          ],
        ),

      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child:ListView.builder(
          controller: _scrollController,
          itemCount: items.length > 5 ? 5 : items.length, // Show up to 10 items
          itemBuilder: (context, index) {
          // Calculate the index in the original list to get the latest items


          print(items[index].id);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: fullme_card(id: items[index].id,name:items[index].name,taskName: items[index].taskName,imageUrl: items[index].imageUrl), // Replace this with your fullme_card widget
          );
        },
      ),
      )

    );
  }
}


class SettingsDialog extends StatefulWidget {
  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  final _urlController = TextEditingController();
  final _portController = TextEditingController();
  final _topicController = TextEditingController();
  final _idController = TextEditingController();
  final _imageNumberController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load saved settings
  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _urlController.text = prefs.getString('url') ?? '';
      _portController.text = prefs.getString('port') ?? '';
      _topicController.text = prefs.getString('topic') ?? '';
      _idController.text = prefs.getString('id') ?? '';
      _imageNumberController.text = prefs.getString('imageNumber') ?? '';
      _usernameController.text = prefs.getString('username') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
    });
  }

  // Save settings to local storage
  void _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('url', _urlController.text);
    await prefs.setString('port', _portController.text);
    await prefs.setString('topic', _topicController.text);
    await prefs.setString('id', _idController.text);
    await prefs.setString('imageNumber', _imageNumberController.text);
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('password', _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL',
              ),
            ),
            TextField(
              controller: _portController,
              decoration: const InputDecoration(
                labelText: 'Port',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'User Name',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            TextField(
              controller: _topicController,
              decoration: const InputDecoration(
                labelText: 'Topic/Fullme ID',
              ),
            ),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'ID',
              ),
            ),
            TextField(
              controller: _imageNumberController,
              decoration: const InputDecoration(
                labelText: 'Image Number',
              ),
              keyboardType: TextInputType.number,
            ),

          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Save'),
          onPressed: () {
            _saveSettings();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
