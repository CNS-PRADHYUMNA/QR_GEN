// qr_code_provider.dart
import 'package:riverpod/riverpod.dart';

final paymentAddressTypeProvider = StateProvider<String>((ref) => '');
final merchantNameProvider = StateProvider<String>((ref) => '');
final upiIdProvider = StateProvider<String>((ref) => '');
final transactionAmountProvider = StateProvider<String>((ref) => '');
final descriptionProvider = StateProvider<String>((ref) => '');

final upiStringProvider = Provider<String>((ref) {
  final paymentAddressType = ref.watch(paymentAddressTypeProvider);
  final merchantName = ref.watch(merchantNameProvider);
  final upiId = ref.watch(upiIdProvider);
  final transactionAmount = ref.watch(transactionAmountProvider);
  final description = ref.watch(descriptionProvider);

  final paymentAddress = paymentAddressType == 'UPI Address' ? upiId : '';
  final amount = transactionAmount.isNotEmpty ? '&am=$transactionAmount' : '';
  final note = description.isNotEmpty ? '&pn=$description' : '';
  final upiValue = '$merchantName@$paymentAddress$amount$note';

  return upiValue;
});
