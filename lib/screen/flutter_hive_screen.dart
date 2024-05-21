import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('MyBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FlutterHiveScreen(),
    );
  }
}

class FlutterHiveScreen extends StatefulWidget {
  const FlutterHiveScreen({super.key});

  @override
  State<FlutterHiveScreen> createState() => _FlutterHiveScreenState();
}

class _FlutterHiveScreenState extends State<FlutterHiveScreen> {
  TextEditingController myText = TextEditingController();
  TextEditingController myValue = TextEditingController();
  late Box mybox;

  List<Map<String, dynamic>> mydata = [];

  @override
  void initState() {
    super.initState();
    openBox();
  }

  Future<void> openBox() async {
    mybox = Hive.box('MyBox');
    getItem();
  }

  Future<void> addItem(Map<String, String> data) async {
    await mybox.add(data);
    print(mybox.values);
    getItem();
  }

  Future<void> deleteItem(int key) async {
    await mybox.delete(key);
    getItem();
  }

  Future<void> updateItem(int key, Map<String, String> updatedData) async {
    await mybox.put(key, updatedData);
    getItem();
  }

  void getItem() {
    mydata = mybox.keys.map((e) {
      var res = mybox.get(e);
      return {
        'Key': e,
        'title': res['title'],
        'value': res['value'],
      };
    }).toList();
    setState(() {});
  }

  void showBottomSheet(Map<String, dynamic> item) {
    myText.text = item['title'];
    myValue.text = item['value'];
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(100),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: myText,
                decoration: const InputDecoration(
                  labelText: 'Enter your name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: myValue,
                decoration: const InputDecoration(
                  labelText: 'Enter your age',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Map<String, String> m1 = {
                    'title': myText.text,
                    'value': myValue.text,
                  };
                  updateItem(item['Key'], m1);
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hive Example')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hive Flutter',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: myText,
              decoration: const InputDecoration(
                labelText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: myValue,
              decoration: const InputDecoration(
                labelText: 'Enter your age',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Map<String, String> m1 = {
                  'title': myText.text,
                  'value': myValue.text,
                };
                addItem(m1);
              },
              child: const Text('Save'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: mydata.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('Name: ${mydata[index]['title']}'),
                    subtitle: Text('Age: ${mydata[index]['value']}'),
                    leading: IconButton(
                      onPressed: () {
                        showBottomSheet(mydata[index]);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        deleteItem(mydata[index]['Key']);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
