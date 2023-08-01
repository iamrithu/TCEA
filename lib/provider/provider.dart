import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDetails = StateProvider<Map<String, dynamic>>((state) {
  return {};
});
final supplierList = StateProvider<List<dynamic>>((state) {
  return [];
});
final categoryList = StateProvider<List<dynamic>>((state) {
  return [];
});
final userRole = StateProvider<String>((state) {
  return "";
});
