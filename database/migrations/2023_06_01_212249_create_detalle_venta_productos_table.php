<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateDetalleVentaProductosTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('detalle_venta_productos', function (Blueprint $table) {
            $table->integer('id_venta')->unsigned()->index();
            $table->foreign('id_venta')->references('id')->on('venta')->onDelete('cascade')->onUpdate('cascade');
            $table->integer('detalle_productos')->unsigned()->index();
            $table->foreign('detalle_productos')->references('id')->on('detalle_compra_productos')->onDelete('cascade')->onUpdate('cascade');
            $table->integer('cantidad');
            $table->primary(['id_venta', 'detalle_productos']);
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
        Schema::dropIfExists('detalle_venta_productos');
    }
}
