$(document).ready(function() {

    if($('.listEmploy').length){
      listEmploy();
    }  
    if($('.listEmployPostulated').length){
      listEmployPostulated();
    }
    
    
    $(document).on("click",".card-details",function(){ 
      let data=$(this).attr('data-id');
      $.ajax({
        url:"/employ/rt_employDetails/"+data,
        type:"GET",
        dataType:"JSON",
        success:function(data) {          
          let  status=(data[0].estado!="Disponible" ||  data[0].statusEmploy==1)? 'disabled':'';
          let  ps=(data[0].estado=="Disponible" &&  data[0].statusEmploy==0)? 'postulation':'';

          let msj=(data[0].statusEmploy==1)? 'Ya se Encuentra Postulado':'Postularme';
          $('.details').html('<div class="card">'+
          '<div class="card-header text-center">'+data[0].oferta+' <i class="mdi mdi-alarm-light text-danger"></i> &nbsp; <button class="btn  btn-warning btn-sm">'+data[0].postulados+'</button></div>'+
          '<div class="card-body">'+
          '<p>'+ data[0].empresa +'</p>'+
          '<p>'+data[0].ciudad+' -   '+  data[0].modalidad +'   <i class="mdi mdi-map-marker"></i></p> '+
          '<hr>'+
          '<strong class="m-1">Descripci&oacute;n general</strong>'+
          '<p class="text-muted">'+data[0].descripcion+'</p>'+
          '<hr>'+
          '<p class="text-muted">Tipo Contrato:  &nbsp;<b class="text-dark">'+data[0].tipo_contrato+'</b></p>'+
          '<hr>'+
          '<div class="col-lg-6"><button   class="btn btn-success  '+ps+'  btn-rounded '+status+'" data-id='+data[0].id+' data-id_enterprise='+data[0].id_enterprise+' data-desc='+data[0].oferta+' ">'+msj+'    <i class="mdi mdi-gesture-double-tap "></i></button></div>'+
          '</div>'+
          '</div>');
        }
      });         
    });  
    
    $(document).on("click",".postulation",function(){      
      let id=$(this).attr('data-id');
      let id_enterprise=$(this).attr('data-id_enterprise');
      let desc=$(this).attr('data-desc');
      Swal.fire({
          title: '\u00A1Atenci\u00f3n!',
          text: "Estas seguro que deseas Postularte como  "+ desc ,
          icon: 'warning',
          showCancelButton: true,
          confirmButtonColor: '#3085d6',
          cancelButtonColor: '#d33',
          confirmButtonText: 'Si, seguro'
        }).then((result) => {
          if (result.isConfirmed) {
              $.ajax({
                  url: '/employ/saveDetailsPostulation',                    
                  method: 'GET',
                  dataType: "JSON", 
                  data:{id:id,id_enter:id_enterprise},
              success: function(data){                          
                  sweetMessage('\u00A1Registro exitoso!', '\u00A1 Se ha realizado con \u00E9xito su solicitud!');                  
                  setTimeout(function () { location.reload() }, 2000);
               }
              });              
          }
        });
  });

});


var listEmploy=function(){
    $.ajax({
        url:"/rt_employmentList",
        type:"GET",
        dataType:"JSON",
        success:function(data) {                        
            for(let i=0;i<data.length;i++){   
               let  color=(data[i].estado=="Disponible")? "#0d0e0e":'#b92121';  
               let logo=(data[i].logo== 'null')? 'logo_pordefecto.gif':data[i].logo;             
                 $('.listEmploy').append('<div class="grid-margin stretch-card">'+                 
                '<div class="card card-details" data-id='+data[i].id +' style="border-radius:30px;"> '+
                '<img class="rounded mx-auto d-block " src="/assets/enterprise/'+logo+'"  width="150" height="150">' +
                '<h4 class="visible-xs visible-md visible-lg  pt-4 ml-4">'+data[i].oferta+'</h4>'+   
                  '<div class="card-body"> <a href=""> '+  data[i].empresa +  ' - ' +  data[i].ciudad  + ' &nbsp; <i class="mdi mdi-map-marker"></i></a>'+
                    '<p class="text-muted"><i class="mdi mdi-timer"></i>  Publicado  '+data[i].fecha_publicacion+'</p>'+
                    '<button class="btn btn-default text-white" style="background-color:'+color+';">'+data[i].estado+'</button>'+
                 ' </a>'+
                  '</div>'+
                  '<div class="card-footer text-muted"><div class="row"><div class="col-lg-8" style="color:orange"><b>'+data[i].rango  +' Millones</b> </div><div class="col-lg-4">'+data[i].modalidad+'  <i class="mdi mdi-google-maps"></i></div></div></div>'+
                '</div>'+
              '</div>')
            }                                 
        }
    });    
}

var listEmployPostulated=function(){

  $.ajax({
      url:"/employ/myPostulation",
      type:"GET",
      dataType:"JSON",
      success:function(data) {

          for(let i=0;i<data.length;i++){ 
            let logo=(data[i].logo== 'null')? 'logo_pordefecto.gif':data[i].logo;
               $('.listEmployPostulated').append('<div class="col-lg-4 grid-margin stretch-card">'+
              '<div class="card"> '+
              '<img class="rounded mx-auto d-block " src="/assets/enterprise/'+logo+'"  width="150" height="150">' +
              '<h4 class="visible-xs visible-md visible-lg  pt-4 ml-4">'+data[i].oferta+'</h4>'+   
                '<div class="card-body"> <a href=""> '+  data[i].empresa +  ' - ' +  data[i].ciudad  + ' &nbsp; <i class="mdi mdi-map-marker"></i></a>'+
                  '<p class="text-muted"><i class="mdi mdi-timer"></i>  Publicado  '+data[i].fecha_publicacion+'</p>'+
                  '<hr>'+                  
                  '<button class="btn btn-success"><i class="mdi mdi-led-on"></i> '+data[i].estado_postulado+'</button>'+                  
                  '<hr> '+
                  '<p class="text-muted">Cantidad participantes  <h4><span class="badge badge-primary badge-lg">'+data[i].postulados	+'</span></h4></p>'+
                '</div>'+
                '<div class="card-footer text-muted"><div class="row"><div class="col-lg-8" style="color:orange"><b>'+data[i].rango  +' Millones</b> </div><div class="col-lg-4">'+data[i].modalidad+'  <i class="mdi mdi-google-maps"></i></div></div></div>'+
              '</div>'+
            '</div>')
          }                      
      }
  });    
}