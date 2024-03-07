<?php

use App\Model\EstadoVenta;
use Illuminate\Database\Seeder;

class EstadoVentaSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $estado1 = new EstadoVenta([
            'nombre' => 'Pendiente por pagar',
            'descripcion' => '...'
        ]);
        $estado1->save();

        $estado2 = new EstadoVenta([
            'nombre' => 'Servicio pagado',
            'descripcion' => '...'
        ]);
        $estado2->save();

        $estado3 = new EstadoVenta([
            'nombre' => 'Venta interna',
            'descripcion' => '...'
        ]);
        $estado3->save();
    }
}
