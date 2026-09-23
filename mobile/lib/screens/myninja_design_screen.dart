import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Mt2DesignScreen extends StatefulWidget {
  const Mt2DesignScreen({super.key});

  @override
  State<Mt2DesignScreen> createState() => _Mt2DesignScreenState();
}

class _Mt2DesignScreenState extends State<Mt2DesignScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF06031A))
      ..loadFlutterAsset('assets/mt2_design/index.html');
  }

  Future<bool> _handleBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _handleBack();
        if (shouldPop && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF06031A),
        body: SafeArea(
          bottom: false,
          child: WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}
