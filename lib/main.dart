import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebView Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'WebView Navigation & Events'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final WebViewController _controller;
  late final WebViewController _controller1;
  late final WebViewController _controller2;

  bool _isLoading = false;

  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);
            print("Page Start Loading: $url");
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
            print("Page finished loading $url");
          },
          onNavigationRequest: (request) {
            final url = request.url;

            final allow =
                url.startsWith("https://flutter.dev/") ||
                url.startsWith("https://docs.flutter.dev/");

            if (allow) return NavigationDecision.navigate;

            debugPrint("Blocked Navigation to: $url");
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse("https://flutter.dev/"));
    _controller1 = WebViewController()..loadFlutterAsset('assets/index.html');
    _controller2 = WebViewController()
      ..loadHtmlString(
        "<head><title>Local HTML</title><body></head><body><h2>Loaded from index2</h2></body>",
      );
    // _controller.loadRequest(Uri.parse("https://flutter.dev/"));
    // _controller.loadFlutterAsset('assets/index.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebView Flutter"),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _controller.canGoBack()) {
                _controller.goBack();
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () async {
              if (await _controller.canGoForward()) {
                _controller.goForward();
              }
            },
          ),

          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Expanded(child: WebViewWidget(controller: _controller1),),
          // const Divider(thickness: 2,height: 1),
          WebViewWidget(controller: _controller),

          if (_isLoading)
            const ColoredBox(
              color: Color(0x66000000),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
          // const Divider(thickness: 2,height: 1),
          // Expanded(child: WebViewWidget(controller: _controller2),),
          
   
