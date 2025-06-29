import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html;
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const LoveApp()); // アプリ起動
}

// アプリ全体のルートWidget
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
      home: const LoginPage(), // 最初に表示される画面
    );
  }
}

// ログインページ
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String message = ""; // ログイン後のメッセージ表示用

  // ログイン処理（固定ユーザー認証）
  void login() async {
    
    //final url = Uri.parse("https://cosmic-quarter-459713-t9.an.r.appspot.com/api/login");
    final url = Uri.parse("http://localhost:3000/api/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"username": "admin", "password": "secret"}),
    );

    // レスポンスメッセージを表示
    setState(() {
      final data = json.decode(response.body);
      message = data["message"] ?? "Login success!";
    });

    // ステータス200であればUploadPageへ遷移
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
        // グラデーション背景
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
              // アプリタイトル表示
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

// 画像アップロード画面
class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String status = ""; // アップロードステータスメッセージ
  html.File? selectedFile; // 選択された画像ファイル
  String? imageUrl; // 画像プレビュー表示用のURL

  // ファイル選択・プレビュー表示
  void pickAndPreviewFile() async {
    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click(); // ファイル選択ダイアログを開く

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files!.first;
      final reader = html.FileReader();

      reader.readAsDataUrl(file); // プレビュー用にBase64形式で読み込む

      reader.onLoadEnd.listen((event) {
        setState(() {
          selectedFile = file;
          imageUrl = reader.result as String;
          status = ""; // ステータスを初期化
        });
      });
    });
  }

  // 選択されたファイルをFlaskへPOST送信
  void uploadFile() async {
    if (selectedFile == null) return;

    final formData = html.FormData();
    formData.appendBlob('file', selectedFile!, selectedFile!.name);

    final request = html.HttpRequest();
    request
      //..open('POST', 'https://cosmic-quarter-459713-t9.an.r.appspot.com/api/upload')
      ..open('POST', 'http://localhost:3000/api/upload')
      ..onLoadEnd.listen((e) async {
        setState(() {
          status = request.status == 200
              ? "\u2728 アップロード成功！"
              : "\u274C アップロード失敗";
        });

        // アップロード成功時におすすめ画像を取得
        if (request.status == 200) {
          //final response = await http.get(Uri.parse("https://cosmic-quarter-459713-t9.an.r.appspot.com/api/get_sample_image"));
          final response = await http.get(Uri.parse("http://localhost:3000/api/get_sample_image"));
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final sampleImageUrl = data["image_url"];
            final recommendation = data["recommendation"];

            // 結果ページに遷移
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultPage(
                  imageUrl: sampleImageUrl,
                  recommendation: recommendation,
                ),
              ),
            );
          }
        }
      })
      ..send(formData); // リクエスト送信
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.pinkAccent,
        elevation: 0,
        title: const Text("LoveApp - Best Hair スタイリスト"),
      ),
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 見出し
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

                // プレビュー画像とアップロードボタン
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

                // ステータス表示（アニメーション付き）
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

// 結果表示ページ（おすすめの髪型と画像を表示）
class ResultPage extends StatelessWidget {
  final String imageUrl;       // 画像のURL
  final String recommendation; // おすすめメッセージ

  const ResultPage({
    super.key,
    required this.imageUrl,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.pinkAccent,
        title: const Text("おすすめの髪型"),
        elevation: 0,
      ),
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 画像表示
                if (imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      imageUrl,
                      height: 200,
                    ),
                  ),
                const SizedBox(height: 24),
                // 推奨コメント
                Text(
                  recommendation,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
