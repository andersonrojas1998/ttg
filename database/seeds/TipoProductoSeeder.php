<?php

use App\Model\Tipo_Producto;
use Illuminate\Database\Seeder;

class TipoProductoSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        factory(Tipo_Producto::class, 10)->create();
    }
}
