<?php

namespace App\Model;

use Illuminate\Database\Eloquent\Model;

class Condiciones extends Model
{
    protected $table = 'condiciones';

    protected $fillable = [
        'descripcion'
    ];

    public function compra()
    {
        return $this->belongsTo('App\Model\Compra', 'id');
    }
}
