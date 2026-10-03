// Conexión a la base de datos
use('MARFARMA_NOSQL');

// Eliminar colección si existe para hacer el script reproducible
db.ventas_marfama.drop();

// CREATE: Insertar documentos (JSON jerárquico que encapsula Cliente, Vendedor y Detalles)
db.ventas_marfama.insertMany([
  {
    "id_venta": "V-NOSQL-001",
    "fecha": "2026-10-01",
    "metodo_pago": "Efectivo",
    "cliente": {
      "nombre": "Juan Pérez",
      "tipo_cliente": "Frecuente",
      "distrito": "Cajamarca"
    },
    "vendedor": "Ana Gómez",
    "detalles": [
      {
        "producto": "Paracetamol 500mg",
        "cantidad": 2,
        "precio_unitario": 2.50,
        "subtotal": 5.00
      },
      {
        "producto": "Ibuprofeno 400mg",
        "cantidad": 1,
        "precio_unitario": 3.00,
        "subtotal": 3.00
      }
    ],
    "total_venta": 8.00
  },
  {
    "id_venta": "V-NOSQL-002",
    "fecha": "2026-10-02",
    "metodo_pago": "Tarjeta",
    "cliente": {
      "nombre": "María Rojas",
      "tipo_cliente": "Ocasional",
      "distrito": "Baños del Inca"
    },
    "vendedor": "Luis Martínez",
    "detalles": [
      {
        "producto": "Amoxicilina 500mg",
        "cantidad": 1,
        "precio_unitario": 15.00,
        "subtotal": 15.00
      }
    ],
    "total_venta": 15.00
  }
]);

// READ: Consultar todas las ventas
console.log("=== LECTURA DE VENTAS ===");
const ventas = db.ventas_marfama.find().toArray();
printjson(ventas);

// UPDATE: Modificar el método de pago de una venta
db.ventas_marfama.updateOne(
  { "id_venta": "V-NOSQL-001" },
  { $set: { "metodo_pago": "Yape/Plin", "total_venta": 10.00 } }
);

console.log("=== VENTA ACTUALIZADA ===");
const ventaActualizada = db.ventas_marfama.find({ "id_venta": "V-NOSQL-001" }).toArray();
printjson(ventaActualizada);

// DELETE: Eliminar una venta específica
db.ventas_marfama.deleteOne({ "id_venta": "V-NOSQL-002" });

console.log("=== VENTAS DESPUÉS DEL DELETE ===");
const ventasFinal = db.ventas_marfama.find().toArray();
printjson(ventasFinal);
