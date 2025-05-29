import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

import 'dart:html' as html;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Flask Demo',
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String message = "";

  void login() async {
    final url = Uri.parse("http://100.64.1.43:3000/api/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"username": "admin", "password": "secret"}),
    );

    setState(() {
      final data = json.decode(response.body);
      message = data["message"] ?? "Login success!";
    });

    if (response.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const UploadPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: login, child: const Text("Login")),
            const SizedBox(height: 20),
            Text(message),
          ],
        ),
      ),
    );
  }
}

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String status = "";

  void uploadFile() async {
    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files!.first;
      final reader = html.FileReader();

      reader.readAsArrayBuffer(file);

      reader.onLoadEnd.listen((event) async {
        final formData = html.FormData();
        formData.appendBlob('file', file, file.name);

        final request = html.HttpRequest();
        request
          ..open('POST', 'http://100.64.1.43:3000/api/upload') // ← 自分のIPに合わせてください
          ..onLoadEnd.listen((e) {
            setState(() {
              status = request.status == 200 ? "アップロード成功！" : "アップロード失敗";
            });
          })
          ..send(formData);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Image")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: uploadFile, child: const Text("画像を選択してアップロード")),
            const SizedBox(height: 20),
            Text(status),
          ],
        ),
      ),
    );
  }
}