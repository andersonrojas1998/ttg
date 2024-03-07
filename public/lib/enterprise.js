$(document).ready(function() {

    if($('#table-enterprise').length>0){
        dt_employed();
    }    

    if($('.sel-type_doc').length>0 ){
        $.ajax({ url:"/typeDoc",type:"GET",success:function(data){
          let arr=JSON.parse(data);
          for(let i=0;i<arr.length;i++){                    
              $('.sel-type_doc').append('<option   value="'+arr[i].id+'" >'+ arr[i].descripcion  +'</option>');              
          }
          $('.sel-type_doc').select2();          
      }
      });
    }
    if($('.sel-area').length>0 ){
        $.ajax({ url:"/enterprise/area",type:"GET",success:function(data){
          let arr=JSON.parse(data);
          for(let i=0;i<arr.length;i++){                    
              $('.sel-area').append('<option   value="'+arr[i].id+'" >'+ arr[i].descripcion  +'</option>');              
          }
          $('.sel-area').select2();          
      }
      });
    }

    if($('.sel-range').length>0 ){
        $.ajax({ url:"/enterprise/range",type:"GET",success:function(data){
          let arr=JSON.parse(data);
          for(let i=0;i<arr.length;i++){                    
              $('.sel-range').append('<option   value="'+arr[i].id+'" >'+ arr[i].valor  +'</option>');              
          }
          $('.sel-range').select2();          
      }
      });
    }

    if($('.sel-city').length>0 ){
        $.ajax({ url:"/enterprise/city",type:"GET",success:function(data){
          let arr=JSON.parse(data);
          for(let i=0;i<arr.length;i++){                    
              $('.sel-city').append('<option   value="'+arr[i].id+'" >'+ arr[i].nombre  +'</option>');              
          }
          $('.sel-city').select2();          
      }
      });
    }
    if($('.sel-modality').length>0 ){
        $.ajax({ url:"/enterprise/modality",type:"GET",success:function(data){
          let arr=JSON.parse(data);
          for(let i=0;i<arr.length;i++){                    
              $('.sel-modality').append('<option   value="'+arr[i].id+'" >'+ arr[i].descripcion  +'</option>');              
          }
          $('.sel-modality').select2();          
      }
      });
    }

    $(document).on("change",".sel-area",function(){ 
        let v=$('.sel-area').val();
        $('.sel-position').empty();
        $.ajax({ url:"/enterprise/cargo/"+v,type:"GET",success:function(data){
            let arr=JSON.parse(data);
            for(let i=0;i<arr.length;i++){                    
                $('.sel-position').append('<option   value="'+arr[i].id+'" >'+ arr[i].nombre  +'</option>');              
            }
            $('.sel-position').select2();          
        }
        });
    });
    $(document).on("click",".btn_show_edit_ofert",function(){ 
        let v=$(this).attr('data-id');
        let st=$(this).attr('data-st');
        $('.id-ofert').val(v);
        $('.sel-status >option[value='+st+']').attr('selected',true).trigger('change');
    });

    $(document).on("click","#update-ofert",function(){ 
        let id=$('.id-ofert').val();
        let status=$('.sel-status').val();
       
        $.ajax({ url:"/enterprise/updateStatus/",data:{'id':id,'status':status}, type:"GET",success:function(data){
            sweetMessage('\u00A1Registro exitoso!', '\u00A1 Se ha realizado con \u00E9xito su solicitud!');
            setTimeout(function () { location.reload() }, 2000);    
        }
        });
    });
    
    $(document).on("click",".btn_show_show_candidate",function(){ 
        let v=$(this).attr('data-id');       
        $('.table-user-position>tbody').empty();
        $.ajax({ url:"/enterprise/listUser/"+v,type:"GET",success:function(data){
            let arr=JSON.parse(data);    
            for(let i=0;i<arr.length;i++){                 
                $('.table-user-position>tbody').append('<tr><td>'+arr[i].fecha_postulacion+'</td><td>'+arr[i].nombres  +' ' + arr[i].apellidos  + '</td><td><img src="/assets/enterprise/hv.jpg"></td> <td>'+arr[i].descripcion+'</td><td><i class="list-reference mdi mdi-account-circle text-info mdi-24px"  data-toggle="modal"  data-target="#modal_show_reference_candidate" ></i></td></tr>');
            }                         
        }
        });       
    });
    
    $(document).on("click",".list-reference",function(){ 
        $('.list-user').empty();
        $.ajax({ url:"/enterprise/getListUserApi",type:"GET",success:function(res){                         
            let r=res.data;
            for(let i=0;i<3;i++){
                $('.list-user').append('<div class="card" style="width: 10rem;">'+
                '<img class="card-img-top" src='+r[i].avatar+' alt="Card image cap">'+                
                '<div class="card-body"><div class="card-title">'+r[i].email+'</div>'+
                '<strong>'+r[i].first_name +  '  '+ r[i].last_name + '</strong>'+
                '</div>'+                                              
                '</div>');
            }                 
        }
        });       
    });


});



function dt_employed(){
    let id=$('.inp_hd_id').val();
  $('#table-enterprise').DataTable({
        dom: 'Bfrtip',
        destroy:false,
        buttons: ['excel', 'pdf'],
        ajax:{
            url:  '/enterprise/employmentList/'+id,
            method: "GET",
            headers: {'X-CSRF-TOKEN': $('meta[name="_token"]').attr('content')},
            dataSrc: function(json){               
                if(!json.data){
                    return [];
                } else {
                    return json.data;
                }
            }
        },
        columnDefs: [
            {"className": "text-center", "targets": "_all"},
        ],
        columns:[
            {"data": "con", render(data){ return '<b class="text-primary text-uppercase"> '+ data +'</b>' ;  }},
            {"data": "oferta", render(data){ return '<b class="text-primary text-uppercase"> '+ data +'</b>' ;  }},
            {"data": "descripcion", render(data){ return '<p class="text-muted"> '+ data.substring(0,50) +' ...</p>' ;  } },                        
            {"data": "rango", render(data){ return '<p class="text-uppercase text-dark"> <b>'+ data +'</b></p>' ;  } },            
            {"data": "fecha_publicacion", render(data){ return '<p class="text-uppercase"> '+ data +'</p>' ;  }},                        
            {"data": "ciudad", render(data){ return '<p class="text-uppercase"> '+ data +'</p>' ;  }},      
            {"data": "modalidad", render(data){ return '<p class="text-muted"> '+ data +'</p>' ;  }},            

            { "data": "postulados",render(data){                 
                return '<h4><label class="badge text-white badge-success">'+ data  +'</label></h4>';
             }},
             
            { "data": "estado",render(data){ 
                
                let color=(data=='Disponible')? 'badge-success':'badge-danger';

                return  '<h4><label class="badge text-white '+color+'">'+ data  +'</label></h4>';
             }},             
            {"data": "actions", render(data, ps, oferta){
                
                let div = $('<div>',{
                    html: 
                    [
                        $("<a>", {
                            class: "btn_show_edit_ofert",
                            html:$("<i>", {
                                class : "mdi mdi-pencil-box-outline text-primary mdi-24px",
                                title: "Cambiar Estado"
                            }).attr('data-toggle', 'tooltip')
                        }).attr({
                            'data-id': oferta.con, 
                            'data-st': oferta.estado_id,               
                            'data-toggle': 'modal',
                            'data-target': '#modal_edit_product',
                        }),    
                        $("<a>", {
                            class: "btn_show_show_candidate",
                            html:$("<i>", {
                                class : "mdi mdi-account-circle text-info mdi-24px",
                                title: "Mostrar Candidatos"
                            }).attr('data-toggle', 'tooltip')
                        }).attr({
                            'data-id': oferta.con,                             
                            'data-st': oferta.estado_id,               
                            'data-toggle': 'modal',
                            'data-target': '#modal_show_candidate',
                        }),
                    ]                                    
                });
                return div.html();
            }
        }
        ],

    });
 }