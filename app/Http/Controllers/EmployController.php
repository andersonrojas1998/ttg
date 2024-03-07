<?php

namespace App\Http\Controllers;
use DB;
use App\User;
use Auth;
use Illuminate\Http\Request;
use DateTime;
use App\Model\Area;
use App\Model\Cargo;
use App\Model\Rango;
use App\Model\Ciudad;
use App\Model\Modalidad;
use App\Model\Oferta;
use App\Model\Oferta_has_usuario;

class EmployController extends Controller
{
    public function index(){
        return view('employed.index_employed');
    }
    public function listPostulation(){
        return view('employed.list_postulated');
    }
    public function store(\Request $request)
    {
        $date_now = date('Y-m-d');
        try{           
            $oferta = new Oferta();
            $oferta->titulo=$request::input('title');
            $oferta->descripcion=$request::input('description');            
            $oferta->estado_id = 1;
            $oferta->empresa_id=1;
            $oferta->rango_salarial_id=$request::input('range');            
            $oferta->cargo_id=$request::input('position');            
            $oferta->fecha_inicio=$date_now;
            $day=intval($request::input('day'));                                      
            $date_future = strtotime('+'.$day.' day', strtotime($date_now));
            $date_future = date('Y-m-d', $date_future);            
            $oferta->fecha_fin=$date_future;
            $oferta->modalidad_id =$request::input('modality');  
            $oferta->ciudad_id =$request::input('city');  
            $oferta->save();
            return redirect()->route('enterprise.inicio')->with('success', 'Se ha creado la oferta satisfactoriamente');
        }catch(Exception $e){
            return redirect()->route('enterprise.inicio')->with('fail', 'Ha ocurrido un error al guardar<br><br>' . $e->getMessage());
        }
        
    }

    public function employmentList(){

        $c=DB::SELECT("CALL sp_employed() ");
        $data=[];
        foreach($c as $key => $us)
        {                            
            $data['data'][$key]['con']=$us->id;   
            $data['data'][$key]['oferta']=$us->oferta;
            $data['data'][$key]['descripcion']=$us->descripcion;
            $data['data'][$key]['empresa']=$us->empresa;
            $data['data'][$key]['rango']=$us->rango;
            $data['data'][$key]['fecha_publicacion']=$us->fecha_publicacion;
            $data['data'][$key]['ciudad']=$us->ciudad;
            $data['data'][$key]['modalidad']=$us->modalidad;
            $data['data'][$key]['estado']=$us->estado;
            $data['data'][$key]['estado_id']=$us->estado_id;
            $data['data'][$key]['postulados']=$us->postulados;           
        }
        return json_encode($data);

    }
   

    public function area(){
        $arry=Area::all();
        return json_encode($arry);
    }
    public function cargo($id){
        $arry=Cargo::where('categoria_id',$id)->get();
        return json_encode($arry);
    }
    public function range(){
        $arry=Rango::all();
        return json_encode($arry);
    }

    public function city(){
        $arry=Ciudad::all();
        return json_encode($arry);
    }
    public function modality(){
        $arry=Modalidad::all();
        return json_encode($arry);
    }
    public function updateStatus(\Request $request){
        $oferta =  Oferta::find($request::input('id'));
        $oferta->estado_id=$request::input('status');
        $oferta->save();
        return $oferta;
    }
    public function myPostulation(){
        $id=Auth::user()->id;
        return json_encode(DB::SELECT("CALL sp_myPostulation($id) "));
    }
    public function employDetails($id){
        $idUser=Auth::user()->id;
        return json_encode(DB::SELECT("CALL sp_employDetails('$id','$idUser') "));
    }  
    public function  saveDetailsPostulation(\Request  $request){

        $date_now = date('Y-m-d');
        try{           
            $oferta = new Oferta_has_usuario();
            $oferta->oferta_id=$request::input('id');
            $oferta->oferta_empresa_id=$request::input('id_enter');            
            $oferta->usuario_id=Auth::user()->id;
            $oferta->fecha_postulacion=$date_now;
            $oferta->estado_postulacion_id=1;
            $oferta->save();
            return 200;
        }catch(Exception $e){
            return redirect()->route('enterprise.inicio')->with('fail', 'Ha ocurrido un error al guardar<br><br>' . $e->getMessage());
        }
    }
   
}
