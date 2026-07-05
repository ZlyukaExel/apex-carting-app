import 'package:flutter/material.dart';

import 'app.dart';
import 'core/network/api_client.dart';

void main() {
  runApp(App(apiClient: ApiClient()));
}
