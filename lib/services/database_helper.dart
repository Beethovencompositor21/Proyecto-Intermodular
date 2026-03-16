import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/usuario.dart';

class AyudanteBaseDatos {
  static final AyudanteBaseDatos instancia = AyudanteBaseDatos._inicializar();
  static Database? _baseDeDatos;

  AyudanteBaseDatos._inicializar();

  Future<Database> get baseDeDatos async {
    if (_baseDeDatos != null) return _baseDeDatos!;
    _baseDeDatos = await _inicializarBD('extrefit.db');
    return _baseDeDatos!;
  }

  Future<Database> _inicializarBD(String nombreArchivo) async {
    final rutaBD = await getDatabasesPath();
    final ruta = join(rutaBD, nombreArchivo);

    return await openDatabase(
      ruta,
      version: 1,
      onCreate: _crearBD,
    );
  }

  Future _crearBD(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre_usuario TEXT NOT NULL,
        correo TEXT NOT NULL,
        contrasena TEXT NOT NULL
      )
    ''');
  }

  Future<int> crearUsuario(Usuario usuario) async {
    final db = await instancia.baseDeDatos;
    return await db.insert('usuarios', usuario.aMapa());
  }

  Future<Usuario?> obtenerUsuario(String correo, String contrasena) async {
    final db = await instancia.baseDeDatos;
    final mapas = await db.query(
      'usuarios',
      where: 'correo = ? AND contrasena = ?',
      whereArgs: [correo, contrasena],
    );

    if (mapas.isNotEmpty) {
      return Usuario.desdeMapa(mapas.first);
    }
    return null;
  }
}
