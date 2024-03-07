<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;

class StoreCompra extends FormRequest
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
            'reg_op' => 'required',
            'fecha_emision' => 'required',
            'compracol' => 'required',
            'no_comprobante' => 'required',
            'id_proveedor' => 'required',
            'id_proveedor_nombre' => 'required',
            'razon_social_proveedor' => 'required',
            'descuentos_iva' => 'required',
            'importe_total' => 'required',
            'id_producto' => 'required',
            'cantidad' => 'required',
            'precio_compra' => 'required',
            // 'precio_venta' => 'required'
        ];
    }

    public function messages()
    {
        return [
            'reg_op.required' => 'El reg_op es requerido',
            'fecha_emision.required' => 'La fecha de emision es requerida',
            'compracol.required' => 'La compra es requerida',
            'no_comprobante.required' => 'El No. de comprobante es requerido',
            'id_proveedor.required' => 'El id proveedor es requerido',
            'id_proveedor_nombre.required' => 'El id proveedor es requerido',
            'razon_social_proveedor.required' => 'La razon social del proveedor es requerida',
            'descuentos_iva.required' => 'El descuento del iva son requeridos',
            'importe_total.required' => 'El importe total es requerido',
            'id_producto.required' => 'No se han agregado los productos, por favor agreguelos.',
            'cantidad_producto.required' => 'Agregue los productos',
            'precio_compra_producto.required' => 'Agregue los productos',
            // 'precio_venta_producto.required' => 'Agregue los productos'
        ];
    }
    
    /*protected function failedValidation(Validator $validator)
    {
        throw new HttpResponseException(response()->json($validator->errors(), 422));
    }*/
}
