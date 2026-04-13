import 'package:bai_market/core/app_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  int _selectedSegment = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: seconColor,
      appBar: AppBar(
        backgroundColor: seconColor,
        actions: [
          CupertinoButton(
            onPressed: () {},
            child: SvgPicture.asset('assets/icons/info_ticket.svg'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                const Spacer(),
                Text(
                  'Номера для участия в Акции',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'билеты',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '3',
                  style: TextStyle(
                    fontSize: 96,
                    fontWeight: FontWeight.w200,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: lightGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSegment = 0;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color:
                                    _selectedSegment == 0
                                        ? seconColor
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Действующей',
                                  style: TextStyle(
                                    color:
                                        _selectedSegment == 0
                                            ? Colors.black
                                            : Colors.black54,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSegment = 1;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color:
                                    _selectedSegment == 1
                                        ? seconColor
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Использованный',
                                  style: TextStyle(
                                    color:
                                        _selectedSegment == 1
                                            ? Colors.black
                                            : Colors.black54,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTile(),
                  _buildTile(),
                  _buildTile(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildTile() {
    return Container(
      height: 74,
      margin: const EdgeInsets.only(bottom: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: lightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/magic.svg'),
          const SizedBox(width: 16),
          Text(
            'Скоро подведём\nрезультаты!',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          Text(
            '#560407',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: mainColorLight,
            ),
          ),
        ],
      ),
    );
  }
}
