class Producto {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagenUrl;
  final String categoria;
  int stock; // ← Ahora es mutable (sin final)

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagenUrl,
    required this.categoria,
    this.stock = 10, // ← Stock inicial de 10
  });

  // Método para crear una copia con valores modificados
  Producto copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    double? precio,
    String? imagenUrl,
    String? categoria,
    int? stock,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      categoria: categoria ?? this.categoria,
      stock: stock ?? this.stock,
    );
  }
}

// Datos de ejemplo para el taller
List<Producto> productosEjemplo = [
  Producto(
    id: '1',
    nombre: 'Laptop Pro',
    descripcion: 'Laptop de alto rendimiento',
    precio: 1299.99,
    imagenUrl: 'laptop',
    categoria: 'Electrónica',
    stock: 10,
  ),
  Producto(
    id: '2',
    nombre: 'Auriculares BT',
    descripcion: 'Auriculares inalámbricos',
    precio: 89.99,
    imagenUrl: 'headphones',
    categoria: 'Electrónica',
    stock: 10,
  ),
  Producto(
    id: '3',
    nombre: 'Smartwatch',
    descripcion: 'Reloj inteligente deportivo',
    precio: 249.99,
    imagenUrl: 'watch',
    categoria: 'Electrónica',
    stock: 10,
  ),
  Producto(
    id: '4',
    nombre: 'Cámara Digital',
    descripcion: 'Cámara profesional 4K',
    precio: 599.99,
    imagenUrl: 'camera',
    categoria: 'Fotografía',
    stock: 10,
  ),
  Producto(
    id: '5',
    nombre: 'Teclado Mecánico',
    descripcion: 'Teclado gaming RGB',
    precio: 129.99,
    imagenUrl: 'keyboard',
    categoria: 'Accesorios',
    stock: 10,
  ),
  Producto(
    id: '6',
    nombre: 'Mouse Inalámbrico',
    descripcion: 'Mouse ergonómico',
    precio: 49.99,
    imagenUrl: 'mouse',
    categoria: 'Accesorios',
    stock: 10,
  ),
];