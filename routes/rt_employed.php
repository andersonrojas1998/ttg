<?php

Route::group(['prefix' => 'employ'], function(){
    Route::get('inicio', 'EmployController@index')->name('employ.inicio'); 
    Route::get('list-postulation', 'EmployController@listPostulation')->name('employ.list'); 
    Route::get('rt_employDetails/{id}', 'EmployController@employDetails'); 
    Route::get('saveDetailsPostulation', 'EmployController@saveDetailsPostulation'); 
    Route::get('myPostulation', 'EmployController@myPostulation'); 
});