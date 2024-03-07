<?php

use App\Model\DetallePaquete;
use App\Model\EstadoVenta;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        $this->call(MarcaSeeder::class);
        $this->call(TipoProductoSeeder::class);
        $this->call(UnidadDeMedidaSeeder::class);
        $this->call(PresentacionSeeder::class);
        $this->call(ProductoSeeder::class);
        $this->call(EstadoSeeder::class);
        $this->call(CondicionesSeeder::class);
        $this->call(CompraSeeder::class);
        $this->call(DetalleCompraProductosSeeder::class);
        $this->call(TipoVehiculoSeeder::class);
        $this->call(ServicioSeeder::class);
        $this->call(PaqueteSeeder::class);
        $this->call(DetallePaqueteSeeder::class);
        $this->call(ServicioPaqueteSeeder::class);
        $this->call(EstadoVentaSeeder::class);
        $this->call(VentaSeeder::class);
        $this->call(DetalleVentaProductosSeeder::class);
    }
}
