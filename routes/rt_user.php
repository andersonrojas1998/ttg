<?php
Route::get('/registerUser', function () { return view('auth.registerUser'); })->name('registerUser');
Route::get('/registerEnterprise', function () { return view('auth.registerEnterprise'); })->name('registerEnterprise');
Route::post('userLogin', 'UsersController@create')->name('userRegister');
Route::post('userLoginEnterprise', 'UsersController@createEnterprise')->name('userLoginEnterprise');
Route::get('typeDoc', 'EnterpriseController@getTypeDoc');  