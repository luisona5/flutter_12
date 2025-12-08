import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/producto.dart';
import '../providers/carrito_provider.dart';

class ProductoDetalleScreen extends StatefulWidget {
  final Producto producto;

  const ProductoDetalleScreen({
    super.key,
    required this.producto,
  });

  @override
  State<ProductoDetalleScreen> createState() => _ProductoDetalleScreenState();
}

class _ProductoDetalleScreenState extends State<ProductoDetalleScreen> {
  int _cantidadSeleccionada = 1;
  bool _agregando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Imagen del producto
                Container(
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue.shade100,
                        Colors.purple.shade100,
                      ],
                    ),
                  ),
                  child: Icon(
                    _getIcono(widget.producto.imagenUrl),
                    size: 150,
                    color: Colors.grey[700],
                  ),
                ),

                // Botón de volver
                Positioned(
                  top: 40,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                // Badge de descuento
                Positioned(
                  top: 100,
                  left: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '-20%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                // Ícono de favorito
                Positioned(
                  top: 40,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.red),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Agregado a favoritos ❤️'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Botón flotante "Agregar al carrito" - ACTUALIZADO
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Consumer<CarritoProvider>(
                    builder: (context, carrito, child) {
                      final yaEnCarrito =
                          carrito.contieneProducto(widget.producto.id);

                      return FloatingActionButton.extended(
                        onPressed: _agregando
                            ? null
                            : () => _agregarAlCarrito(context),
                        backgroundColor:
                            yaEnCarrito ? Colors.green : Colors.blue,
                        icon: _agregando
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Icon(yaEnCarrito
                                ? Icons.check_circle
                                : Icons.shopping_cart),
                        label: Text(yaEnCarrito ? 'En carrito' : 'Agregar'),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Información del producto
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.producto.nombre,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Precio y stock
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${widget.producto.precio.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: widget.producto.stock > 0
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.producto.stock > 0
                              ? 'En stock (${widget.producto.stock})'
                              : 'Agotado',
                          style: TextStyle(
                            color: widget.producto.stock > 0
                                ? Colors.green.shade900
                                : Colors.red.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Categoría
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Categoría: ${widget.producto.categoria}',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Selector de cantidad - NUEVO
                  _buildSelectorCantidad(),
                  const SizedBox(height: 16),

                  const Divider(thickness: 1),
                  const SizedBox(height: 16),

                  const Text(
                    'Descripción del Producto',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    widget.producto.descripcion,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Características',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildCaracteristica(Icons.verified, 'Garantía de 1 año'),
                  _buildCaracteristica(Icons.local_shipping, 'Envío gratis'),
                  _buildCaracteristica(Icons.payment, 'Pago seguro'),
                  _buildCaracteristica(Icons.support_agent, 'Soporte 24/7'),

                  const SizedBox(height: 24),

                  // Botón de agregar al carrito grande - ACTUALIZADO
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: widget.producto.stock > 0 && !_agregando
                          ? () => _agregarAlCarrito(context)
                          : null,
                      icon: _agregando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.add_shopping_cart),
                      label: Text(
                        _agregando
                            ? 'Agregando...'
                            : widget.producto.stock > 0
                                ? 'Agregar al carrito ($_cantidadSeleccionada)'
                                : 'Producto agotado',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        disabledBackgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget: Selector de cantidad - NUEVO
  Widget _buildSelectorCantidad() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text(
            'Cantidad:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: _cantidadSeleccionada > 1
                ? () {
                    setState(() {
                      _cantidadSeleccionada--;
                    });
                  }
                : null,
            icon: const Icon(Icons.remove_circle_outline),
            color: Colors.blue,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              '$_cantidadSeleccionada',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: _cantidadSeleccionada < 10
                ? () {
                    setState(() {
                      _cantidadSeleccionada++;
                    });
                  }
                : null,
            icon: const Icon(Icons.add_circle_outline),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildCaracteristica(IconData icono, String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icono, color: Colors.blue, size: 24),
          const SizedBox(width: 12),
          Text(
            texto,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

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

  // Método para agregar al carrito - NUEVO
  void _agregarAlCarrito(BuildContext context) async {
    setState(() {
      _agregando = true;
    });

    final carrito = context.read<CarritoProvider>();
    final resultado = await carrito.agregarProducto(
      widget.producto,
      cantidad: _cantidadSeleccionada,
    );

    setState(() {
      _agregando = false;
    });

    if (!mounted) return;

    if (resultado.exitoso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resultado.mensaje!),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Ver carrito',
            textColor: Colors.white,
            onPressed: () {
              // Aquí podrías navegar al carrito si lo deseas
            },
          ),
        ),
      );
    } else {
      // Error: mostrar SnackBar rojo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(resultado.mensaje!)),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Reintentar',
            textColor: Colors.white,
            onPressed: () => _agregarAlCarrito(context),
          ),
        ),
      );
    }
  }
}