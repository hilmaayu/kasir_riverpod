import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir_riverpod/models/product.dart';

// Provider untuk daftar produk
// Menggunakan Provider karena data tidak berubah (immutable)
final productsProvider = Provider<List<Product>>((ref) {
  return [
    // Makanan
    Product(
      id: '1',
      name: 'Nasi Goreng',
      price: 15000,
      category: 'Makanan',
    ),
    Product(
      id: '2',
      name: 'Mie Goreng',
      price: 12000,
      category: 'Makanan',
    ),
    Product(
      id: '3',
      name: 'Ayam Goreng',
      price: 20000,
      category: 'Makanan',
    ),
    Product(
      id: '4',
      name: 'Sate Ayam',
      price: 18000,
      category: 'Makanan',
    ),
    Product(
      id: '5',
      name: 'Nasi Uduk',
      price: 13000,
      category: 'Makanan',
    ),
    // Minuman
    Product(
      id: '6',
      name: 'Es Teh',
      price: 5000,
      category: 'Minuman',
    ),
    Product(
      id: '7',
      name: 'Jus Jeruk',
      price: 8000,
      category: 'Minuman',
    ),
    Product(
      id: '8',
      name: 'Es Campur',
      price: 10000,
      category: 'Minuman',
    ),
    Product(
      id: '9',
      name: 'Kopi',
      price: 7000,
      category: 'Minuman',
    ),
    Product(
      id: '10',
      name: 'Teh Tarik',
      price: 6000,
      category: 'Minuman',
    ),
  ];
});

// Provider untuk filter produk berdasarkan kategori
final filteredProductsProvider = Provider.family<List<Product>, String?>((ref, category) {
  final products = ref.watch(productsProvider);

  if (category == null || category == 'Semua') {
    return products;
  }

  return products.where((product) => product.category == category).toList();
});

// Provider untuk daftar kategori
final categoriesProvider = Provider<List<String>>((ref) {
  final products = ref.watch(productsProvider);
  final categories = products.map((p) => p.category).toSet().toList();
  return ['Semua', ...categories];
});