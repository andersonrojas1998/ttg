<?php

use App\Model\Estado;
use Illuminate\Database\Seeder;

class EstadoSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $estado1 = new Estado(['descripcion' => 'Activo']);
        $estado1->save();

        $estado2 = new Estado(['descripcion' => 'Inactivo']);
        $estado2->save();
    }
}
