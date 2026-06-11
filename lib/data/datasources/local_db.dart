import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDB {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    // Menentukan path penyimpanan database
    String path = join(await getDatabasesPath(), 'duck_farm.db');
    
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Recreate Bebek and StokPakan with new schema
      await db.execute('DROP TABLE IF EXISTS Bebek');
      await db.execute('DROP TABLE IF EXISTS StokPakan');

      await db.execute('''
        CREATE TABLE Bebek(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          kandang_id INTEGER,
          jenis_mutasi TEXT, -- 'Masuk', 'Keluar', 'Mati'
          jumlah_bebek INTEGER,
          tanggal_input TEXT,
          keterangan TEXT,
          FOREIGN KEY (kandang_id) REFERENCES Kandang (id) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE StokPakan(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          tanggal TEXT,
          jenis_mutasi TEXT, -- 'Masuk', 'Keluar'
          jumlah INTEGER,
          keterangan TEXT
        )
      ''');
    }
  }

  static Future _onCreate(Database db, int version) async {
    // 1. Tabel User
    await db.execute('''
      CREATE TABLE User(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        username TEXT UNIQUE,
        email TEXT UNIQUE,
        password_hash TEXT,
        role TEXT
      )
    ''');

    // 2. Tabel Kandang
    await db.execute('''
      CREATE TABLE Kandang(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_kandang TEXT,
        lokasi_lat TEXT,
        lokasi_lng TEXT,
        kapasitas INTEGER
      )
    ''');

    // 3. Tabel Bebek (Skema Baru)
    await db.execute('''
      CREATE TABLE Bebek(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kandang_id INTEGER,
        jenis_mutasi TEXT,
        jumlah_bebek INTEGER,
        tanggal_input TEXT,
        keterangan TEXT,
        FOREIGN KEY (kandang_id) REFERENCES Kandang (id) ON DELETE CASCADE
      )
    ''');

    // 4. Tabel ProduksiTelur
    await db.execute('''
      CREATE TABLE ProduksiTelur(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kandang_id INTEGER,
        tanggal TEXT,
        jumlah_telur INTEGER,
        FOREIGN KEY (kandang_id) REFERENCES Kandang (id) ON DELETE CASCADE
      )
    ''');

    // 5. Tabel StokPakan (Skema Baru)
    await db.execute('''
      CREATE TABLE StokPakan(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tanggal TEXT,
        jenis_mutasi TEXT,
        jumlah INTEGER,
        keterangan TEXT
      )
    ''');

    // 6. Tabel Produk (Master Data Stok)
    await db.execute('''
      CREATE TABLE Produk(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_produk TEXT UNIQUE,
        stok INTEGER DEFAULT 0
      )
    ''');

    // 7. Tabel RiwayatTransaksi (Ledger Keluar-Masuk Produk)
    await db.execute('''
      CREATE TABLE RiwayatTransaksi(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        produk_id INTEGER,
        tanggal TEXT,
        jenis_transaksi TEXT,
        jumlah_perubahan INTEGER,
        keterangan TEXT,
        FOREIGN KEY (produk_id) REFERENCES Produk (id) ON DELETE CASCADE
      )
    ''');

    // ----------------------------------------------------
    // SEEDING DATA AWAL (Contoh)
    // ----------------------------------------------------
    
    // Seed Produk Master
    await db.insert('Produk', {'nama_produk': 'Telur Bebek Mentah', 'stok': 0});
    await db.insert('Produk', {'nama_produk': 'Telur Asin', 'stok': 0});
    await db.insert('Produk', {'nama_produk': 'Kerupuk Telur Asin', 'stok': 0});

    // Seed Admin User (password: admin, hash placeholder)
    // Sebaiknya hash di-generate dari controller saat aplikasi jalan
    await db.insert('User', {
      'nama': 'Administrator',
      'username': 'admin',
      'email': 'admin@duckfarm.com',
      'password_hash': '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', // SHA-256 for 'admin'
      'role': 'Admin'
    });
  }
}
