<?php

use Faker\Generator as Faker;

$factory->define(App\Model\UnidadDeMedida::class, function (Faker $faker) {
    $nombre = $faker->sentence(1);
    return [
        'nombre' => $nombre,
        'abreviatura' => substr($nombre, 0, 3)
    ];
});
