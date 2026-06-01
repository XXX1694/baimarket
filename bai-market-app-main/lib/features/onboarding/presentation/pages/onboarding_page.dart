import 'package:bai_market/core/app_pallete.dart';
import 'package:bai_market/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/main_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late AuthCubit cubit = AuthCubit();
  @override
  void initState() {
    cubit.checkAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is CodeVerified) {
          context.go('/main');
        }
      },
      builder: (context, state) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
            backgroundColor: mainColorDark,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    SvgPicture.asset('assets/icons/logo.svg'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_Slide> _slides = [
    _Slide(
      imageUrl: 'assets/images/onboarding_1.png',
      title: 'Барлық IRIS COSMETIC бір қосымшада!',
      subtitle: 'Біздің барлық өнімдерімізді бір қосымшадан таба аласыз!',
    ),
    _Slide(
      imageUrl: 'assets/images/onboarding_2.png',
      title: 'Оңай әрі Жылдам тапсырыс!',
      subtitle:
          'Бірнеше батырманы басып-ақ қалаған тауарды тез қол жеткізіңіз!',
    ),
    _Slide(
      imageUrl: 'assets/images/onboarding_3.png',
      title: 'Тікелей эфирде сатып алу!',
      subtitle: 'Ырысына Икрамбай ханымнан тікелей эфирде сатып алыңыз!',
    ),
  ];
  late AuthCubit cubit = AuthCubit();
  @override
  void initState() {
    cubit.checkAuth();
    super.initState();
  }

  void _onNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // здесь, например, Navigator.pushReplacement на главный экран
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<AuthCubit, AuthState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is CodeVerified) {
          context.go('/main');
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: mainColorDark,
          body: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 64),
                    SvgPicture.asset(
                      'assets/images/onboarding_bg.svg',
                      width: MediaQuery.of(context).size.width,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              // 1) Фоновый PageView с картинками
              PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder:
                    (_, i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 44),
                      child: Image.asset(
                        _slides[i].imageUrl,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),
              ),

              // 2) Полупрозрачный градиент (чтобы белый контейнер выглядел по‑человечески)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.8),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),

              // 3) Стационарный белый контейнер снизу
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipPath(
                  clipper: _ArcClipper(),
                  child: Container(
                    width: double.infinity,
                    height: size.height * 0.41,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      // borderRadius: BorderRadius.vertical(
                      //   top: Radius.circular(150),
                      // ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        // индикаторы
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_slides.length, (i) {
                            bool active = i == _currentPage;
                            return AnimatedContainer(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              duration: const Duration(milliseconds: 200),
                              width: active ? 20 : 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color:
                                    active
                                        ? Colors.green
                                        : Colors.green.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 32),

                        // заголовок
                        Text(
                          _slides[_currentPage].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // подзаголовок
                        Text(
                          _slides[_currentPage].subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        MainButton(
                          onPressed:
                              _currentPage != 2
                                  ? _onNext
                                  : () {
                                    context.go('/auth');
                                  },
                          text: _currentPage != 2 ? 'Келесі' : 'Кіру',
                        ),

                        const SizedBox(height: 64),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Slide {
  final String imageUrl;
  final String title;
  final String subtitle;
  _Slide({required this.imageUrl, required this.title, required this.subtitle});
}

class _ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // начинаем слева на 40px ниже верхнего края контейнера
    path.moveTo(0, 50);
    // кривая до правой точки на том же уровне через контрольную точку над центром
    path.quadraticBezierTo(
      size.width / 2,
      -50, // контрольная точка (высоко вверх)
      size.width,
      50, // конец дуги
    );
    // далее по контуру
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> old) => false;
}
