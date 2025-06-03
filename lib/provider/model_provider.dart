import '../class/product.dart';
import '../service/api_service.dart';

class DataList {
  final List rows;
  final int count;

  DataList({
    required this.rows,
    required this.count,
  });

  factory DataList.fromJson(Map<String, dynamic> json, Function(Map<String, dynamic>) itemParser) {
    return DataList(
      count: json['count'],
      rows: json['rows'].map((item) => itemParser(item)).toList(),
    );
  }
}

class ModelProvider {
  String uri;
  Function(Map<String, dynamic>) fromJson;

  ModelProvider({
    required this.uri,
    required this.fromJson,
  });

  Future getAll({Map<String, String>? queryParams}) {
    return ApiService.request(
      uri: uri,
      method: 'GET',
      queryParams: queryParams,
      parser: (res) => ProductModel.fromJson(res),
    );
  }

  Future addOrUpdate({
    required Map<String, dynamic> data,
    String? id,
  }) {
    return ApiService.request(
      uri: '$uri/${id ?? ''}',
      method: id != null ? 'PUT' : 'POST',
      data: data,
      parser: fromJson,
    );
  }

  Future delete(String id) {
    return ApiService.request(uri: '$uri/$id', method: 'DELETE');
  }

  Future get(String id) {
    return ApiService.request(uri: '$uri/$id', method: 'GET', parser: fromJson);
  }
}