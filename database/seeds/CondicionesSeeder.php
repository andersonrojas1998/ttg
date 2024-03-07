<?php

use App\Model\Condiciones;
use Illuminate\Database\Seeder;

class CondicionesSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        factory(Condiciones::class, 10)->create();
    }
}
