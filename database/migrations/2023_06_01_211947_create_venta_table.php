<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateVentaTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('venta', function (Blueprint $table) {
            $table->increments('id');
            $table->timestamp('fecha')->useCurrent();
            $table->string('nombre_cliente');
            $table->string('placa');
            $table->string('numero_telefono');
            $table->integer('id_detalle_paquete')->nullable()->unsigned();
            $table->foreign('id_detalle_paquete')->references('id')->on('detalle_paquete')->onDelete('cascade')->onUpdate('cascade');
            $table->integer('id_tipo_vehiculo_detalle_paquete')->nullable()->unsigned();
            $table->foreign('id_tipo_vehiculo_detalle_paquete')->references('id_tipo_vehiculo')->on('detalle_paquete')->onDelete('cascade')->onUpdate('cascade');
            $table->integer('id_paquete_detalle_paquete')->nullable()->unsigned();
            $table->foreign('id_paquete_detalle_paquete')->references('id_paquete')->on('detalle_paquete')->onDelete('cascade')->onUpdate('cascade');
            $table->integer('id_usuario');
            $table->integer('id_estado_venta')->unsigned()->index();
            $table->foreign('id_estado_venta')->references('id')->on('estado_venta')->onDelete('cascade')->onUpdate('cascade');
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
        Schema::dropIfExists('venta');
    }
}
