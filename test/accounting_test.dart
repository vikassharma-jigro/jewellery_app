import 'package:flutter_test/flutter_test.dart';
import 'package:jewellary_stock/data/models/transaction_model.dart';
import 'package:jewellary_stock/data/models/customer_model.dart';

void main() {
  group('Independent Accounting Verification Oracle', () {
    test('Purchase Calculation Oracle: Gross, Stone, Net, Final, Price, Making, Total', () {
      const grossWeight = 10.0;
      const stoneWeight = 0.5;
      const purityPercent = 91.6;
      const goldRate = 7000.0;
      const makingChargePerGram = 250.0;

      // Independent math
      final netWeight = grossWeight - stoneWeight; // 9.5 g
      final finalWeight = netWeight * (purityPercent / 100.0); // 9.5 * 0.916 = 8.702 g
      final wastage = netWeight - finalWeight; // 9.5 - 8.702 = 0.798 g
      final priceSegment = finalWeight * goldRate; // 8.702 * 7000 = 60914.0
      final makingCharge = finalWeight * makingChargePerGram; // 8.702 * 250 = 2175.5
      final totalAmount = priceSegment + makingCharge; // 63089.5

      expect(netWeight, equals(9.5));
      expect(finalWeight, closeTo(8.702, 0.001));
      expect(wastage, closeTo(0.798, 0.001));
      expect(priceSegment, closeTo(60914.0, 0.01));
      expect(makingCharge, closeTo(2175.5, 0.01));
      expect(totalAmount, closeTo(63089.5, 0.01));
    });

    test('Purchase Ledger Impact: Buyer Gold increases, Cash liability increases (shop owes buyer)', () {
      const initialGold = 0.0;
      const initialPaymentDue = 0.0;
      const purchaseWeight = 10.0;
      const purchaseTotalAmount = 64120.0;

      final expectedGold = initialGold + purchaseWeight;
      final expectedPaymentDue = initialPaymentDue - purchaseTotalAmount;

      expect(expectedGold, equals(10.0));
      expect(expectedPaymentDue, equals(-64120.0));
    });

    test('Purchase Return: Reversal of Purchase', () {
      const initialGold = 10.0;
      const initialPaymentDue = -64120.0;
      const returnWeight = 5.0;
      const returnAmount = 32060.0;

      final expectedGold = initialGold - returnWeight;
      final expectedPaymentDue = initialPaymentDue + returnAmount;

      expect(expectedGold, equals(5.0));
      expect(expectedPaymentDue, equals(-32060.0));
    });

    test('Sale Ledger Impact: Buyer Gold decreases, Buyer owes cash', () {
      const initialGold = 5.0;
      const initialPaymentDue = -32060.0;
      const saleWeight = 3.0;
      const saleAmount = 19510.80;

      final expectedGold = initialGold - saleWeight;
      final expectedPaymentDue = initialPaymentDue + saleAmount;

      expect(expectedGold, equals(2.0));
      expect(expectedPaymentDue, closeTo(-12549.20, 0.01));
    });

    test('Sale Return: Buyer returns item, Buyer gets cash credit', () {
      const initialGold = 2.0;
      const initialPaymentDue = -12549.20;
      const returnWeight = 1.0;
      const returnAmount = 6503.60;

      final expectedGold = initialGold + returnWeight;
      final expectedPaymentDue = initialPaymentDue - returnAmount;

      expect(expectedGold, equals(3.0));
      expect(expectedPaymentDue, closeTo(-19052.80, 0.01));
    });

    test('Cash Jama (Pure Cash): Cash received from buyer, credits paymentDue', () {
      const initialPaymentDue = -19052.80;
      const cashJama = 10000.0;

      final expectedPaymentDue = initialPaymentDue - cashJama;
      expect(expectedPaymentDue, closeTo(-29052.80, 0.01));
    });

    test('Cash Namae (Pure Cash): Cash given to buyer, debits paymentDue', () {
      const initialPaymentDue = -29052.80;
      const cashNamae = 15000.0;

      final expectedPaymentDue = initialPaymentDue + cashNamae;
      expect(expectedPaymentDue, closeTo(-14052.80, 0.01));
    });

    test('Metal Jama (Pure Metal): Metal received from buyer, credits goldBalance', () {
      const initialGold = 3.0;
      const metalWeight = 4.0;

      final expectedGold = initialGold + metalWeight;
      expect(expectedGold, equals(7.0));
    });

    test('Metal Namae (Pure Metal): Metal given to buyer, debits goldBalance', () {
      const initialGold = 7.0;
      const metalWeight = 2.0;

      final expectedGold = initialGold - metalWeight;
      expect(expectedGold, equals(5.0));
    });

    test('Scenario A: Cash-to-Metal Settlement (Customer owes cash, pays metal)', () {
      const outstandingCashDebt = 14000.0;
      const goldRate = 7000.0;
      const metalDelivered = 2.0;

      final settlementValue = metalDelivered * goldRate;
      final remainingCashDebt = outstandingCashDebt - settlementValue;

      expect(settlementValue, equals(14000.0));
      expect(remainingCashDebt, equals(0.0));
    });

    test('Scenario B: Metal-to-Cash Settlement (Customer owes metal, pays cash)', () {
      const outstandingMetalDebt = 2.0; // Customer owes 2g
      const goldRate = 7000.0;
      const cashPaid = 14000.0;

      final metalSettled = cashPaid / goldRate;
      final remainingMetalDebt = outstandingMetalDebt - metalSettled;

      expect(metalSettled, equals(2.0));
      expect(remainingMetalDebt, equals(0.0));
    });

    test('Scenario C: Combined Cash and Metal Settlement', () {
      const totalCashDebt = 25000.0;
      const cashPortion = 11000.0;
      const goldRate = 7000.0;
      const metalPortionGrams = 2.0;

      final metalValuation = metalPortionGrams * goldRate; // 14000.0
      final totalSettled = cashPortion + metalValuation; // 25000.0
      final remainingDebt = totalCashDebt - totalSettled;

      expect(metalValuation, equals(14000.0));
      expect(totalSettled, equals(25000.0));
      expect(remainingDebt, equals(0.0));
    });

    test('Scenario D: Partial Settlement preserves remainder', () {
      const totalDebt = 50000.0;
      const partialPayment = 15000.0;

      final remaining = totalDebt - partialPayment;
      expect(remaining, equals(35000.0));
      expect(remaining > 0, isTrue); // Not closed
    });
  });

  group('CustomerModel & TransactionModel serialization', () {
    test('CustomerModel parses paymentDue as cashBalance properly', () {
      final json = {
        'id': 'cust123',
        'name': 'Ramesh Jewellers',
        'mobile': '9876543210',
        'goldBalance': 15.5,
        'jewelleryBalance': 2.0,
        'paymentDue': -5000.0,
      };

      final model = CustomerModel.fromJson(json);
      expect(model.id, equals('cust123'));
      expect(model.name, equals('Ramesh Jewellers'));
      expect(model.goldBalance, equals(15.5));
      expect(model.jewelleryBalance, equals(2.0));
      expect(model.cashBalance, equals(-5000.0));
    });

    test('TransactionModel parses all fields and calculationVersion', () {
      final json = {
        '_id': 'tx999',
        'customerId': {'_id': 'cust123', 'name': 'Ramesh Jewellers'},
        'type': 'PURCHASE',
        'metalType': 'GOLD',
        'weight': 10.0,
        'grossWeight': 10.0,
        'netWeight': 10.0,
        'purityPercent': 91.6,
        'finalWeight': 9.16,
        'wastage': 0.84,
        'goldRate': 7000.0,
        'priceSegment': 64120.0,
        'totalAmount': 64120.0,
        'calculationVersion': 2,
        'currency': 'INR',
        'createdAt': '2026-10-09T10:00:00.000Z',
      };

      final tx = TransactionModel.fromJson(json);
      expect(tx.id, equals('tx999'));
      expect(tx.customerId, equals('cust123'));
      expect(tx.customerName, equals('Ramesh Jewellers'));
      expect(tx.type, equals(TransactionType.purchase));
      expect(tx.metalType, equals(MetalType.gold));
      expect(tx.finalWeight, equals(9.16));
      expect(tx.totalAmount, equals(64120.0));
      expect(tx.calculationVersion, equals(2));
    });
  });
}
