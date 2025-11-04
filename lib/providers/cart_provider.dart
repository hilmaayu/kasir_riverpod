import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:kasir_riverpod/models/cart_item.dart';
import 'package:kasir_riverpod/models/product.dart';

// StateNotifier untuk mengelola state keranjang
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  // Tambah produk ke keranjang
  void addProduct(Product product) {
    final existingIndex = state.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // Jika produk sudah ada, tambah quantity
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex)
            CartItem(
              product: state[i].product,
              quantity: state[i].quantity + 1,
            )
          else
            state[i]
      ];
    } else {
      // Jika produk baru, tambahkan ke list
      state = [...state, CartItem(product: product, quantity: 1)];
    }
  }

  // Kurangi quantity produk
  void decreaseQuantity(String productId) {
    final existingIndex = state.indexWhere(
          (item) => item.product.id == productId,
    );

    if (existingIndex >= 0) {
      final currentQuantity = state[existingIndex].quantity;

      if (currentQuantity > 1) {
        // Kurangi quantity
        state = [
          for (int i = 0; i < state.length; i++)
            if (i == existingIndex)
              CartItem(
                product: state[i].product,
                quantity: state[i].quantity - 1,
              )
            else
              state[i]
        ];
      } else {
        // Hapus dari keranjang jika quantity = 1
        removeProduct(productId);
      }
    }
  }

  // Hapus produk dari keranjang
  void removeProduct(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  // Kosongkan keranjang
  void clear() {
    state = [];
  }

  // Update quantity langsung
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeProduct(productId);
      return;
    }

    final existingIndex = state.indexWhere(
          (item) => item.product.id == productId,
    );

    if (existingIndex >= 0) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex)
            CartItem(
              product: state[i].product,
              quantity: quantity,
            )
          else
            state[i]
      ];
    }
  }
}

// StateNotifierProvider untuk cart
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

// Provider untuk menghitung total harga
final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0.0, (sum, item) => sum + item.total);
});

// Provider untuk menghitung jumlah item
final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.quantity);
});

// Provider untuk format total harga
final formattedCartTotalProvider = Provider<String>((ref) {
  final total = ref.watch(cartTotalProvider);
  return 'Rp ${total.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
  )}';
});