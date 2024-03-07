<?php

namespace App;

use Illuminate\Notifications\Notifiable;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Foundation\Auth\User as Authenticatable;

use Bican\Roles\Traits\HasRoleAndPermission;
use Bican\Roles\Contracts\HasRoleAndPermission as HasRoleAndPermissionContract;


class User extends Authenticatable implements   HasRoleAndPermissionContract
{
	use HasRoleAndPermission;
    use Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */



    protected $fillable = [
        'nombres','apellidos','tipo_documento_id','identificacion','telefono', 'email', 'password',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password', 'remember_token',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    public function RolesUser(){
        return $this->hasMany('App\Model\RolesUser','user_id','id');        
    }
    public function enterprise()
    {        
        return $this->hasMany('App\Model\Enterprise','id','empresa_id');        
    }
   
}
