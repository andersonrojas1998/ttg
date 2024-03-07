<?php

use Faker\Generator as Faker;

$factory->define(App\Model\Paquete::class, function (Faker $faker) {

    return [
        'nombre' => $faker->numerify('Combo #'),
        'color' => $faker->randomElement([
            '#00b0eb,#000000,#ffffff', '#fdf204,#000000,#ffffff', '#a3cc32,#000000,#ffffff',
            '#ed1b26,#ffffff,#ffffff', '#8ed7f8,#000000,#ffffff', '#2d3192,#ffffff,#ffffff',
            '#ffffff,#000000,#000000'
        ])
    ];
});
