<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateDetalleCompraProductosTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('detalle_compra_productos', function (Blueprint $table) {
            $table->increments('id_detalle_compra');
            $table->integer('id_producto')->unsigned()->index();
            $table->foreign('id_producto')->references('id')->on('producto')->onDelete('cascade')->onUpdate('cascade');
            $table->integer('id_compra')->unsigned()->index();
            $table->foreign('id_compra')->references('id')->on('compra')->onDelete('cascade')->onUpdate('cascade');
            $table->integer('cantidad');
            $table->float('precio_compra');
            $table->float('precio_venta');
            $table->string('referencia')->nullable();
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
        Schema::dropIfExists('detalle_compra_productos');
    }
}
