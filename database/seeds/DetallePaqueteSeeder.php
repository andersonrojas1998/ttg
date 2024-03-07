<?php

use App\Model\DetallePaquete;
use Illuminate\Database\Seeder;

class DetallePaqueteSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        for($i = 0; $i < 15; $i++){
            factory(DetallePaquete::class, 1)->create();
        }
    }
}
