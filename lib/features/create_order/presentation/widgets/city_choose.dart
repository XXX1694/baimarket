import 'package:bai_market/features/create_order/data/models/city_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_pallete.dart';
import '../../../../core/urls.dart';
import '../../../../core/widgets/platform_picker_sheet.dart';

class CityChoose extends StatefulWidget {
  final TextEditingController controller;
  final int? selectedRegionId;
  final ValueChanged<String>? onCitySelected;

  const CityChoose({
    super.key,
    required this.controller,
    this.selectedRegionId,
    this.onCitySelected,
  });

  @override
  State<CityChoose> createState() => _CityChooseState();
}

class _CityChooseState extends State<CityChoose> {
  List<CityModel> cities = [];
  bool isLoading = false;
  String? error;
  CityModel? selectedCity;

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
    if (oldWidget.selectedRegionId != widget.selectedRegionId) {
      selectedCity = null;
      if (widget.selectedRegionId != null) {
        _loadCities();
      } else {
        setState(() {
          cities = [];
          isLoading = false;
        });
      }
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
        if (!mounted) return;
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
      if (kDebugMode) print('Ошибка загрузки городов: $e');
      if (!mounted) return;
      setState(() {
        error = 'Ошибка загрузки городов';
        isLoading = false;
      });
    }
  }

  Future<void> _openPicker() async {
    if (widget.selectedRegionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Сначала выберите регион'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    if (isLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Загрузка городов...')),
      );
      return;
    }
    if (error != null) {
      await _loadCities();
      return;
    }
    if (cities.isEmpty) return;

    final picked = await showPlatformItemPicker<CityModel>(
      context: context,
      title: 'Выберите город',
      items: cities,
      itemLabel: (c) => c.nameRu ?? 'Без названия',
      selected: selectedCity,
      equals: (a, b) => a.id == b.id,
    );
    if (picked == null || !mounted) return;
    setState(() => selectedCity = picked);
    widget.controller.text = picked.id.toString();
    widget.onCitySelected?.call(picked.nameRu ?? '');
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
          onTap: _openPicker,
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
                Expanded(
                  child: Text(
                    selectedCity?.nameRu ?? 'Например: Алматы',
                    style: TextStyle(
                      fontSize: 15,
                      color:
                          selectedCity != null ? Colors.black : Colors.black38,
                      fontWeight: selectedCity != null
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
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
