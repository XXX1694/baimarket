import 'package:bai_market/features/create_order/data/models/city_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/app_pallete.dart';
import '../../../../core/urls.dart';

class CityChoose extends StatefulWidget {
  final TextEditingController controller;
  final int? selectedRegionId;

  const CityChoose({
    super.key,
    required this.controller,
    this.selectedRegionId,
  });

  @override
  State<CityChoose> createState() => _CityChooseState();
}

class _CityChooseState extends State<CityChoose> {
  List<CityModel> cities = [];
  bool isLoading = false;
  String? error;
  String? selectedCity;

  @override
  void initState() {
    super.initState();
    if (widget.selectedRegionId != null) {
      _loadCities();
    }
  }

  @override
  void didUpdateWidget(CityChoose oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedRegionId != widget.selectedRegionId &&
        widget.selectedRegionId != null) {
      _loadCities();
    }
  }

  Future<void> _loadCities() async {
    if (widget.selectedRegionId == null) {
      setState(() {
        cities = [];
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await Dio().get(
        '${mainUrl}city',
        queryParameters: {'regionId': widget.selectedRegionId.toString()},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          cities = data.map((json) => CityModel.fromJson(json)).toList();
          isLoading = false;
        });
        if (kDebugMode) {
          print(
            'Загружено городов: ${cities.length} для региона ${widget.selectedRegionId}',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Ошибка загрузки городов: $e');
      }
      setState(() {
        error = 'Ошибка загрузки городов';
        isLoading = false;
      });
    }
  }

  void _showCitySelectionModal() {
    if (widget.selectedRegionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Сначала выберите регион'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      isScrollControlled: false,
      builder: (context) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: Column(
              children: [
                Container(
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Выберите город',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: mainColorLight,
                        ),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/cancel.svg',
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  )
                else if (error != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(error!, style: const TextStyle(color: Colors.red)),
                        ElevatedButton(
                          onPressed: _loadCities,
                          child: const Text('Попробовать снова'),
                        ),
                      ],
                    ),
                  )
                else if (cities.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Список городов пуст'),
                  )
                else
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: cities.length,
                        itemBuilder: (context, index) {
                          final city = cities[index];
                          return ListTile(
                            title: Text(
                              city.nameRu ?? 'Город без названия',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selectedCity = city.nameRu;
                              });
                              widget.controller.text = city.id.toString();
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      backgroundColor: Color(0xFFF7F7F7),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedRegionId == null) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: const Text(
          'Сначала выберите регион',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'Выберите город',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _showCitySelectionModal,
          child: Container(
            height: 56,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: lightGray,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedCity ?? 'Например: Алматы',
                  style: TextStyle(
                    fontSize: 15,
                    color: selectedCity != null ? Colors.black : Colors.black38,
                    fontWeight:
                        selectedCity != null
                            ? FontWeight.w500
                            : FontWeight.w400,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.black38),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
