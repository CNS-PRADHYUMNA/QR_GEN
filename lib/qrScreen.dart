// qr_code_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'qr_pod.dart';

class QRCodeScreen extends StatelessWidget {
  const QRCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPI QR Code Generator'),
      ),
      body: const QRCodeBody(),
    );
  }
}

class QRCodeBody extends ConsumerWidget {
  const QRCodeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upiString = ref.watch(upiStringProvider);
    final paymentAddressType = ref.watch(paymentAddressTypeProvider);
    final merchantName = ref.watch(merchantNameProvider);
    final upiId = ref.watch(upiIdProvider);
    final transactionAmount = ref.watch(transactionAmountProvider);
    final description = ref.watch(descriptionProvider);

    print('upiString: $upiString');

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                ref.read(merchantNameProvider.notifier).state = value;
              },
              decoration: const InputDecoration(
                labelText: 'Merchant / Payee Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: paymentAddressType,
              onChanged: (value) {
                ref.read(paymentAddressTypeProvider.notifier).state =
                    value ?? '';
              },
              items: const [
                DropdownMenuItem(
                  value: '',
                  child: Text('Select payment address type...'),
                ),
                DropdownMenuItem(
                  value: 'UPI Address',
                  child: Text('UPI Address'),
                ),
                DropdownMenuItem(
                  value: 'Bank Account Number',
                  child: Text('Bank Account Number'),
                ),
                DropdownMenuItem(
                  value: 'Aadhaar Number',
                  child: Text('Aadhaar Number'),
                ),
                DropdownMenuItem(
                  value: 'Mobile Number',
                  child: Text('Mobile Number'),
                ),
              ],
              decoration: const InputDecoration(
                labelText: 'Payment Address Type',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            if (paymentAddressType == 'UPI Address')
              TextField(
                onChanged: (value) {
                  ref.read(upiIdProvider.notifier).state = value;
                },
                decoration: const InputDecoration(
                  labelText: 'UPI ID',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                ref.read(transactionAmountProvider.notifier).state = value;
              },
              decoration: const InputDecoration(
                labelText: 'Transaction Amount',
                prefixText: '₹ 🇮🇳 ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                ref.read(descriptionProvider.notifier).state = value;
              },
              decoration: const InputDecoration(
                labelText: 'Description (Notes)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            if (upiString.isNotEmpty)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: QrImageView(
                    data: upiString,
                    version: QrVersions.auto,
                    size: 200.0,
                    foregroundColor: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
            const SizedBox(height: 16.0),
            if (upiString.isNotEmpty)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 90, 105, 236),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'MERCHANT NAME\n$merchantName\n\n$upiId\n\nScan and pay with any BHIM UPI app',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
