import 'package:bai_market/core/app_pallete.dart';
import 'package:bai_market/core/widgets/main_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/urls.dart';
import '../../data/datasources/user_address_remote_datasource.dart';
import '../../data/repositories/user_address_repository_impl.dart';
import '../cubit/my_address_cubit.dart';
import '../widgets/add_address_bottom_sheet.dart';
import '../widgets/saved_address_card.dart';

class MyAddressPage extends StatelessWidget {
  const MyAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyAddressCubit(
        UserAddressRepositoryImpl(
          UserAddressRemoteDatasource(Dio(), mainUrl),
        ),
      )..loadAddresses(),
      child: const _MyAddressView(),
    );
  }
}

class _MyAddressView extends StatelessWidget {
  const _MyAddressView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: lightGray,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: SvgPicture.asset(
            'assets/icons/arrow_left.svg',
            height: 20,
            width: 20,
          ),
        ),
        title: const Text(
          'Адреса доставки',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<MyAddressCubit, MyAddressState>(
          listener: (context, state) {
            if (state is MyAddressError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                _buildContent(context, state),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: _AddAddressButton(
                      onPressed: () async {
                        final added =
                            await AddAddressBottomSheet.show(context);
                        if (added == true && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Адрес успешно добавлен'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MyAddressState state) {
    if (state is MyAddressLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is MyAddressLoaded && state.addresses.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        itemCount: state.addresses.length,
        itemBuilder: (context, index) {
          final address = state.addresses[index];
          return SavedAddressCard(
            address: address,
            onDelete: () => _confirmDelete(context, address.id),
          );
        },
      );
    }
    if (state is MyAddressLoaded && state.addresses.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'У вас пока нет сохранённых адресов',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Future<void> _confirmDelete(BuildContext context, int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить адрес?'),
        content: const Text('Вы уверены, что хотите удалить этот адрес?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      await context.read<MyAddressCubit>().deleteAddress(id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Адрес удалён'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}

class _AddAddressButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _AddAddressButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MainButton(
      onPressed: onPressed,
      text: '+  Добавить еще адрес',
    );
  }
}
