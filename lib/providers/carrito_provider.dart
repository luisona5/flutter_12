import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../models/carrito_item.dart';
import '../services/carrito_service.dart';

class CarritoProvider with ChangeNotifier {
  final CarritoService _carritoService = CarritoService();
  bool _cargando = false;

  // Getters
  bool get cargando => _cargando;
  List<CarritoItem> get items => _carritoService.obtenerItems();
  int get cantidadTotal => _carritoService.obtenerCantidadTotal();
  bool get estaVacio => _carritoService.estaVacio();
  CarritoTotales get totales => _carritoService.calcularTotales();

  // ==================== OPERACIONES ====================

  /// Agregar producto al carrito
  Future<OperacionCarritoResultado> agregarProducto(
    Producto producto, {
    int cantidad = 1,
  }) async {
    _cargando = true;
    notifyListeners();

    final resultado = await _carritoService.agregarProducto(producto, cantidad);

    _cargando = false;
    notifyListeners();

    return resultado;
  }

  /// Eliminar producto del carrito
  Future<OperacionCarritoResultado> eliminarProducto(String productoId) async {
    _cargando = true;
    notifyListeners();

    final resultado = await _carritoService.eliminarProducto(productoId);

    _cargando = false;
    notifyListeners();

    return resultado;
  }

  /// Actualizar cantidad
  Future<OperacionCarritoResultado> actualizarCantidad(
    String productoId,
    int nuevaCantidad,
  ) async {
    _cargando = true;
    notifyListeners();

    final resultado = await _carritoService.actualizarCantidad(
      productoId,
      nuevaCantidad,
    );

    _cargando = false;
    notifyListeners();

    return resultado;
  }

  /// Incrementar cantidad en 1
  Future<OperacionCarritoResultado> incrementarCantidad(
      String productoId) async {
    final item = _carritoService.obtenerItem(productoId);
    if (item == null) {
      return OperacionCarritoResultado.error('Producto no encontrado');
    }
    return await actualizarCantidad(productoId, item.cantidad + 1);
  }

  /// Decrementar cantidad en 1
  Future<OperacionCarritoResultado> decrementarCantidad(
      String productoId) async {
    final item = _carritoService.obtenerItem(productoId);
    if (item == null) {
      return OperacionCarritoResultado.error('Producto no encontrado');
    }
    if (item.cantidad <= 1) {
      return OperacionCarritoResultado.error(
          'La cantidad no puede ser menor a 1');
    }
    return await actualizarCantidad(productoId, item.cantidad - 1);
  }

  /// Vaciar carrito
  Future<OperacionCarritoResultado> vaciarCarrito() async {
    _cargando = true;
    notifyListeners();

    final resultado = await _carritoService.vaciarCarrito();

    _cargando = false;
    notifyListeners();

    return resultado;
  }

  // ==================== MÉTODOS DE CONSULTA ====================

  /// Verificar si un producto está en el carrito
  bool contieneProducto(String productoId) {
    return _carritoService.contieneProducto(productoId);
  }

  /// Obtener cantidad de un producto específico
  int obtenerCantidadProducto(String productoId) {
    return _carritoService.obtenerCantidadProducto(productoId);
  }

  /// Obtener item específico
  CarritoItem? obtenerItem(String productoId) {
    return _carritoService.obtenerItem(productoId);
  }
}