<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateDetallePaqueteTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('detalle_paquete', function (Blueprint $table) {
            $table->increments('id');
            $table->float('precio_venta');
            $table->float('porcentaje')->nullable();
            $table->integer('id_tipo_vehiculo', false, true)->index();
            $table->foreign('id_tipo_vehiculo')->references('id')->on('tipo_vehiculo')->onDelete('cascade')->onUpdate('cascade');
            $table->integer('id_paquete', false, true)->index();
            $table->foreign('id_paquete')->references('id')->on('paquete')->onDelete('cascade')->onUpdate('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('detalle_paquete');
    }
}
