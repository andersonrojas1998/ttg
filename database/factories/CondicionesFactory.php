<?php

use Faker\Generator as Faker;

$factory->define(App\Model\Condiciones::class, function (Faker $faker) {
    return [
        'descripcion' => $faker->sentence(1)
    ];
});
