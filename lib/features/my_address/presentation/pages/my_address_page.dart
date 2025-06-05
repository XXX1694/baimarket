import 'package:bai_market/core/app_pallete.dart';
import 'package:bai_market/core/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bai_market/features/my_address/presentation/cubit/my_address_cubit.dart';
import 'package:bai_market/features/my_address/data/datasources/user_address_remote_datasource.dart';
import 'package:bai_market/features/my_address/data/repositories/user_address_repository_impl.dart';
import 'package:bai_market/core/urls.dart';
import 'package:dio/dio.dart';
import 'add_address_page.dart';

class MyAddressPage extends StatelessWidget {
  const MyAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => MyAddressCubit(
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
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Мои адреса',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              BlocConsumer<MyAddressCubit, MyAddressState>(
                listener: (context, state) {
                  if (state is MyAddressError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  if (state is MyAddressLoaded && state.addresses.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Нет сохранённых адресов'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is MyAddressLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is MyAddressLoaded && state.addresses.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: state.addresses.length,
                      itemBuilder: (context, index) {
                        final address = state.addresses[index];
                        return Container(
                          height: 130,
                          padding: const EdgeInsets.fromLTRB(20, 8, 4, 20),
                          margin: EdgeInsets.only(
                            top: index == 0 ? 20 : 0,
                            bottom: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      'Адрес "${address.label}"',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: mainColorLight,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Expanded(
                                      child: Text(
                                        address.addressLine,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black54,
                                        ),
                                        overflow: TextOverflow.clip,
                                        maxLines: 2,
                                      ),
                                    ),
                                    Text(
                                      'индекс: ${address.postalCode}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (ctx) => AlertDialog(
                                          title: const Text('Удалить адрес?'),
                                          content: const Text(
                                            'Вы уверены, что хотите удалить этот адрес?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () =>
                                                      Navigator.pop(ctx, false),
                                              child: const Text('Отмена'),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () =>
                                                      Navigator.pop(ctx, true),
                                              child: const Text(
                                                'Удалить',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  );
                                  if (confirm == true) {
                                    await context
                                        .read<MyAddressCubit>()
                                        .deleteAddress(address.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Адрес удалён'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  // Если нет адресов
                  return Center(
                    child: Text(
                      'У вас пока нет сохранённых адресов',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: MainButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => BlocProvider.value(
                                value: context.read<MyAddressCubit>(),
                                child: AddAddressPage(),
                              ),
                        ),
                      );
                      if (result == true) {
                        await context.read<MyAddressCubit>().loadAddresses();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Адрес успешно добавлен'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    text: 'Добавить еще адрес',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
