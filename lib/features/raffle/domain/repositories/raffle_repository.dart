import '../../data/models/raffle_model.dart';
import '../../data/models/raffle_products_response.dart';

abstract class RaffleRepository {
  Future<List<RaffleModel>> getRaffles();
  Future<RaffleModel?> getRaffleById(int id);
  Future<RaffleProductsResponse?> getRaffleProducts({
    required int id,
    required String sort,
  });
}
