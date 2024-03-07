<?php

use App\Model\TipoVehiculo;
use Illuminate\Database\Seeder;

class TipoVehiculoSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $moto = new TipoVehiculo([
            'descripcion' => 'Moto',
            'imagen' => 'storage/motorcycle.png'
        ]);

        $moto->nomenclatura = 'M';

        $moto->save();

        $automovil = new TipoVehiculo([
            'descripcion' => 'Automovil',
            'imagen' => 'storage/car.png'
        ]);

        $automovil->nomenclatura = 'C';

        $automovil->save();

        $camioneta = new TipoVehiculo([
            'descripcion' => 'Camioneta',
            'imagen' => 'storage/pickup_truck.png'
        ]);

        $camioneta->nomenclatura = 'C';

        $camioneta->save();
    }
}
