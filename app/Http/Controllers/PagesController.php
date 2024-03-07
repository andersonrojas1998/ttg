<?php

namespace App\Http\Controllers;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;

class PagesController extends Controller
{
 
    public function homeIndex(){
        if (Auth::check()) {
            return redirect('/home');
        }else{
            return view('auth.login');
        }
        
    }
}
