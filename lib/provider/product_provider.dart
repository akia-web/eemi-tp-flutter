
import '../class/product.dart';
import 'model_provider.dart';

class ProductProvider extends ModelProvider {
  ProductProvider()
      : super(
    uri: 'products',
    fromJson: ProductModel.fromJson,
  );
}