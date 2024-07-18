
import 'package:flutter/cupertino.dart';

import 'api.dart';

class Repo {
  final _req = ApiCaller();

  Future<List<dynamic>> getAllProducts() async {
   var response = await _req.get("products",);
   return response;
  }
}
