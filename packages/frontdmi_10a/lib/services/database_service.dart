import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/paquete_model.dart';

// Servicio de base de datos local SQLite - JaimeCAST69
// Proporciona cache local y sincronización offline
class DatabaseService {
  static Database? _database;
  static const String _dbName = 'paqueteria.db';
  static const String _tablePaquetes = 'paquetes';

  // Obtener instancia de base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializar base de datos
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Crear tablas
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tablePaquetes (
        id TEXT PRIMARY KEY,
        destinatario TEXT NOT NULL,
        direccion TEXT NOT NULL,
        peso REAL NOT NULL,
        estado TEXT NOT NULL,
        fotoUrl TEXT,
        fechaCreacion INTEGER NOT NULL,
        repartidorId TEXT,
        clienteId TEXT NOT NULL,
        codigoQR TEXT,
        sincronizado INTEGER DEFAULT 0
      )
    ''');
  }

  // Insertar paquete local
  Future<void> insertPaquete(
    Paquete paquete, {
    bool sincronizado = false,
  }) async {
    final db = await database;
    await db.insert(_tablePaquetes, {
      ...paquete.toJson(),
      'fechaCreacion': paquete.fechaCreacion.millisecondsSinceEpoch,
      'sincronizado': sincronizado ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Actualizar paquete local
  Future<void> updatePaquete(
    Paquete paquete, {
    bool sincronizado = false,
  }) async {
    final db = await database;
    await db.update(
      _tablePaquetes,
      {
        ...paquete.toJson(),
        'fechaCreacion': paquete.fechaCreacion.millisecondsSinceEpoch,
        'sincronizado': sincronizado ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [paquete.id],
    );
  }

  // Eliminar paquete local
  Future<void> deletePaquete(String id) async {
    final db = await database;
    await db.delete(_tablePaquetes, where: 'id = ?', whereArgs: [id]);
  }

  // Obtener todos los paquetes locales
  Future<List<Paquete>> getAllPaquetes() async {
    final db = await database;
    final maps = await db.query(_tablePaquetes, orderBy: 'fechaCreacion DESC');

    return maps.map((map) {
      final json = Map<String, dynamic>.from(map);
      json['fechaCreacion'] = DateTime.fromMillisecondsSinceEpoch(
        map['fechaCreacion'] as int,
      );
      json.remove('sincronizado');
      return Paquete.fromJson(json);
    }).toList();
  }

  // Obtener paquetes por cliente
  Future<List<Paquete>> getPaquetesPorCliente(String clienteId) async {
    final db = await database;
    final maps = await db.query(
      _tablePaquetes,
      where: 'clienteId = ?',
      whereArgs: [clienteId],
      orderBy: 'fechaCreacion DESC',
    );

    return maps.map((map) {
      final json = Map<String, dynamic>.from(map);
      json['fechaCreacion'] = DateTime.fromMillisecondsSinceEpoch(
        map['fechaCreacion'] as int,
      );
      json.remove('sincronizado');
      return Paquete.fromJson(json);
    }).toList();
  }

  // Obtener paquetes no sincronizados
  Future<List<Paquete>> getPaquetesNoSincronizados() async {
    final db = await database;
    final maps = await db.query(
      _tablePaquetes,
      where: 'sincronizado = ?',
      whereArgs: [0],
    );

    return maps.map((map) {
      final json = Map<String, dynamic>.from(map);
      json['fechaCreacion'] = DateTime.fromMillisecondsSinceEpoch(
        map['fechaCreacion'] as int,
      );
      json.remove('sincronizado');
      return Paquete.fromJson(json);
    }).toList();
  }

  // Marcar paquete como sincronizado
  Future<void> marcarComoSincronizado(String id) async {
    final db = await database;
    await db.update(
      _tablePaquetes,
      {'sincronizado': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Limpiar todos los paquetes
  Future<void> limpiarPaquetes() async {
    final db = await database;
    await db.delete(_tablePaquetes);
  }

  // Cerrar base de datos
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
