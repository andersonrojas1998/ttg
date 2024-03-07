<?php

namespace App\Model;

use Illuminate\Database\Eloquent\Model;

class RolesUser extends Model
{
    protected $table="role_user";


    public function rol(){
        return $this->hasOne('App\Model\Roles','id','role_id');        
    }
}
