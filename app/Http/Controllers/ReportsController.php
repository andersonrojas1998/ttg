<?php
namespace App\Http\Controllers;
use DB;
use DateTime;
use Auth;
use Request;
use App\Model\EgresosMensuales;
use App\Model\EgresosConcepto;


class ReportsController extends Controller
{

    public  $firstDay,$lastDay;

    public function __construct(){
        $date = new DateTime();
        $this->firstDay =$date->modify('first day of this month')->format('Y-m-d');
        $this->lastDay = $date->modify('last day of  this month')->format('Y-m-d');        
    }

    public function index(){        
        return view('reports.index_qualify');
    }

    public function index_income_expeses(){        
        return view('reports.index_income_expenses');
    }

    public function index_sales_month_day(){        
        return view('reports.index_sales_month_day');
    }
    public function index_month_utility(){        
        return view('reports.index_month_utility');
    }
    public function getReportApproved($period,$grade){

        $readTmp=DB::SELECT("CALL sp_missedSubjects('$period','$grade')  ");

        $data=[];
        foreach($readTmp as $k=> $v){
           $data['asignatura'][$k]=$v->tag;
           $data['perdidas'][$k]= $v->perdidas;
           $data['aprovadas'][$k]=$v->aprovadas;
        }
        return json_encode($data);
    }

    public function getSalesxMonth(){

       $data=[];
        for ($i=1;$i<=12;$i++){
            $readTmp=DB::SELECT("CALL sp_salesxmonth('$i')  ");            
            $data[]=$readTmp[0]->cantidadxmes;
            
        }      
        return json_encode($data);
    }
    public function getSalesxDay(){                
        $lastDay=date('d',strtotime('last day of this month', time()));
        $data=[];
        for($i=1;$i<=$lastDay;$i++){
            
            $readTmp=DB::SELECT("CALL sp_salesxday('$i')  ");            
            $data['cantidad'][$i]=$readTmp[0]->cantidadxdia;
            $data['label'][$i]=$i;
        }       
       return json_encode($data);
     }


     public function getUtilityMonth(){

        $data=[];
         for ($i=1;$i<=12;$i++){
             $readTmp=DB::SELECT("CALL sp_expenses_month('$i')  ");
             $tt=floatval($readTmp[0]->egreso+$readTmp[0]->nomina);
             
             $e=is_null($tt)? 0: $tt;  
             $data['expenses'][$i]= $e;

             
             $service=DB::SELECT("CALL sp_incomexservice('$i')  ");              
             $product=DB::SELECT("CALL sp_incomexproduct('$i')  "); 

             $s=is_null($product[0]->gananciasxproducto)? 0:floatval($product[0]->gananciasxproducto);
             $p=is_null($service[0]->gananciasxservicio)? 0: floatval($service[0]->gananciasxservicio);
             $data['income'][$i]=$s+$p;
         }      
         return json_encode($data);
     }
     public function chart_income_service(){
        $d=date('m');
        $product=DB::SELECT("CALL sp_incomexproduct('$d')  ");            
        $service=DB::SELECT("CALL sp_incomexservice('$d')  ");            
        
        $data=[];
        $data['product']= is_null($product[0]->gananciasxproducto)? 0:floatval($product[0]->gananciasxproducto);
        $data['service']=is_null($service[0]->gananciasxservicio)? 0: floatval($service[0]->gananciasxservicio);
        $data['total']=number_format(floatval($service[0]->gananciasxservicio)+floatval($product[0]->gananciasxproducto),0,',','.');
              
       return json_encode($data);
     }

     public function income_store($ini,$end){
       
       $dateini=date('Y-m-d',strtotime($ini));
       $dateend=date('Y-m-d',strtotime($end) );
       $product=DB::SELECT("CALL sp_incomexproduct_day('$dateini','$dateend')  ");            
        $service=DB::SELECT("CALL sp_incomexservice_day('$dateini','$dateend')  ");   
        
        $salett=DB::SELECT("CALL sp_incomexsales('$dateini','$dateend')  ");                    
        $data=[];
        
        

        $data['tt_prd']=  number_format(is_null($salett[0]->total_venta )? 0:floatval($salett[0]->total_venta ),0,',','.');
        $data['tt_prd_qq']=  is_null($salett[0]->cantidad )? 0:floatval($salett[0]->cantidad );
        $data['product']= number_format(is_null($product[0]->gananciasxproducto)? 0:floatval($product[0]->gananciasxproducto) ,0,',','.') ;
        $data['service']=number_format(is_null($service[0]->gananciasxservicio)? 0: floatval($service[0]->gananciasxservicio),0,',','.') ;
        $data['total']=number_format(floatval($service[0]->gananciasxservicio)+floatval($product[0]->gananciasxproducto),0,',','.');
              
       return json_encode($data);
     }

     public function dt_expenses_month(){    
        $d=date('m');    
        $expenses=DB::SELECT("CALL sp_expenses('$d')  ");                 
        $data=[];
        $i=0;
        $total=0;
        foreach($expenses as $key=> $v){
            $data['data'][$key]['no']=$i++;
            $data['data'][$key]['concepto']= $v->concepto;
            $data['data'][$key]['valor']=number_format($v->egreso,0,',','.');
            $total+=$v->egreso;
        }
        $data['total']= $total;
        return json_encode($data);       
     }
     public function add_expenses(){

     
        $obj= new EgresosMensuales();
        $obj->fecha=date('Y-m-d');
        $obj->id_concepto= intval(Request::input('id_concepto'));
        $obj->total_egreso=intval(Request::input('total_egreso'));        
        $obj->save();
        return 1;
     }

    public function concept_expenses(){

        return json_encode(EgresosConcepto::all());
    }

     

     
}
