<?php

use App\Model\DetalleCompraProductos;
use Illuminate\Database\Seeder;

class DetalleCompraProductosSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        for($i = 0; $i < 50; $i++)
            factory(DetalleCompraProductos::class, 1)->create();
    }
}
