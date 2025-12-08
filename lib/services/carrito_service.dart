import 'dart:math';
import '../models/producto.dart';
import '../models/carrito_item.dart';

// Clase para resultados de operaciones
class OperacionCarritoResultado {
  final bool exitoso;
  final String? mensaje;
  final dynamic datos;

  OperacionCarritoResultado({
    required this.exitoso,
    this.mensaje,
    this.datos,
  });

  factory OperacionCarritoResultado.exito({String? mensaje, dynamic datos}) {
    return OperacionCarritoResultado(
      exitoso: true,
      mensaje: mensaje,
      datos: datos,
    );
  }

  factory OperacionCarritoResultado.error(String mensaje) {
    return OperacionCarritoResultado(
      exitoso: false,
      mensaje: mensaje,
    );
  }
}

// Servicio Mock del Carrito
class CarritoService {
  // Simulación de base de datos en memoria
  final Map<String, CarritoItem> _items = {};
  final Random _random = Random();
  
  // Configuración de simulación
  static const int stockMockPorProducto = 10;
  static const double probabilidadError = 0.20; // 20% de probabilidad de error
  static const int delayMinMs = 1000; // 1 segundo
  static const int delayMaxMs = 2000; // 2 segundos

  // Lista de posibles errores
  final List<String> _erroresPosibles = [
    'Stock insuficiente',
    'Error de conexión con el servidor',
    'Producto no disponible temporalmente',
    'Sesión expirada. Por favor, inicia sesión nuevamente',
  ];

  // Simular delay de red
  Future<void> _simularDelay() async {
    final delay = delayMinMs + _random.nextInt(delayMaxMs - delayMinMs);
    await Future.delayed(Duration(milliseconds: delay));
  }

  // Simular error aleatorio (20% probabilidad)
  String? _simularError() {
    if (_random.nextDouble() < probabilidadError) {
      return _erroresPosibles[_random.nextInt(_erroresPosibles.length)];
    }
    return null;
  }

  // ==================== OPERACIONES DEL CARRITO ====================

  /// Agregar producto al carrito
  Future<OperacionCarritoResultado> agregarProducto(
    Producto producto,
    int cantidad,
  ) async {
    await _simularDelay();

    // Simular error aleatorio
    final error = _simularError();
    if (error != null) {
      return OperacionCarritoResultado.error(error);
    }

    // Validar cantidad
    if (cantidad < 1) {
      return OperacionCarritoResultado.error(
        'La cantidad debe ser mayor a 0',
      );
    }

    // Obtener stock actual del producto
    final stockActual = producto.stock;

    // Si el producto ya existe en el carrito
    if (_items.containsKey(producto.id)) {
      final itemExistente = _items[producto.id]!;
      final cantidadEnCarrito = itemExistente.cantidad;
      final nuevaCantidad = cantidadEnCarrito + cantidad;

      // Validar stock disponible real del producto
      if (nuevaCantidad > stockActual) {
        final disponible = stockActual - cantidadEnCarrito;
        return OperacionCarritoResultado.error(
          'Stock insuficiente. Solo quedan $disponible unidades disponibles',
        );
      }

      itemExistente.cantidad = nuevaCantidad;
      // Actualizar stock del producto (descontar)
      producto.stock = stockActual - cantidad;
      
      return OperacionCarritoResultado.exito(
        mensaje: 'Cantidad actualizada en el carrito',
        datos: itemExistente,
      );
    } else {
      // Validar stock para nuevo producto
      if (cantidad > stockActual) {
        return OperacionCarritoResultado.error(
          'Stock insuficiente. Solo hay $stockActual unidades disponibles',
        );
      }

      // Descontar del stock del producto
      producto.stock = stockActual - cantidad;

      // Agregar nuevo producto
      final nuevoItem = CarritoItem(
        producto: producto,
        cantidad: cantidad,
        stockDisponible: producto.stock, // Stock restante
      );
      _items[producto.id] = nuevoItem;

      return OperacionCarritoResultado.exito(
        mensaje: '${producto.nombre} agregado al carrito',
        datos: nuevoItem,
      );
    }
  }

  /// Eliminar producto del carrito
  Future<OperacionCarritoResultado> eliminarProducto(String productoId) async {
    await _simularDelay();

    // Simular error aleatorio
    final error = _simularError();
    if (error != null) {
      return OperacionCarritoResultado.error(error);
    }

    if (_items.containsKey(productoId)) {
      final itemEliminado = _items.remove(productoId);
      return OperacionCarritoResultado.exito(
        mensaje: '${itemEliminado!.producto.nombre} eliminado del carrito',
      );
    } else {
      return OperacionCarritoResultado.error(
        'Producto no encontrado en el carrito',
      );
    }
  }

  /// Actualizar cantidad de un producto
  Future<OperacionCarritoResultado> actualizarCantidad(
    String productoId,
    int nuevaCantidad,
  ) async {
    await _simularDelay();

    // Simular error aleatorio
    final error = _simularError();
    if (error != null) {
      return OperacionCarritoResultado.error(error);
    }

    // Validar cantidad mínima
    if (nuevaCantidad < 1) {
      return OperacionCarritoResultado.error(
        'La cantidad no puede ser menor a 1',
      );
    }

    if (_items.containsKey(productoId)) {
      final item = _items[productoId]!;

      // Validar stock disponible
      if (nuevaCantidad > stockMockPorProducto) {
        return OperacionCarritoResultado.error(
          'Stock insuficiente. Solo hay $stockMockPorProducto unidades disponibles',
        );
      }

      item.cantidad = nuevaCantidad;
      return OperacionCarritoResultado.exito(
        mensaje: 'Cantidad actualizada',
        datos: item,
      );
    } else {
      return OperacionCarritoResultado.error(
        'Producto no encontrado en el carrito',
      );
    }
  }

  /// Obtener items del carrito (sin delay, operación local)
  List<CarritoItem> obtenerItems() {
    return _items.values.toList();
  }

  /// Obtener item específico
  CarritoItem? obtenerItem(String productoId) {
    return _items[productoId];
  }

  /// Vaciar carrito completo
  Future<OperacionCarritoResultado> vaciarCarrito() async {
    await _simularDelay();

    // Simular error aleatorio
    final error = _simularError();
    if (error != null) {
      return OperacionCarritoResultado.error(error);
    }

    final cantidadEliminada = _items.length;
    _items.clear();

    return OperacionCarritoResultado.exito(
      mensaje: 'Carrito vaciado. $cantidadEliminada productos eliminados',
    );
  }

  /// Calcular totales del carrito
  CarritoTotales calcularTotales() {
    // Subtotal: suma de precio × cantidad
    double subtotal = 0.0;
    int cantidadItems = 0;

    for (var item in _items.values) {
      subtotal += item.subtotal;
      cantidadItems += item.cantidad;
    }

    // Descuento: 10% si el total > $100
    double descuento = 0.0;
    if (subtotal > 100) {
      descuento = subtotal * 0.10;
    }

    // Subtotal después del descuento
    double subtotalConDescuento = subtotal - descuento;

    // Impuestos: 12% sobre el subtotal (después del descuento)
    double impuestos = subtotalConDescuento * 0.12;

    // Total final
    double total = subtotalConDescuento + impuestos;

    return CarritoTotales(
      subtotal: subtotal,
      descuento: descuento,
      impuestos: impuestos,
      total: total,
      cantidadItems: cantidadItems,
    );
  }

  /// Obtener cantidad total de items
  int obtenerCantidadTotal() {
    int total = 0;
    for (var item in _items.values) {
      total += item.cantidad;
    }
    return total;
  }

  /// Verificar si el carrito está vacío
  bool estaVacio() {
    return _items.isEmpty;
  }

  /// Verificar si un producto está en el carrito
  bool contieneProducto(String productoId) {
    return _items.containsKey(productoId);
  }

  /// Obtener cantidad de un producto específico
  int obtenerCantidadProducto(String productoId) {
    return _items[productoId]?.cantidad ?? 0;
  }
}