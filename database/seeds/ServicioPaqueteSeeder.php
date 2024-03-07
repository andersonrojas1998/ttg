<?php

use App\Model\ServicioPaquete;
use Illuminate\Database\Seeder;

class ServicioPaqueteSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        for($i = 0; $i < 15; $i++){
            factory(ServicioPaquete::class, 1)->create();
        }
    }
}
