import 'package:bai_market/core/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class FilialChoose extends StatefulWidget {
  const FilialChoose({
    super.key,
    required this.controller,
    required this.pickupUrls,
    required this.city,
  });
  final TextEditingController controller;
  final List<String> pickupUrls;
  final String city;
  @override
  State<FilialChoose> createState() => _FilialChooseState();
}

class _FilialChooseState extends State<FilialChoose> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'Выберите пункт выдачи',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.pickupUrls.length,
            itemBuilder:
                (context, index) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  height: 140,
                  width: 175,
                  decoration: BoxDecoration(
                    color: mainColorLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.city,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Қазыбек би 45',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset('assets/icons/check.svg'),
                          GestureDetector(
                            onTap: () {
                              print(widget.pickupUrls[0]);
                              _openInApp(widget.pickupUrls[0]);
                            },
                            child: SvgPicture.asset('assets/icons/2gis.svg'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          ),
        ),
      ],
    );
  }

  Future<void> _openInApp(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.inAppWebView, // вот он — in‑app WebView
      webViewConfiguration: const WebViewConfiguration(
        enableJavaScript: true, // если нужна JS-поддержка
      ),
    )) {
      throw 'Не удалось открыть $url';
    }
  }
}
