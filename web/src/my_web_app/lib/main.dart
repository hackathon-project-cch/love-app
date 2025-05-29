import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html;
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const LoveApp());
}

class LoveApp extends StatelessWidget {
  const LoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LoveApp',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
      ),
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

  // ログイン処理を行う関数
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

    // ログイン成功で画像アップロードページへ遷移
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UploadPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // アプリ名の表示
              Text(
                "LoveApp",
                style: GoogleFonts.pacifico(
                  fontSize: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              // ログインボタン
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Login"),
              ),
              const SizedBox(height: 20),
              // メッセージの表示
              Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
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
  String status = ""; // アップロードステータスメッセージ
  html.File? selectedFile; // 選択されたファイル
  String? imageUrl; // プレビュー画像用のURL

  // ファイル選択＋プレビュー＋アップロード処理
  void pickAndPreviewFile() async {
    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click(); // ファイル選択ダイアログを開く

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files!.first;
      final reader = html.FileReader();

      reader.readAsDataUrl(file); // データURLとして読み込み（プレビュー用）

      reader.onLoadEnd.listen((event) {
        setState(() {
          selectedFile = file;
          imageUrl = reader.result as String; // 画像のプレビューURLを保存
          status = ""; // ステータス初期化
        });
      });
    });
  }

  // アップロード実行処理
  void uploadFile() async {
    if (selectedFile == null) return;

    final formData = html.FormData();
    formData.appendBlob('file', selectedFile!, selectedFile!.name);

    final request = html.HttpRequest();
    request
      ..open('POST', 'http://100.64.1.43:3000/api/upload')
      ..onLoadEnd.listen((e) {
        setState(() {
          status = request.status == 200
              ? "\u2728 アップロード成功！"
              : "\u274C アップロード失敗";
        });
      })
      ..send(formData); // フォームデータを送信
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.pinkAccent,
        elevation: 0,
        title: const Text("LoveApp - Upload Image"),
      ),
      body: Center(
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "画像を選択してアップロード",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.pinkAccent),
                ),
                const SizedBox(height: 24),

                // ファイル選択ボタン
                ElevatedButton.icon(
                  onPressed: pickAndPreviewFile,
                  icon: const Icon(Icons.image),
                  label: const Text("画像を選択"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // プレビュー画像の表示
                if (imageUrl != null)
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          imageUrl!,
                          height: 200,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: uploadFile,
                        icon: const Icon(Icons.upload),
                        label: const Text("アップロードする"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                // アップロードステータスの表示（アニメーション付き）
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    status,
                    key: ValueKey(status),
                    style: TextStyle(
                      fontSize: 18,
                      color: status.contains("成功")
                          ? Colors.green
                          : Colors.redAccent,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
