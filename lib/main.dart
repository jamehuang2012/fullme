import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fullme/network/api_service.dart';
import 'package:fullme/theme/app_color.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';
import 'data/fullme_data.dart';
import 'fullme_card.dart';

import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ConfigManager().init();
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
  late List<FullmeData> items;
  late ScrollController _scrollController;

  late MqttServerClient client;
  final String clientIdentifier = 'flutter_client';
  Map<String, dynamic>? imageInfo;
  late Timer _timer;

  @override
  void dispose() {
    _scrollController.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  void initState() {

      super.initState();
      _scrollController = ScrollController();

      var url = ConfigManager().getUrl();
      print("url-->$url");

      client = MqttServerClient(url, clientIdentifier);
      client.logging(on: true);
      client.onConnected = onConnected;
      client.onSubscribed = onSubscribed;

      client.keepAlivePeriod = 60;

      final connMessage = MqttConnectMessage()
          .withClientIdentifier('mqtt_123')
          .withWillTopic('willtopic')
          .withWillMessage('Will message')
          .startClean()
          .withWillQos(MqttQos.atLeastOnce);

      client.connectionMessage = connMessage;
      client.connect();


      _timer = Timer.periodic(Duration(seconds: 15), (Timer timer) {
        if (client.connectionStatus!.state == MqttConnectionState.disconnected) {
          client.connect();
        }
      });

      items = [];

      WakelockPlus.enable();
  }


  void onConnected() {
    print('Connected to the broker');

    var topic = ConfigManager().getTopic();
    print(topic);
    client.subscribe(topic, MqttQos.atMostOnce);
    //publishMessage('Hello from Flutter');

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String? pt =
      MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);
      print(
          'fullme::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');

      try {
        Map<String, dynamic> parsedJson = json.decode(pt!);


        // Get the UTF-8 encoded name
        String encodedName = parsedJson['name'];

        // Decode the UTF-8 encoded name
        String decodedName = utf8.decode(encodedName.runes.toList());

        // Replace the encoded name with the decoded name in the parsed JSON
        parsedJson['name'] = decodedName;

        print(decodedName);

        // Convert the parsed JSON back to a JSON string
        String modifiedJsonString = json.encode(parsedJson);


        imageInfo = parsedJson;

        if (kDebugMode) {
          print(modifiedJsonString);
        } // Output: {"text":"tinttin { }"}

        setState(() {
          // Update and download image
          print("uploade");



          ApiService apiService = new ApiService();
          apiService.fetchImageUrls(parsedJson['url'],parsedJson['image_no'],count: 2).then ((value) {
            print(value);

            _addNewItem(FullmeData(id: parsedJson['id'], name: parsedJson['name'], task: parsedJson['task'], filePaths: value, imageNo: parsedJson['image_no']));

          });

        });
      } catch (e) {
        print('Error: $e');
      }
    });

  }

  void onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }

  void publishMessage(String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage('topic/fullme', MqttQos.exactlyOnce, builder.payload!);
  }

  void onMessage(String topic, MqttReceivedMessage message) {
    final String payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
    print('Message received: topic=$topic, payload=$payload');

    String jsonString = json.encode(payload);

    print(jsonString); // Output: {"text":"tinttin { }"}

    setState(() {

    });
  }
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _addNewItem(FullmeData fullme) {
    setState(() {
      items.add(
          fullme
      );

      print(fullme.filePaths);
      print(items[0].filePaths);
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
              icon: const Icon(Icons.settings,color: Colors.black87,size: 25,),
              onPressed: () {
                // Handle settings button press
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SettingsDialog();
                  },
                );

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
            child: fullme_card(id: items[index].id,name:items[index].name,taskName: items[index].task,imageUrls: items[index].filePaths,), // Replace this with your fullme_card widget
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
