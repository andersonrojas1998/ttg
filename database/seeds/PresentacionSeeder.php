<?php

use App\Model\Presentacion;
use Illuminate\Database\Seeder;

class PresentacionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        
        $presentacion = new Presentacion(['nombre'=>'500ml']);
        $presentacion->save();

        $presentacion = new Presentacion(['nombre'=>'800ml']);
        $presentacion->save();
    }
}
