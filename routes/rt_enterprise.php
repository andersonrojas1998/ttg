<?php
Route::get('/rt_employmentList', 'HomeController@employmentList');

Route::group(['prefix' => 'enterprise'], function(){
    Route::get('inicio', 'EnterpriseController@index')->name('enterprise.inicio'); 
    Route::get('employmentList/{id}', 'EnterpriseController@employmentList');
    Route::get('generar-oferta-laboral', 'EnterpriseController@employedCreate');
   Route::post('store', 'EnterpriseController@store')->name('enterprise.store'); 
   Route::get('area', 'EnterpriseController@getArea');  
   Route::get('cargo/{id}', 'EnterpriseController@getCargo');  
   Route::get('range', 'EnterpriseController@getRange');  
   Route::get('city', 'EnterpriseController@getCity');  
   Route::get('modality', 'EnterpriseController@getModality');  
   Route::get('updateStatus', 'EnterpriseController@updateStatus');  
   Route::get('listUser/{id}', 'EnterpriseController@getListUser');  
   Route::get('getListUserApi', 'EnterpriseController@getListUserApi');  
   
});