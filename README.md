# Aplikasi Kasir Sederhana - Riverpod

Aplikasi kasir sederhana menggunakan Flutter dengan state management **Riverpod**.

## Fitur Aplikasi

✅ **Daftar Produk** - Menampilkan produk makanan dan minuman  
✅ **Filter Kategori** - Filter produk berdasarkan kategori  
✅ **Keranjang Belanja** - Tambah, kurangi, dan hapus produk  
✅ **Hitung Total Otomatis** - Total harga dihitung secara real-time  
✅ **Checkout** - Proses pembayaran dan simpan transaksi  
✅ **Riwayat Transaksi** - Lihat semua transaksi yang sudah dilakukan  
✅ **Detail Transaksi** - Lihat detail item per transaksi

## State Management dengan Riverpod

### Provider yang Digunakan:

1. **Provider** - Untuk data yang tidak berubah (daftar produk)
2. **StateNotifierProvider** - Untuk state kompleks (cart, transaksi)
3. **StateProvider** - Untuk state sederhana (filter kategori)
4. **Computed Provider** - Untuk perhitungan otomatis (total harga)

### Keuntungan Riverpod:

- ✅ **Type Safe** - Error detection saat kompilasi
- ✅ **Tidak perlu BuildContext** - Akses state dari mana saja
- ✅ **Mudah di-test** - Provider dapat di-override
- ✅ **Auto-dispose** - Memory efficient
- ✅ **Reactive** - UI update otomatis saat state berubah

## Struktur Project

```
lib/
├── main.dart
├── models/
│   ├── product.dart
│   ├── cart_item.dart
│   └── transaction.dart
├── providers/
│   ├── products_provider.dart
│   ├── cart_provider.dart
│   └── transaction_provider.dart
└── screens/
    ├── home_screen.dart
    ├── cart_screen.dart
    └── transaction_history_screen.dart
```

## Cara Install

### 1. Clone atau Extract Project

```bash
cd kasir_riverpod
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run Aplikasi

```bash
flutter run
```

## Cara Menggunakan Aplikasi

### 1. Tambah Produk ke Keranjang
- Pilih produk di halaman utama
- Klik tombol "Tambah" atau tap pada card produk
- Produk akan ditambahkan ke keranjang

### 2. Lihat Keranjang
- Klik icon keranjang di app bar
- Badge menunjukkan jumlah item
- Anda bisa menambah/mengurangi quantity atau hapus item

### 3. Checkout
- Di halaman keranjang, klik tombol "CHECKOUT"
- Transaksi akan disimpan di riwayat
- Keranjang akan dikosongkan otomatis

### 4. Lihat Riwayat Transaksi
- Klik icon history di app bar
- Lihat summary total transaksi dan pendapatan
- Tap pada transaksi untuk melihat detail
- Hapus transaksi jika diperlukan

## Konsep Riverpod yang Diimplementasikan

### 1. Provider (Immutable Data)
```dart
final productsProvider = Provider<List<Product>>((ref) {
  return [/* daftar produk */];
});
```

### 2. StateNotifierProvider (Complex State)
```dart
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);
  
  void addProduct(Product product) {
    // Logic untuk update state
    state = [...state, newItem];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier()
);
```

### 3. Computed Provider (Derived State)
```dart
final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0.0, (sum, item) => sum + item.total);
});
```

### 4. ConsumerWidget (Membaca State)
```dart
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    // ...
  }
}
```

### 5. Mengubah State
```dart
// Membaca value
ref.read(cartProvider.notifier).addProduct(product);

// Watching untuk reactive updates
final cart = ref.watch(cartProvider);
```

## Dependencies

- **flutter_riverpod**: ^3.0.3 - State management
- **intl**: ^0.20.2 - Format tanggal dan angka

## Kesimpulan

Aplikasi ini mengimplementasikan state management menggunakan **Riverpod** pada kasus nyata aplikasi transaksional. Riverpod memberikan solusi yang:
- 🔒 Type-safe
- ⚡ Performant
- 🧪 Testable
- 📦 Scalable
- 🎯 Production-ready

---

**Dibuat untuk tugas State Management Flutter**  
**Framework:** Flutter  
**State Management:** Riverpod (flutter_riverpod)  
**Pattern:** Provider + StateNotifier