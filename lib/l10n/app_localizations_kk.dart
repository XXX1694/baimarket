// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get appName => 'Bai Market';

  @override
  String get welcome => 'Қош келдіңіз';

  @override
  String get login => 'Кіру';

  @override
  String get register => 'Тіркелу';

  @override
  String get email => 'Электрондық пошта';

  @override
  String get password => 'Құпия сөз';

  @override
  String get confirmPassword => 'Құпия сөзді растау';

  @override
  String get forgotPassword => 'Құпия сөзді ұмыттыңыз ба?';

  @override
  String get dontHaveAccount => 'Тіркелгіңіз жоқ па?';

  @override
  String get alreadyHaveAccount => 'Тіркелгіңіз бар ма?';

  @override
  String get phone => 'Телефон';

  @override
  String get name => 'Аты';

  @override
  String get surname => 'Тегі';

  @override
  String get phoneNumber => 'Телефон нөмірі';

  @override
  String get enterName => 'Атыңызды енгізіңіз';

  @override
  String get enterSurname => 'Тегіңізді енгізіңіз';

  @override
  String get enterPhone => 'Телефон нөміріңізді енгізіңіз';

  @override
  String get enterEmail => 'Email-діңізді енгізіңіз';

  @override
  String get enterPassword => 'Құпия сөзіңізді енгізіңіз';

  @override
  String get enterConfirmPassword => 'Құпия сөзіңізді растаңыз';

  @override
  String get cart => 'Себет';

  @override
  String get favorites => 'Таңдаулылар';

  @override
  String get profile => 'Профиль';

  @override
  String get settings => 'Баптаулар';

  @override
  String get language => 'Тіл';

  @override
  String get notifications => 'Хабарландырулар';

  @override
  String get logout => 'Шығу';

  @override
  String get catalog => 'Каталог';

  @override
  String get freeDelivery => 'Тегін жеткізу';

  @override
  String get deliveryAddress => 'Жеткізу мекенжайы:';

  @override
  String get addressExample => 'Мысалы: Әуезов 34';

  @override
  String get postalCode => 'Пошта индексі';

  @override
  String get cardNumber => 'Карта нөмірі';

  @override
  String get enterCardNumber => 'Карта нөмірін енгізіңіз';

  @override
  String get cvv => 'CVV';

  @override
  String get whoWillMeet => 'Кім қарсы алады (Толық аты-жөні)?';

  @override
  String get nameExample => 'Мысалы: Даниял Асылбеков';

  @override
  String get tryAgain => 'Қайталап көріңіз';

  @override
  String get emptyCityList => 'Қалалар тізімі бос';

  @override
  String get productName => 'Өнім атауы';

  @override
  String get productDescription => 'Өнім сипаттамасы';

  @override
  String get homeAddress => '\"Үй\" мекенжайы';

  @override
  String postalIndex(String index) {
    return 'индекс: $index';
  }

  @override
  String get myAddresses => 'Менің мекенжайларым';

  @override
  String get orderHistory => 'Тапсырыстар тарихы';

  @override
  String get support => 'Қолдау қызметі';

  @override
  String get supportTitle => 'Қолдау қызметі';

  @override
  String get supportWorkingHours => 'Біз сізге көмеkтесуге\nдайын әр күні 9:00 - 22:00';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get telegram => 'Telegram';

  @override
  String get faq => 'Жиі қойылатын сұрақтар';

  @override
  String failedToOpen(String url) {
    return '$url ашу мүмкін емес';
  }

  @override
  String get exitApp => 'Қолданбадан шығу';

  @override
  String get exitConfirmation => 'Сіз шынымен қолданбадан шығғыңыз келе ме?';

  @override
  String get cancel => 'Бас тарту';

  @override
  String get notInStock => 'Сатылымда жоқ';

  @override
  String get youWon => 'Сіз жеңдіңіз!';

  @override
  String get weWillContactYou => 'Жақында сізбен байланысамыз';

  @override
  String index(String index) {
    return 'Индекс: $index';
  }

  @override
  String price(String price) {
    return '$price ₸';
  }

  @override
  String oldPrice(String price) {
    return '$price ₸';
  }

  @override
  String get productDescriptionShort => 'Барлық макияжда жеңілдік пен ыңғайлылықты қамтамасыз етеді...';

  @override
  String get home => 'Басты бет';

  @override
  String get products => 'тауарлар';

  @override
  String get more => 'Толығырақ';

  @override
  String get in_sale => 'Сатылымда';

  @override
  String get not_in_sale => 'Сатылымда жоқ';

  @override
  String get purchases => 'Сатып алулар';

  @override
  String get orderAgain => 'Қайта тапсырыс беру';

  @override
  String get myPrizes => 'Менің ұтыстарым';

  @override
  String get noPrizes => 'Ұтыс жоқ';

  @override
  String get cartEmpty => 'Себет бос';

  @override
  String get addedItemsWillAppearHere => 'Қосылған тауарлар\nмұнда көрсетіледі';

  @override
  String get goToShopping => 'Сатып алуға өту';

  @override
  String get proceedToCheckout => 'Рәсімдеуге өту';

  @override
  String pricePerItem(String price) {
    return '$price тг/дана';
  }

  @override
  String get cannotAddMore => 'Қосымша қосу мүмкін емес. Бұл максимум.';

  @override
  String get prize_goods => 'Ұтыстың товарлары';

  @override
  String get number_of_tickets => 'Акцияға қатысу нөмірі';

  @override
  String get tickets => 'билеттер';

  @override
  String get description => 'Сипаттама';

  @override
  String get addToCart => 'Себетке қосу';

  @override
  String get productOutOfStock => 'Тауар қоймада жоқ!';

  @override
  String get productAddedToCart => 'Тауар сәтті себетке қосылды!';

  @override
  String get goToCart => 'Себетке өту';

  @override
  String get showFirst => 'Алдымен көрсету';

  @override
  String get sortPopular => 'Танымал';

  @override
  String get sortCheap => 'Алдымен арзан';

  @override
  String get sortExpensive => 'Алдымен қымбат';

  @override
  String get myData => 'Менің деректерім';

  @override
  String get save => 'Сақтау';

  @override
  String get deleteAccount => 'Тіркелгіні жою';

  @override
  String get fillAllFields => 'Барлық өрістерді толтырыңыз';

  @override
  String profileUpdateError(String message) {
    return 'Профильді жаңарту кезінде қате: $message';
  }

  @override
  String error(String message) {
    return 'Қате: $message';
  }

  @override
  String get faqTicketAfterPayment => 'Төлемнен кейін билет қалай беріледі?';

  @override
  String get faqTicketAfterPaymentAnswer => 'Төлемнен кейін билет автоматты түрде беріледі. Сіз оны Менің профилім бөлімінде көре аласыз.';

  @override
  String get faqDeliveryMethod => 'Жеткізу қалай жүргізіледі?';

  @override
  String get faqDeliveryMethodAnswer => 'Жеткізу ҚазПошта арқылы жүргізіледі. Тапсырыс жіберілген кезде сіз хабарландыру аласыз.';

  @override
  String get faqDeliveryTime => 'Жеткізу қанша уақыт алады?';

  @override
  String get faqDeliveryTimeAnswer => 'Жеткізу әдетте 3-7 жұмыс күні алады, сіздің аймағыңызға байланысты.';

  @override
  String get faqCancelOrder => 'Төлемнен кейін тапсырысты болдырмауға бола ма?';

  @override
  String get faqCancelOrderAnswer => 'Иә, тапсырысты жіберілгенге дейін болдыра аласыз. Ол үшін біздің қолдау қызметімен байланысыңыз.';

  @override
  String get faqTrackOrder => 'Тапсырысты қалай қадағалауға болады?';

  @override
  String get faqTrackOrderAnswer => 'Жіберілгеннен кейін сіз қадағалау нөмірін аласыз. Сіз пакетті ҚазПошта веб-сайтында немесе Менің тапсырыстарым бөлімінде қадағалай аласыз.';

  @override
  String get errorTitle => 'Қате';

  @override
  String get success => 'Сәтті!';

  @override
  String get orderDetails => 'Тапсырыс туралы';

  @override
  String get noData => 'Деректер жоқ';

  @override
  String get recipient => 'Алушы:';

  @override
  String get noName => 'Аты жоқ';

  @override
  String get noPhone => 'Телефон нөмірі жоқ';

  @override
  String get deliveryDate => 'Жеткізу күні:';

  @override
  String orderId(String id) {
    return 'Тапсырыс ID: $id';
  }

  @override
  String get orderStatusPaymentPending => 'Төлем күтілуде';

  @override
  String get orderStatusProcessing => 'Өңделуде';

  @override
  String get orderStatusWay => 'Жолда';

  @override
  String get orderStatusPickup => 'Алу пунктісінде күтілуде';

  @override
  String get orderStatusDelivered => 'Алынды';

  @override
  String get orderStatusCanceled => 'Бас тартылды';

  @override
  String get orderStatusAssembling => 'Тапсырыс жиналуда';

  @override
  String get orderStatusAbandoned => 'Бас тартылды';

  @override
  String get orderStatusPaymentFailed => 'Төлем қатесі';

  @override
  String get orderProcessingMessage => 'Сіздің тауарларыңыз брондалды, тапсырыс өңделуде. Тапсырыс жинауға берілгенде сіз хабарландыру аласыз';

  @override
  String get ticketsWillBeAwarded => 'Билеттер есептеледі';

  @override
  String get totalAmount => 'Жалпы сома';

  @override
  String get items => 'Тауарлар';

  @override
  String get discount => 'Жеңілдік';

  @override
  String get promotionalNumbers => 'Акциялық нөмірлер';

  @override
  String get delivery => 'Жеткізу';

  @override
  String get free => 'Тегін';

  @override
  String get total => 'Барлығы';

  @override
  String get paid => 'Төленді';

  @override
  String get unpaid => 'Төленбеді';

  @override
  String get enterPhoneNumber => 'Телефон нөміріңізді \nенгізіңіз';

  @override
  String get weWillSendSms => 'Растау коды бар SMS жібереміз';

  @override
  String get getCode => 'Код алу';

  @override
  String get termsAndPrivacy => '\"Код алу\" түймесін басу арқылы сіз пайдалану шарттарын және құпиялылық саясатын қабылдайсыз';

  @override
  String get enterCode => 'Кодты енгізіңіз';

  @override
  String sentToNumber(String phoneNumber) {
    return 'Оны +7 $phoneNumber нөміріне жібердік \n';
  }

  @override
  String get signIn => 'Кіру';

  @override
  String get market => 'Маркет';

  @override
  String get streams => 'Эфирлер';

  @override
  String get orders => 'Тапсырыстар';

  @override
  String get searchHint => 'Не іздедіңіз?';

  @override
  String get all => 'Барлығы';

  @override
  String get plusPrice => 'Plus-пен алсаңыз';

  @override
  String sellerOrders(String count) {
    return '$count тапсырыс';
  }

  @override
  String get reviews => 'Пікірлер';

  @override
  String reviewsCount(String count) {
    return '$count пікір';
  }

  @override
  String get readAll => 'Барлығын оқу';

  @override
  String get relatedProducts => 'Сізге ұнауы мүмкін';

  @override
  String get buy => 'Сатып алу';

  @override
  String get newTag => 'Жаңа';

  @override
  String get hitTag => 'Хит';

  @override
  String get myTickets => 'Менің билеттерім';

  @override
  String get specifyDeliveryAddress => 'Жеткізу мекенжайын көрсетіңіз';

  @override
  String get myOrders => 'Менің тапсырыстарым';

  @override
  String get orderStatus => 'Тапсырыс күйі';

  @override
  String get myCard => 'Менің картам';

  @override
  String get contacts => 'Байланыстар';

  @override
  String get inviteFriends => 'Достарыңызды шақырыңыз';

  @override
  String get goToPayment => 'Төлемге өту';

  @override
  String get clearCart => 'Тазалау';

  @override
  String get youSaved => 'Сіз үнемдедіңіз';

  @override
  String get recommended => 'Ұсынамыз';

  @override
  String get notAvailable => 'Қолжетімсіз';

  @override
  String get defaultDescription => 'Күнделікті күтімге арналған жоғары сапалы өнім. Мұқият таңдалған компоненттер тиімді нәтиже береді. Барлық тері түрлеріне жарамды. Мамандар ұсынған өнім.';

  @override
  String get liveNow => 'Қазір эфирде';

  @override
  String get otpSubtitle => 'Телефоныңызға 4 таңбалы код\nжібердік';

  @override
  String get resendCode => 'Кодты қайта жіберу';

  @override
  String get confirm => 'Растау';

  @override
  String get continueAction => 'Жалғастыру';

  @override
  String get notificationCategoryPurchase => 'Сатып алу';

  @override
  String get notificationCategoryDelivery => 'Жеткізу';

  @override
  String get notificationCategoryStream => 'Эфирлер';

  @override
  String get notificationCategorySubscription => 'Жазылым';

  @override
  String get noNotifications => 'Хабарландырулар жоқ';

  @override
  String get selectAddress => 'Мекенжай таңдаңыз';

  @override
  String get noSavedAddresses => 'Сізде сақталған мекенжайлар жоқ';

  @override
  String get addAddress => 'Мекенжай қосу';
}
