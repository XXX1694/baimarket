import '../../../catalog/data/models/category_product_model.dart';
import '../models/gift_model.dart';
import '../models/raffle_model.dart';
import '../models/raffle_products_response.dart';
import '../models/seller_model.dart';

/// Local fallback data used when the backend returns no active raffles.
/// Mock entities use negative ids so we never collide with real backend ids.
class RaffleMock {
  const RaffleMock._();

  static const _isoNow = '2026-04-16T12:00:00.000Z';

  static bool isMockId(int id) => id < 0;

  static List<RaffleModel> raffles() => [
        RaffleModel(
          id: -1,
          startDate: '2026-04-01T00:00:00.000Z',
          endDate: '2026-04-21T19:00:00.000Z',
          isActive: true,
          createdAt: _isoNow,
          seller: const SellerModel(
            id: -1,
            nameKz: 'Ырысбала Икрамбай',
            nameRu: 'Ырысбала Икрамбай',
            nameEn: 'Yrysbala Ikrambai',
            slug: 'mock-seller-1',
            isOwn: false,
          ),
          gifts: const [
            GiftModel(
              id: -11,
              name: 'iPhone 15 Pro',
              photoUrl: null,
            ),
            GiftModel(
              id: -12,
              name: 'AirPods Pro',
              photoUrl: null,
            ),
            GiftModel(
              id: -13,
              name: 'Apple Watch',
              photoUrl: null,
            ),
          ],
        ),
        RaffleModel(
          id: -2,
          startDate: '2026-04-05T00:00:00.000Z',
          endDate: '2026-05-01T18:30:00.000Z',
          isActive: true,
          createdAt: _isoNow,
          seller: const SellerModel(
            id: -2,
            nameKz: 'Bai Market',
            nameRu: 'Bai Market',
            nameEn: 'Bai Market',
            slug: 'bai-market',
            isOwn: true,
          ),
          gifts: const [
            GiftModel(
              id: -21,
              name: 'Подарочный сертификат 50 000 ₸',
              photoUrl: null,
            ),
            GiftModel(
              id: -22,
              name: 'Набор косметики',
              photoUrl: null,
            ),
          ],
        ),
        RaffleModel(
          id: -3,
          startDate: '2026-04-10T00:00:00.000Z',
          endDate: '2026-05-10T20:00:00.000Z',
          isActive: true,
          createdAt: _isoNow,
          seller: const SellerModel(
            id: -3,
            nameKz: 'Айгерим Сатыбалдиева',
            nameRu: 'Айгерим Сатыбалдиева',
            nameEn: 'Aigerim Satybaldieva',
            slug: 'mock-seller-3',
            isOwn: false,
          ),
          gifts: const [
            GiftModel(
              id: -31,
              name: 'Путешествие на двоих',
              photoUrl: null,
            ),
          ],
        ),
      ];

  static RaffleModel? raffleById(int id) {
    for (final r in raffles()) {
      if (r.id == id) return r;
    }
    return null;
  }

  static RaffleProductsResponse products({required String sort}) {
    final items = List<CategoryProductModel>.generate(
      8,
      (i) => CategoryProductModel(
        id: -1000 - i,
        name: 'Librederm Cerafavit',
        price: 15900,
        oldPrice: 19000,
        photoUrls: null,
        inStockCount: 5,
        descriptionKz:
            'Душқа арналған крем. Денеге жағуға арналған емдік крем.',
        descriptionRu:
            'Крем для душа. Лечебный крем для нанесения на тело.',
        descriptionEn:
            'Shower cream. Therapeutic cream for body application.',
        collections: const [],
        isInFavorite: false,
      ),
    );

    final sorted = [...items];
    switch (sort) {
      case 'cheap':
        sorted.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
        break;
      case 'expensive':
        sorted.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
        break;
      case 'discount':
        sorted.sort((a, b) {
          final da = (a.oldPrice ?? 0) - (a.price ?? 0);
          final db = (b.oldPrice ?? 0) - (b.price ?? 0);
          return db.compareTo(da);
        });
        break;
      case 'popular':
      default:
        break;
    }

    return RaffleProductsResponse(total: sorted.length, models: sorted);
  }
}
