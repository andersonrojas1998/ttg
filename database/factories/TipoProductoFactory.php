<?php

use Faker\Generator as Faker;

$factory->define(App\Model\Tipo_Producto::class, function (Faker $faker) {
    return [
        'descripcion' => $faker->sentence(1)
    ];
});
