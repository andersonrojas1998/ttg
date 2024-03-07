<?php
Route::group(['prefix' => 'reports'], function(){
    Route::get('getSalesxMonth', 'ReportsController@getSalesxMonth');    
    Route::get('getSalesxDay', 'ReportsController@getSalesxDay'); 
    Route::get('Ingreso-Egreso', 'ReportsController@index_income_expeses'); 
    Route::get('dt_expenses_month', 'ReportsController@dt_expenses_month'); 
    Route::get('chart_income_service', 'ReportsController@chart_income_service'); 
    Route::post('add_expenses', 'ReportsController@add_expenses'); 
    Route::get('concept_expenses', 'ReportsController@concept_expenses'); 
    Route::get('ventas-servicio', 'ReportsController@index_sales_month_day'); 
    Route::get('utilidad-mes', 'ReportsController@index_month_utility'); 
    Route::get('getUtilityMonth', 'ReportsController@getUtilityMonth'); 
});
