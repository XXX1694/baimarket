import 'dart:io';
import 'package:bai_market/core/app_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String? paymentUrl;

  const PaymentPage({super.key, required this.paymentUrl});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isLoading = true;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (_) {
                setState(() {
                  _isLoading = false;
                });
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.paymentUrl ?? ''));
  }

  void _onPaidPressed() {
    context.go('/main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Оплата картой',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        actions: [
          CupertinoButton(
            child: const Text(
              'Далее',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: mainColorLight,
              ),
            ),
            onPressed: () {
              _showExitConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  if (_isLoading)
                    Container(
                      color: Colors.white,
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Идёт оплата...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: MainButton(onPressed: _onPaidPressed, text: 'Я оплатил'),
            // ),
          ],
        ),
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    if (Platform.isAndroid) {
      _showAndroidExitDialog(context);
    } else if (Platform.isIOS) {
      _showIOSExitDialog(context);
    }
  }

  void _showAndroidExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Завершить покупку'),
          content: Text('Вы оплатили?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог
              },
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                _onPaidPressed();
              },
              child: Text('Далее'),
            ),
          ],
        );
      },
    );
  }

  void _showIOSExitDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Завершить покупку'),
          content: Text('Вы оплатили?'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог
              },
              isDefaultAction: true,
              child: Text('Отмена'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                _onPaidPressed();
              },
              isDestructiveAction: true,
              child: Text('Далее'),
            ),
          ],
        );
      },
    );
  }
}
