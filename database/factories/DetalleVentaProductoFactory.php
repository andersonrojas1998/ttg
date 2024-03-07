<?php

use App\Model\Producto;
use Faker\Generator as Faker;
use Illuminate\Support\Facades\DB;

$factory->define(App\Model\DetalleVentaProductos::class, function (Faker $faker) {
    $producto = Producto::select('producto.*')->leftJoin('detalle_venta_productos', 'detalle_venta_productos.id_producto', 'producto.id')
                    ->whereNull('detalle_venta_productos.id_producto')->get()->random();
    $cantidad = $faker->numberBetween(1, $producto->cant_stock);
    $producto->cant_stock_mov = $cantidad;
    $producto->save();
    return [
        'id_venta' => DB::table('venta')
                        ->leftJoin('detalle_venta_productos', 'venta.id', '=', 'detalle_venta_productos.id_venta')
                        ->whereNull('detalle_venta_productos.id_venta')
                        ->value('venta.id'),
        'id_producto' => $producto->id,
        'cantidad' => $cantidad,
        'precio_venta' => $faker->randomElement([20000,25000,30000,35000,40000,45000,50000,55000,60000]),
        'margen_ganancia' => 10000
    ];
});
