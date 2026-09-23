import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Mt2DesignScreen extends StatefulWidget {
  const Mt2DesignScreen({super.key});

  @override
  State<Mt2DesignScreen> createState() => _Mt2DesignScreenState();
}

class _Mt2DesignScreenState extends State<Mt2DesignScreen> {
  static final Uri _designUri = Uri.parse(
    'https://sites.super.myninja.ai/ab99191d-0c04-4158-89af-5dd10f5bd840/326ed253/index.html',
  );

  late final WebViewController _controller;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0D0718))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) setState(() => _progress = progress);
          },
        ),
      )
      ..loadRequest(_designUri);
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
        backgroundColor: const Color(0xFF0D0718),
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (_progress < 100)
                Align(
                  alignment: Alignment.topCenter,
                  child: LinearProgressIndicator(
                    value: _progress == 0 ? null : _progress / 100,
                    minHeight: 2,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
