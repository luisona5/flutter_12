import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carrito_provider.dart';
import '../models/carrito_item.dart';

class CarritoScreen extends StatelessWidget {
  const CarritoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Mi Carrito',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<CarritoProvider>(
            builder: (context, carrito, child) {
              if (carrito.estaVacio) return const SizedBox.shrink();
              
              return IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _mostrarDialogoVaciarCarrito(context),
              );
            },
          ),
        ],
      ),
      body: Consumer<CarritoProvider>(
        builder: (context, carrito, child) {
          // Si está cargando, mostrar indicador
          if (carrito.cargando) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Si el carrito está vacío
          if (carrito.estaVacio) {
            return _buildCarritoVacio(context);
          }

          // Carrito con productos
          return Column(
            children: [
              // Lista de productos
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: carrito.items.length,
                  itemBuilder: (context, index) {
                    final item = carrito.items[index];
                    return _buildCarritoItem(context, item);
                  },
                ),
              ),
              // Resumen de totales
              _buildResumenTotales(context, carrito),
            ],
          );
        },
      ),
    );
  }

  // Widget: Carrito vacío
  Widget _buildCarritoVacio(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'Tu carrito está vacío',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega productos para continuar',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Explorar productos'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget: Item del carrito
  Widget _buildCarritoItem(BuildContext context, CarritoItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Imagen del producto
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getIcono(item.producto.imagenUrl),
                size: 40,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 12),
            // Información del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.producto.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.producto.precio.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Controles de cantidad
                  Row(
                    children: [
                      _buildBotonCantidad(
                        context,
                        Icons.remove,
                        () => _decrementarCantidad(context, item),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${item.cantidad}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      _buildBotonCantidad(
                        context,
                        Icons.add,
                        () => _incrementarCantidad(context, item),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Stock: ${item.stockDisponible}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Botón eliminar y subtotal
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _eliminarProducto(context, item),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${item.subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget: Botón de cantidad
  Widget _buildBotonCantidad(
      BuildContext context, IconData icon, VoidCallback onPressed) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  // Widget: Resumen de totales
  Widget _buildResumenTotales(BuildContext context, CarritoProvider carrito) {
    final totales = carrito.totales;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildFilaTotales('Subtotal:', totales.subtotal),
              if (totales.descuento > 0) ...[
                const SizedBox(height: 8),
                _buildFilaTotales(
                  'Descuento (10%):',
                  -totales.descuento,
                  color: Colors.green,
                ),
              ],
              const SizedBox(height: 8),
              _buildFilaTotales('Impuestos (12%):', totales.impuestos),
              const Divider(height: 24, thickness: 1),
              _buildFilaTotales(
                'TOTAL:',
                totales.total,
                esTotal: true,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () => _procesarCompra(context),
                  icon: const Icon(Icons.payment),
                  label: Text(
                    'Procesar Compra (${totales.cantidadItems} items)',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget: Fila de totales
  Widget _buildFilaTotales(
    String label,
    double monto, {
    Color? color,
    bool esTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: esTotal ? 18 : 16,
            fontWeight: esTotal ? FontWeight.bold : FontWeight.normal,
            color: color ?? Colors.black,
          ),
        ),
        Text(
          '\$${monto.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: esTotal ? 20 : 16,
            fontWeight: FontWeight.bold,
            color: color ?? (esTotal ? Colors.blue : Colors.black),
          ),
        ),
      ],
    );
  }

  // ==================== MÉTODOS DE ACCIÓN ====================

  // Incrementar cantidad
  void _incrementarCantidad(BuildContext context, CarritoItem item) async {
    final carrito = context.read<CarritoProvider>();
    final resultado =
        await carrito.incrementarCantidad(item.producto.id);

    if (!context.mounted) return;

    if (resultado.exitoso) {
      _mostrarSnackBar(context, resultado.mensaje!, Colors.green);
    } else {
      _mostrarSnackBar(context, resultado.mensaje!, Colors.red);
    }
  }

  // Decrementar cantidad
  void _decrementarCantidad(BuildContext context, CarritoItem item) async {
    final carrito = context.read<CarritoProvider>();
    final resultado =
        await carrito.decrementarCantidad(item.producto.id);

    if (!context.mounted) return;

    if (resultado.exitoso) {
      _mostrarSnackBar(context, resultado.mensaje!, Colors.green);
    } else {
      _mostrarSnackBar(context, resultado.mensaje!, Colors.orange);
    }
  }

  // Eliminar producto
  void _eliminarProducto(BuildContext context, CarritoItem item) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text(
            '¿Deseas eliminar "${item.producto.nombre}" del carrito?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true || !context.mounted) return;

    final carrito = context.read<CarritoProvider>();
    final resultado = await carrito.eliminarProducto(item.producto.id);

    if (!context.mounted) return;

    if (resultado.exitoso) {
      _mostrarSnackBar(context, resultado.mensaje!, Colors.orange);
    } else {
      _mostrarSnackBar(context, resultado.mensaje!, Colors.red);
    }
  }

  // Mostrar diálogo para vaciar carrito
  void _mostrarDialogoVaciarCarrito(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vaciar carrito'),
        content: const Text(
            '¿Estás seguro de que deseas eliminar todos los productos del carrito?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Vaciar carrito'),
          ),
        ],
      ),
    );

    if (confirmar != true || !context.mounted) return;

    final carrito = context.read<CarritoProvider>();
    final resultado = await carrito.vaciarCarrito();

    if (!context.mounted) return;

    if (resultado.exitoso) {
      _mostrarSnackBar(context, resultado.mensaje!, Colors.orange);
    } else {
      _mostrarSnackBar(context, resultado.mensaje!, Colors.red);
    }
  }

  // Procesar compra
  void _procesarCompra(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Procesar Compra'),
        content: const Text(
            '¿Deseas proceder con la compra? (Esta es una simulación)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final carrito = context.read<CarritoProvider>();
              final resultado = await carrito.vaciarCarrito();
              
              if (!context.mounted) return;
              
              if (resultado.exitoso) {
                _mostrarSnackBar(
                  context,
                  '¡Compra exitosa! 🎉 Gracias por tu compra',
                  Colors.green,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  // Mostrar SnackBar
  void _mostrarSnackBar(BuildContext context, String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Obtener icono
  IconData _getIcono(String tipo) {
    switch (tipo) {
      case 'laptop':
        return Icons.laptop;
      case 'headphones':
        return Icons.headphones;
      case 'watch':
        return Icons.watch;
      case 'camera':
        return Icons.camera_alt;
      case 'keyboard':
        return Icons.keyboard;
      case 'mouse':
        return Icons.mouse;
      default:
        return Icons.shopping_bag;
    }
  }
}