<?php

use Faker\Generator as Faker;

$factory->define(App\Model\Marca::class, function (Faker $faker) {
    return [
        'nombre' => $faker->sentence(1)
    ];
});
