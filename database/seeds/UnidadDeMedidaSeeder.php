<?php

use App\Model\UnidadDeMedida;
use Illuminate\Database\Seeder;

class UnidadDeMedidaSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        factory(UnidadDeMedida::class, 10)->create();
    }
}
