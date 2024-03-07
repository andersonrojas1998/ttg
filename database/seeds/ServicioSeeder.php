<?php

use App\Model\Servicio;
use Illuminate\Database\Seeder;

class ServicioSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $nombres = ['Lavada','Aspirada','Llantil','Silicona','Brillada', 'Lavado Motor'];
        foreach($nombres as $nombre){
            $servicio = new Servicio(['nombre' => $nombre]);
            $servicio->save();
        }
    }
}
