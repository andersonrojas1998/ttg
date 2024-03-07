<?php

use App\Model\Producto;
use App\Model\UnidadDeMedida;
use Faker\Generator as Faker;
use Illuminate\Support\Facades\DB;

$factory->define(App\Model\DetalleCompraProductos::class, function (Faker $faker) {
    $precio_compra = $faker->randomNumber(4);
    $cantidad = $faker->randomNumber(3);
    $producto = Producto::select('producto.*')->leftJoin('detalle_compra_productos', 'detalle_compra_productos.id_producto', 'producto.id')
                    ->whereNull('detalle_compra_productos.id_producto')->get()->random();
    $producto->cant_stock = $cantidad;
    $producto->save();
    return [
        'id_producto' => $producto->id,
        'id_compra' => DB::table('compra')
                        ->leftJoin('detalle_compra_productos', 'detalle_compra_productos.id_compra', '=', 'compra.id')
                        ->whereNull('detalle_compra_productos.id_compra')
                        ->value('compra.id'),
        'cantidad' => $cantidad,
        'precio_compra' => $precio_compra,
        'precio_venta' => $precio_compra + 20000,
    ];
});
