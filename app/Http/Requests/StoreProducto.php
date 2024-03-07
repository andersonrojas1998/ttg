<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;

class StoreProducto extends FormRequest
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
            'id_marca' => 'required',
            'id_tipo_producto' => 'required',
            'id_unidad_medida' => 'required',
            'id_presentacion' => 'required',
            'precio_venta' => 'required'

        ];
    }

    public function messages()
    {
        return [
            'nombre.required' => 'El nombre es requerido',
            'id_marca.required' => 'La marca es requerida',
            'id_tipo_producto.required' => 'El tipo de producto es requerido',
            'id_unidad_medida.required' => 'La unidad de medida es requerida',
            'id_presentacion.required' => 'La presentaci&oacute;n es requerida'
        ];
    }

    /*protected function failedValidation(Validator $validator)
    {
        throw new HttpResponseException(response()->json($validator->errors(), 422));
    }*/
}
