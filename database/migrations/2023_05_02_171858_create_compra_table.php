<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateCompraTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('compra', function (Blueprint $table) {
            $table->increments('id');
            $table->string('reg_op');
            $table->date('fecha_emision');
            $table->string('compracol');
            $table->date('fecha_vencimiento');
            $table->string('no_comprobante');
            $table->string('id_proveedor');
            $table->string('razon_social_proveedor');
            $table->string('descuentos_iva');
            $table->string('importe_total');
            $table->integer('condiciones_id')->unsigned()->index();
            $table->foreign('condiciones_id')->references('id')->on('condiciones')->onDelete('cascade')->onUpdate('cascade');
            $table->integer('id_estado')->unsigned()->index();
            $table->foreign('id_estado')->references('id')->on('estado')->onDelete('cascade')->onUpdate('cascade');
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
        Schema::dropIfExists('compra');
    }
}
