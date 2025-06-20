// lib/frontend/screens/checkout_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Выбранный метод оплаты
  String _paymentMethod = 'card';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Delivery Address
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.deliveryAddress,
                  style: Theme.of(context).textTheme.titleMedium),
              TextButton(
                onPressed: () {/* TODO: change address */},
                child: Text(l10n.change,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Home – 925 S Chugach St #APT 10, Alaska 99645',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Payment Method
          Text(l10n.paymentMethod,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPaymentOption(
                  context, 'card', Icons.credit_card_outlined, l10n.card),
              _buildPaymentOption(
                  context, 'cash', Icons.money_outlined, l10n.cash),
              _buildPaymentOption(
                  context, 'apple', Icons.apple, l10n.applePay),
            ],
          ),
          const SizedBox(height: 12),
          // Детали карты (показываем, если выбран card)
          if (_paymentMethod == 'card')
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('VISA **** **** **** 2512',
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {/* TODO: edit card */},
                  )
                ],
              ),
            ),

          // Order Summary
          Text(l10n.orderSummary,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _buildSummaryRow(l10n.subtotal, '\$39.49'),
          const SizedBox(height: 4),
          _buildSummaryRow(l10n.vat, '\$0.00'),
          const SizedBox(height: 4),
          _buildSummaryRow(l10n.shippingFee, '\$7.99'),
          const Divider(height: 32),

          // Promo code
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: l10n.promoCodeHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {/* TODO: apply promo */},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(l10n.addPromoCode),
              ),
            ],
          ),

          const SizedBox(height: 32),
          // Place Order
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: place order
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                l10n.placeOrderButton,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Пункт выбора метода оплаты
  Widget _buildPaymentOption(BuildContext ctx, String value, IconData icon,
      String label) {
    final selected = _paymentMethod == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _paymentMethod = value),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: selected
                ? Colors.grey.shade200
                : Theme.of(ctx).cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: selected
                    ? Colors.black
                    : Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 20,
                  color:
                  selected ? Colors.black : Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(label,
                  style: TextStyle(
                      color: selected
                          ? Colors.black
                          : Colors.grey.shade600)),
            ],
          ),
        ),
      ),
    );
  }

  // Строка в Order Summary
  Widget _buildSummaryRow(String title, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        Text(amount,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
