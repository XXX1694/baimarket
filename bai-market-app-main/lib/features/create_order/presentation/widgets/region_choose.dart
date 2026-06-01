import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/app_pallete.dart';
import '../../../../core/urls.dart';

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
  String? selectedRegion;

  @override
  void initState() {
    super.initState();
    _loadRegions();
  }

  Future<void> _loadRegions() async {
    try {
      final response = await Dio().get('${mainUrl}region');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          regions = data.map((json) => RegionModel.fromJson(json)).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Ошибка загрузки регионов';
        isLoading = false;
      });
    }
  }

  void _showRegionSelectionModal() {
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
                        'Выберите регион',
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
                          onPressed: _loadRegions,
                          child: const Text('Попробовать снова'),
                        ),
                      ],
                    ),
                  )
                else if (regions.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Список регионов пуст'),
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
                        itemCount: regions.length,
                        itemBuilder: (context, index) {
                          final region = regions[index];
                          return ListTile(
                            title: Text(
                              region.nameRu,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selectedRegion = region.nameRu;
                              });
                              widget.controller.text = region.id.toString();
                              widget.onRegionSelected(region.id);
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
          onTap: _showRegionSelectionModal,
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
                  selectedRegion ?? 'Например: Акмолинская область',
                  style: TextStyle(
                    fontSize: 15,
                    color:
                        selectedRegion != null ? Colors.black : Colors.black38,
                    fontWeight:
                        selectedRegion != null
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
