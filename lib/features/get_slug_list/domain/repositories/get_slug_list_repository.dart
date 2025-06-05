import 'package:bai_market/features/get_slug_list/data/models/slug_model.dart';

abstract class GetSlugListRepository {
  Future<List<SlugModel>> getSlugs();
}
