import 'producto.dart';

class CarritoItem {
  final Producto producto;
  int cantidad;
  final int stockDisponible; // Stock mock de 10 unidades por producto

  CarritoItem({
    required this.producto,
    this.cantidad = 1,
    this.stockDisponible = 10,
  });

  // Calcular subtotal del item
  double get subtotal => producto.precio * cantidad;

  // Crear copia con modificaciones
  CarritoItem copyWith({
    Producto? producto,
    int? cantidad,
    int? stockDisponible,
  }) {
    return CarritoItem(
      producto: producto ?? this.producto,
      cantidad: cantidad ?? this.cantidad,
      stockDisponible: stockDisponible ?? this.stockDisponible,
    );
  }

  // Validar si se puede agregar más cantidad
  bool puedoAgregarCantidad(int cantidadAgregar) {
    return (cantidad + cantidadAgregar) <= stockDisponible;
  }

  @override
  String toString() {
    return 'CarritoItem(producto: ${producto.nombre}, cantidad: $cantidad, subtotal: \$${subtotal.toStringAsFixed(2)})';
  }
}

// Clase para cálculos del carrito
class CarritoTotales {
  final double subtotal;
  final double descuento;
  final double impuestos;
  final double total;
  final int cantidadItems;

  CarritoTotales({
    required this.subtotal,
    required this.descuento,
    required this.impuestos,
    required this.total,
    required this.cantidadItems,
  });

  @override
  String toString() {
    return '''
CarritoTotales(
  subtotal: \$${subtotal.toStringAsFixed(2)},
  descuento: \$${descuento.toStringAsFixed(2)},
  impuestos: \$${impuestos.toStringAsFixed(2)},
  total: \$${total.toStringAsFixed(2)},
  items: $cantidadItems
)''';
  }
}