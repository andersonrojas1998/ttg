<?php

use App\Model\DetallePaquete;
use App\Model\EstadoVenta;
use Faker\Generator as Faker;

$factory->define(App\Model\Venta::class, function (Faker $faker) {
    return [
        'nombre_cliente' => $faker->name,
        'placa' => strtoupper($faker->lexify('???')) . $faker->numerify('###'),
        'numero_telefono' => $faker->e164PhoneNumber,
        'id_detalle_paquete' => DetallePaquete::all()->random()->id,
        'id_usuario' => 1,
        'id_estado_venta' => EstadoVenta::all()->random()->id
    ];
});
