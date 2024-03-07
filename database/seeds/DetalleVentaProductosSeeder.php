<?php

use App\Model\DetalleVentaProductos;
use Illuminate\Database\Seeder;

class DetalleVentaProductosSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        for($i = 0; $i < 50; $i++)
            factory(DetalleVentaProductos::class, 1)->create();
    }
}
