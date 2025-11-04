import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir_riverpod/models/product.dart';
import 'package:kasir_riverpod/providers/cart_provider.dart';
import 'package:kasir_riverpod/providers/transaction_provider.dart';

void main() {
  group('Test Cart Provider', () {

    test('Cart harus kosong di awal', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final cart = container.read(cartProvider);
      expect(cart, isEmpty);
    });

    test('Tambah produk ke cart', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final product = Product(
        id: '1',
        name: 'Nasi Goreng',
        price: 15000,
        category: 'Makanan',
      );

      container.read(cartProvider.notifier).addProduct(product);

      final cart = container.read(cartProvider);
      expect(cart.length, 1);
      expect(cart[0].product.name, 'Nasi Goreng');
      expect(cart[0].quantity, 1);
    });

    test('Tambah produk yang sama akan menambah quantity', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final product = Product(
        id: '1',
        name: 'Nasi Goreng',
        price: 15000,
        category: 'Makanan',
      );

      container.read(cartProvider.notifier).addProduct(product);
      container.read(cartProvider.notifier).addProduct(product);

      final cart = container.read(cartProvider);
      expect(cart.length, 1);
      expect(cart[0].quantity, 2);
    });

    test('Tambah produk berbeda', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final product1 = Product(
        id: '1',
        name: 'Nasi Goreng',
        price: 15000,
        category: 'Makanan',
      );

      final product2 = Product(
        id: '2',
        name: 'Es Teh',
        price: 5000,
        category: 'Minuman',
      );

      container.read(cartProvider.notifier).addProduct(product1);
      container.read(cartProvider.notifier).addProduct(product2);

      final cart = container.read(cartProvider);
      expect(cart.length, 2);
    });

    test('Hapus produk dari cart', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final product = Product(
        id: '1',
        name: 'Nasi Goreng',
        price: 15000,
        category: 'Makanan',
      );

      container.read(cartProvider.notifier).addProduct(product);
      container.read(cartProvider.notifier).removeProduct('1');

      final cart = container.read(cartProvider);
      expect(cart, isEmpty);
    });

    test('Kurangi quantity produk', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final product = Product(
        id: '1',
        name: 'Nasi Goreng',
        price: 15000,
        category: 'Makanan',
      );

      container.read(cartProvider.notifier).addProduct(product);
      container.read(cartProvider.notifier).addProduct(product);
      container.read(cartProvider.notifier).decreaseQuantity('1');

      final cart = container.read(cartProvider);
      expect(cart.length, 1);
      expect(cart[0].quantity, 1);
    });

    test('Kurangi quantity menjadi nol akan menghapus item', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final product = Product(
        id: '1',
        name: 'Nasi Goreng',
        price: 15000,
        category: 'Makanan',
      );

      container.read(cartProvider.notifier).addProduct(product);
      container.read(cartProvider.notifier).decreaseQuantity('1');

      final cart = container.read(cartProvider);
      expect(cart, isEmpty);
    });

    test('Kosongkan keranjang', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final product1 = Product(
        id: '1',
        name: 'Nasi Goreng',
        price: 15000,
        category: 'Makanan',
      );

      final product2 = Product(
        id: '2',
        name: 'Es Teh',
        price: 5000,
        category: 'Minuman',
      );

      container.read(cartProvider.notifier).addProduct(product1);
      container.read(cartProvider.notifier).addProduct(product2);
      container.read(cartProvider.notifier).clear();

      final cart = container.read(cartProvider);
      expect(cart, isEmpty);
    });

    test('Hitung total harga dengan benar', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final product1 = Product(
        id: '1',
        name: 'Nasi Goreng',
        price: 15000,
        category: 'Makanan',
      );

      final product2 = Product(
        id: '2',
        name: 'Es Teh',
        price: 5000,
        category: 'Minuman',
      );

      container.read(cartProvider.notifier).addProduct(product1);
      container.read(cartProvider.notifier).addProduct(product1);
      container.read(cartProvider.notifier).addProduct(product2);

      final total = container.read(cartTotalProvider);
      expect(total, 35000); // (15000 * 2) + (5000 * 1)
    });

    test('Hitung jumlah item dengan benar', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final product1 = Product(
        id: '1',
        name: 'Nasi Goreng',
        price: 15000,
        category: 'Makanan',
      );

      final product2 = Product(
        id: '2',
        name: 'Es Teh',
        price: 5000,
        category: 'Minuman',
      );

      container.read(cartProvider.notifier).addProduct(product1);
      container.read(cartProvider.notifier).addProduct(product1);
      container.read(cartProvider.notifier).addProduct(product2);

      final count = container.read(cartItemCountProvider);
      expect(count, 3); // 2 + 1
    });

    test('Update quantity secara langsung', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final product = Product(
        id: '1',
        name: 'Nasi Goreng',
        price: 15000,
        category: 'Makanan',
      );

      container.read(cartProvider.notifier).addProduct(product);
      container.read(cartProvider.notifier).updateQuantity('1', 5);

      final cart = container.read(cartProvider);
      expect(cart[0].quantity, 5);
    });

    test('Update quantity menjadi nol akan menghapus item', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final product = Product(
        id: '1',
        name: 'Nasi Goreng',
        price: 15000,
        category: 'Makanan',
      );

      container.read(cartProvider.notifier).addProduct(product);
      container.read(cartProvider.notifier).updateQuantity('1', 0);

      final cart = container.read(cartProvider);
      expect(cart, isEmpty);
    });
  });

  group('Test Transaction Provider', () {

    test('Riwayat transaksi harus kosong di awal', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final transactions = container.read(transactionProvider);
      expect(transactions, isEmpty);
    });

    test('Tambah transaksi baru', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final product = Product(
        id: '1',
        name: 'Nasi Goreng',
        price: 15000,
        category: 'Makanan',
      );

      container.read(cartProvider.notifier).addProduct(product);
      final cart = container.read(cartProvider);

      container.read(transactionProvider.notifier).addTransaction(cart, 15000);

      final transactions = container.read(transactionProvider);
      expect(transactions.length, 1);
      expect(transactions[0].total, 15000);
    });

    test('Hitung total pendapatan dengan benar', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final product = Product(
        id: '1',
        name: 'Nasi Goreng',
        price: 15000,
        category: 'Makanan',
      );

      // Transaksi pertama
      container.read(cartProvider.notifier).addProduct(product);
      final cart1 = container.read(cartProvider);
      container.read(transactionProvider.notifier).addTransaction(cart1, 15000);

      container.read(cartProvider.notifier).clear();

      // Transaksi kedua
      container.read(cartProvider.notifier).addProduct(product);
      container.read(cartProvider.notifier).addProduct(product);
      final cart2 = container.read(cartProvider);
      container.read(transactionProvider.notifier).addTransaction(cart2, 30000);

      final revenue = container.read(totalRevenueProvider);
      expect(revenue, 45000); // 15000 + 30000
    });
  });
}