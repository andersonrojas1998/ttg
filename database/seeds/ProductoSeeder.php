<?php

use Illuminate\Database\Seeder;
use App\Model\Producto;

class ProductoSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        factory(Producto::class, 50)->create();
    }
}
