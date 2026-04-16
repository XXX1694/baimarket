import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_pallete.dart';
import '../../../../core/urls.dart';
import '../../../../core/widgets/platform_picker_sheet.dart';

class RegionModel {
  final int id;
  final String nameRu;
  final String nameKz;
  final String nameEn;
  final int filialId;

  RegionModel({
    required this.id,
    required this.nameRu,
    required this.nameKz,
    required this.nameEn,
    required this.filialId,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id'],
      nameRu: json['nameRu'],
      nameKz: json['nameKz'],
      nameEn: json['nameEn'],
      filialId: json['filialId'],
    );
  }
}

class RegionChoose extends StatefulWidget {
  final TextEditingController controller;
  final Function(int) onRegionSelected;

  const RegionChoose({
    super.key,
    required this.controller,
    required this.onRegionSelected,
  });

  @override
  State<RegionChoose> createState() => _RegionChooseState();
}

class _RegionChooseState extends State<RegionChoose> {
  List<RegionModel> regions = [];
  bool isLoading = true;
  String? error;
  RegionModel? selectedRegion;

  @override
  void initState() {
    super.initState();
    _loadRegions();
  }

  Future<void> _loadRegions() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final response = await Dio().get('${mainUrl}region');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (!mounted) return;
        setState(() {
          regions = data.map((json) => RegionModel.fromJson(json)).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'Ошибка загрузки регионов';
        isLoading = false;
      });
    }
  }

  Future<void> _openPicker() async {
    if (isLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Загрузка регионов...')),
      );
      return;
    }
    if (error != null) {
      await _loadRegions();
      return;
    }
    if (regions.isEmpty) return;

    final picked = await showPlatformItemPicker<RegionModel>(
      context: context,
      title: 'Выберите регион',
      items: regions,
      itemLabel: (r) => r.nameRu,
      selected: selectedRegion,
      equals: (a, b) => a.id == b.id,
    );
    if (picked == null || !mounted) return;
    setState(() => selectedRegion = picked);
    widget.controller.text = picked.id.toString();
    widget.onRegionSelected(picked.id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'Выберите регион',
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
                    selectedRegion?.nameRu ?? 'Например: Акмолинская область',
                    style: TextStyle(
                      fontSize: 15,
                      color: selectedRegion != null
                          ? Colors.black
                          : Colors.black38,
                      fontWeight: selectedRegion != null
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
