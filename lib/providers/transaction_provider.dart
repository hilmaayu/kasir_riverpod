import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:kasir_riverpod/models/transaction.dart';
import 'package:kasir_riverpod/models/cart_item.dart';

// StateNotifier untuk mengelola riwayat transaksi
class TransactionNotifier extends StateNotifier<List<Transaction>> {
  TransactionNotifier() : super([]);

  // Tambah transaksi baru
  void addTransaction(List<CartItem> items, double total) {
    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      items: List.from(items), // Copy list agar immutable
      total: total,
    );

    // Tambahkan transaksi baru di awal list
    state = [transaction, ...state];
  }

  // Hapus transaksi berdasarkan ID
  void removeTransaction(String id) {
    state = state.where((transaction) => transaction.id != id).toList();
  }

  // Hapus semua transaksi
  void clearAll() {
    state = [];
  }
}

// StateNotifierProvider untuk transaksi
final transactionProvider = StateNotifierProvider<TransactionNotifier, List<Transaction>>((ref) {
  return TransactionNotifier();
});

// Provider untuk total pendapatan
final totalRevenueProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionProvider);
  return transactions.fold(0.0, (sum, transaction) => sum + transaction.total);
});

// Provider untuk format total pendapatan
final formattedTotalRevenueProvider = Provider<String>((ref) {
  final total = ref.watch(totalRevenueProvider);
  return 'Rp ${total.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]}.',
  )}';
});

// Provider untuk jumlah transaksi
final transactionCountProvider = Provider<int>((ref) {
  final transactions = ref.watch(transactionProvider);
  return transactions.length;
});