<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateServicioPaqueteTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('servicio_paquete', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('id_servicio')->unsigned()->index();
            $table->foreign('id_servicio')->references('id')->on('servicio')->onDelete('cascade')->onUpdate('cascade');
            $table->integer('id_paquete')->unsigned()->index();
            $table->foreign('id_paquete')->references('id')->on('detalle_paquete')->onDelete('cascade')->onUpdate('cascade');
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
        Schema::dropIfExists('servicio_paquete');
    }
}
