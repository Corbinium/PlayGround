import 'package:flutter_application_1/icekat/sample_model.dart';
import 'package:riverpod/riverpod.dart';

final SampleProvider = FutureProvider.autoDispose.family<SampleModel, SampleModel>((ref, s) {

});