import 'package:intl/intl.dart';
import 'cart_item.dart';

class Transaction {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final double total;

  Transaction({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
  });

  // Format tanggal
  String get formattedDate {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  // Format total ke Rupiah
  String get formattedTotal {
    return 'Rp ${total.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    )}';
  }

  // Total item dalam transaksi
  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}