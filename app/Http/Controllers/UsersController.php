<?php

namespace App\Http\Controllers;
use App\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Http\Request;
use App\Model\Enterprise;


class UsersController extends Controller
{

    protected function create(\Request $request)
    {
       $User= new User;
       $User->nombres=$request::input('name');
       $User->apellidos=$request::input('apellido');
       $User->tipo_documento_id=intval($request::input('tipo_dni'));
       $User->identificacion=$request::input('identificacion');
       $User->telefono=$request::input('telefono');
       $User->email=$request::input('email');
       $User->estado=1;
       $User->password=Hash::make($request::input('password'));       
       $User->save();
       $User->attachRole(10);      
       return redirect()->route('login')->with('success', 'Se ha registrado satisfactoriamente');
    }
    protected function createEnterprise(\Request $request)
    {
        

    try {
       $e = new Enterprise();
       $e->razon_social=$request::input('razon_social');
       $e->nit=$request::input('nit');
       $e->sector=$request::input('sector');
       $e->telefono=$request::input('telefono_enterprise');
       $e->logo=$_FILES['logo']['name'];
       $e->save();

      $originalPath = $_FILES['logo']['tmp_name'];
      $destination=public_path(). "/assets/enterprise/" .$_FILES['logo']['name'];
      copy($originalPath, $destination);

       $User= new User;
       $User->nombres=$request::input('name');
       $User->apellidos=$request::input('apellido');
       $User->tipo_documento_id=intval($request::input('tipo_dni'));
       $User->identificacion=$request::input('identificacion');
       $User->telefono=$request::input('telefono');
       $User->email=$request::input('email');
       $User->empresa_id=$e->id;
       $User->estado=1;
       $User->password=Hash::make($request::input('password'));       
       $User->save();
       $User->attachRole(1);   
       
       return redirect()->route('login')->with('success', 'Se ha registrado satisfactoriamente');
    } catch (\Throwable $e) {
        return redirect()->route('login')->withErrors('danger', 'Error');
 
    }

       
    }
}
