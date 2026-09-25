import 'mock_data.dart';
import 'models/category.dart';
import 'models/offer.dart';
import 'models/product.dart';

/// مصدر بيانات الصفحة الرئيسية.
/// حاليًا يعتمد على بيانات تجريبية محلية،
/// ومستقبلًا يُستبدل بتنفيذ متصل بـ Backend بدون تغيير أي واجهة.
abstract class HomeRepository {
  List<Category> getCategories();
  List<Product> getProducts();
  List<Offer> getOffers();
}

class MockHomeRepository implements HomeRepository {
  @override
  List<Category> getCategories() => MockData.categories;

  @override
  List<Product> getProducts() => MockData.products;

  @override
  List<Offer> getOffers() => MockData.offers;
}