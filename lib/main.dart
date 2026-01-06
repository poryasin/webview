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

  void initState() {
    super.initState();
    _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) {
          print("Page Start Loading: $url");
        },
        onPageFinished: (url) {
          print("Page finished loading $url");
        },
        onNavigationRequest: (request) {
          if(request.url.startsWith("https://flutter.dev/")){
            return NavigationDecision.navigate;
          }
          print("Blocked Navagation to :${request.url}");
          return NavigationDecision.prevent;
        },
      ),
    
    );
    //  ..loadRequest(Uri.parse("https://flutter.dev/"));
    _controller.loadRequest(Uri.parse("https://flutter.dev/"));
    _controller.loadFlutterAsset('assets/index.html');
   
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
            onPressed: () => _controller.reload()
          )
          
        ],
        ),
        body: WebViewWidget(controller: _controller),
      
    );
  }
}