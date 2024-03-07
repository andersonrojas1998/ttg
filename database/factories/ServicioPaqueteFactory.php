<?php

use App\Model\Servicio;
use Faker\Generator as Faker;
use Illuminate\Support\Facades\DB;

$factory->define(App\Model\ServicioPaquete::class, function (Faker $faker) {
    return [
        'id_servicio' => Servicio::all()->random()->id,
        'id_paquete' => DB::table('detalle_paquete')
                            ->leftJoin('servicio_paquete','servicio_paquete.id_paquete','detalle_paquete.id')
                            ->whereNull('servicio_paquete.id_paquete')
                            ->value('detalle_paquete.id')
    ];
});
