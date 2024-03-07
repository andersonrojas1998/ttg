$(document).ready(function() {

    employmentList();


});


var employmentList=function(){

    $.ajax({
        url:"/rt_employmentList",
        type:"GET",
        dataType:"JSON",
        success:function(data) {
            
            for(let i=0;i<6;i++){   
                let logo=(data[i].logo=="")? 'logo_pordefecto.gif':data[i].logo;
                 $('.listEmployed').append('<div class="col-lg-4 grid-margin stretch-card">'+
                '<div class="card"> '+
                '<img class="rounded mx-auto d-block pt-2" src="/assets/enterprise/'+logo+'"  width="100" height="90">' +
                '<h4 class="visible-xs visible-md visible-lg  pt-4 ml-4">'+data[i].oferta+'</h4>'+   
                  '<div class="card-body"> <a href=""> '+  data[i].empresa +  ' - ' +  data[i].ciudad  + ' &nbsp; <i class="mdi mdi-map-marker"></i>'+
                    '<p class="text-muted"><i class="mdi mdi-timer"></i>  Publicado  '+data[i].fecha_publicacion+'</p>'+
                 ' </a>'+
                  '</div>'+
                  '<div class="card-footer text-muted"><div class="row"><div class="col-lg-8" style="color:orange"><b>'+data[i].rango  +' Millones</b> </div><div class="col-lg-4">'+data[i].modalidad+'  <i class="mdi mdi-google-maps"></i></div></div></div>'+
                '</div>'+
              '</div>')
            }                      
        }
    });    
}

function dt_employed(){

    $('#table-product').DataTable({
        dom: 'Bfrtip',
        destroy:true,
        buttons: ['excel', 'pdf'],
        ajax:{
            url:  '/enterprise/employmentList',
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
            {"data": "descripcion", render(data){ return '<p class="text-uppercase"> '+ data +'</p>' ;  } },            
            {"data": "empresa", render(data){ return '<a href="" class="text-uppercase"> '+ data +'</a>' ;  } },            
            {"data": "rango", render(data){ return '<p class="text-uppercase text-dark"> '+ data +'</p>' ;  } },            
            {"data": "fecha_publicacion", render(data){ return '<p class="text-uppercase"> '+ data +'</p>' ;  }},            
            {"data": "ciudad", render(data){ return '<p class="text-uppercase"> '+ data +'</p>' ;  }},            

            { "data": "estado",render(data){ 
                let color=(data="Disponible")? 'badge-success':'badge-warning';
                return '<h4><label class="badge text-white '+color+'">'+ data  +'</label></h4>';
             }},
             { "data": "postulados",render(data){                 
                return '<h4><label class="badge text-white badge-success">'+ data  +'</label></h4>';
             }},
        ],

        rowCallback:function(row,data,index){
            let cantidad=data.cantidad;
            switch(true){                
                case (parseInt(cantidad) >= 0 && parseInt(cantidad) <= 5):
                    $('td', row).css('background-color', 'rgba(238, 249, 71, 0.35)');
                break;                
            }
        }

    });
 }