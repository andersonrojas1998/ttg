<?php

use App\Model\Marca;
use App\Model\Tipo_Producto;
use App\Model\UnidadDeMedida;
use App\Model\Presentacion;
use Faker\Generator as Faker;

$factory->define(App\Model\Producto::class, function (Faker $faker) {
    return [
        'nombre' => $faker->sentence(1),
        'id_marca' => Marca::all()->random()->id,
        'id_tipo_producto' => Tipo_Producto::all()->random()->id,
        'id_unidad_medida' => UnidadDeMedida::all()->random()->id,
        'id_presentacion' => Presentacion::all()->random()->id,
    ];
});
