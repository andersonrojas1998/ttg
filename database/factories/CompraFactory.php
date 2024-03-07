<?php

use Faker\Generator as Faker;

$factory->define(App\Model\Compra::class, function (Faker $faker) {
    return [
        'reg_op' => $faker->sentence(1),
        'fecha_emision' => $faker->date(),
        'compracol' => $faker->sentence(1),
        'fecha_vencimiento' => $faker->date(),
        'no_comprobante' => $faker->numberBetween(),
        'id_proveedor' => $faker->numberBetween(1000000),
        'razon_social_proveedor' => $faker->randomElement(['Natural', 'Jurídica']),
        'descuentos_iva' => $faker->sentence(1),
        'importe_total' => $faker->numberBetween(1000000),
        'condiciones_id' => 1
    ];
});
