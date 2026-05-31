import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CloudflareSolverDialog extends StatefulWidget {
  final String url;

  const CloudflareSolverDialog({super.key, required this.url});

  @override
  State<CloudflareSolverDialog> createState() => _CloudflareSolverDialogState();
}

class _CloudflareSolverDialogState extends State<CloudflareSolverDialog> {
  late final WebViewController _controller;
  bool _isResolved = false;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            // Check if Cloudflare clearance cookie exists now via document.cookie
            final rawCookies = await _controller.runJavaScriptReturningResult('document.cookie') as String;
            final cookieString = rawCookies.replaceAll('"', '');
            final cfClearanceMatch = RegExp(r'cf_clearance=([^;]+)').firstMatch(cookieString);
            final cfClearanceValue = cfClearanceMatch?.group(1) ?? '';

            if (cfClearanceValue.isNotEmpty && !_isResolved) {
              _isResolved = true;
              
              // Extract User-Agent from the webview to prevent TLS/Header mismatch blocks
              final userAgent = await _controller.runJavaScriptReturningResult('navigator.userAgent') as String;
              
              // Sanitize the JavaScript string return
              final cleanUserAgent = userAgent.replaceAll('"', '');

              if (mounted) {
                Navigator.of(context).pop({
                  'cookie': 'cf_clearance=$cfClearanceValue',
                  'userAgent': cleanUserAgent,
                });
              }
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Verification'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(null),
          )
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}