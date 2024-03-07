<?php

use App\Model\TipoVehiculo;
use Faker\Generator as Faker;
use Illuminate\Support\Facades\DB;

$factory->define(App\Model\DetallePaquete::class, function (Faker $faker) {
    return [
        'precio_venta' => $faker->randomElement([20000,40000,50000,60000,30000,70000,80000]),
        'id_tipo_vehiculo' => TipoVehiculo::all()->random()->id,
        'id_paquete' => DB::table('paquete')
                            ->leftJoin('detalle_paquete', 'detalle_paquete.id_paquete', 'paquete.id')
                            ->whereNull('detalle_paquete.id_paquete')
                            ->value('paquete.id')

    ];
});
