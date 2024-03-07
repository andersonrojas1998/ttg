<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreDetallePaquete extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'id_paquete' => 'required',
            'precio_venta' => 'required',
            'porcentaje' => 'required',
            'id_tipo_vehiculo' => 'required'
        ];
    }

    public function messages()
    {
        return [
            'id_paquete.required' => 'El combo es requerido',
            'precio_venta.required' => 'El precio de venta es requerido',
            'porcentaje.required' => 'El porcentaje para el trabajador es requerido',
            'id_tipo_vehiculo.required' => 'El tipo de vehiculo es requerido'
        ];
    }
}
