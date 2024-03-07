<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\UserController;


Route::get('/','PagesController@homeIndex');


require (__DIR__ . '/rt_user.php');


Auth::routes();

Route::group(['middleware' => ['auth']], function () {    
    Route::get('/home', 'HomeController@index')->name('home'); 
    require (__DIR__ . '/rt_enterprise.php');
    require (__DIR__ . '/rt_employed.php');
   
});