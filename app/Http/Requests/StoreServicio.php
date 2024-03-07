<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreServicio extends FormRequest
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
            'nombre' => 'required',
            'precio_venta' => 'required',
            'porcentaje_trabajador' => 'required',
            'id_tipo_vehiculo' => 'required'
        ];
    }

    public function messages()
    {
        return [
            'nombre.required' => 'El nombre es requerido',
            'precio_venta.required' => 'El precio de venta es requerido',
            'porcentaje_trabajador.required' => 'El porcentaje del trabajador es requerido',
            'id_tipo_vehiculo.required' => 'El tipo de vehiculo es requerido'
        ];
    }
}
