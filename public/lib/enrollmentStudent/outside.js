$(document).ready(function(){

    $('.select2').select2();
    var sweetMessage= function(title,msg,type='success'){
        swal.fire(title,msg,type);
    }
    var current_fs, next_fs, previous_fs;
    var opacity;
    var current = 1;
    var steps = $("fieldset").length;    
    setProgressBar(current);
    
    $(".next").click(function(e){
        e.preventDefault();                 
        if($("fieldset").index(next_fs) &&  
        $("#dni").val()==""  ||
        $('input[name="expedidoEn"]').val()=="" ||
        $("#tipo_doc").val()=="" ||        
        $('input[name="firstName"]').val()=="" ||
        $('input[name="firstLastName"]').val()=="" ||      
        $('input[name="dateBirthDay"]').val()=="" ||      
        $('#sel_grado').val()=="" ||
        $("#eps").val()=="" ||        
        $('input[name="direccion"]').val()==""  ||
        $("#barrio").val()==""  ||
        $("#tel").val()=="" ||
        $("#celular").val()=="" ||
        $('input[name="colegioProviene"]').val()=="" ||
        $('input[name="direccion"]').val()==""  ||
        $('input[name="ciudadColegioProviene"]').val()=="" ||
        $('input[name="nmHermanos"]').val()=="" ||
        $('input[name="lugarOcupa"]').val()=="" //||
        // ($('.switchEt').prop('checked') &&  $('input[name="grupo_etnico"]').val()=='undefined' )  ||
        //($('.switchDs').prop('checked') &&  $('input[name="tipo_discapacidad"]').val()== 'undefined')        
    ){        
    return  sweetMessage('\u00A1Atenci\u00f3n!','Por favor diligencia todos los campos obligatorios .','warning');
    }else{
        current_fs = $(this).parent();
        next_fs = $(this).parent().next();
        $("#progressbar li").eq($("fieldset").index(next_fs)).addClass("active");
        next_fs.show();
        current_fs.animate({opacity: 0}, {
        step: function(now) {
        opacity = 1 - now;        
        current_fs.css({
        'display': 'none',
        'position': 'relative'
        });
        next_fs.css({'opacity': opacity});
        },
        duration: 500
        });
        setProgressBar(++current);
    
    }


    
    });
    
    $(".previous").click(function(){
    
    current_fs = $(this).parent();
    previous_fs = $(this).parent().prev();
    
    //Remove class active
    $("#progressbar li").eq($("fieldset").index(current_fs)).removeClass("active");
    
    //show the previous fieldset
    previous_fs.show();
    
    //hide the current fieldset with style
    current_fs.animate({opacity: 0}, {
    step: function(now) {
    // for making fielset appear animation
    opacity = 1 - now;
    
    current_fs.css({
    'display': 'none',
    'position': 'relative'
    });
    previous_fs.css({'opacity': opacity});
    },
    duration: 500
    });
    setProgressBar(--current);
    });
    
    function setProgressBar(curStep){
    var percent = parseFloat(100 / steps) * curStep;
    percent = percent.toFixed();
    $(".progress-bar")
    .css("width",percent+"%")
    }
    
    /*$(".submit").click(function(){
    return false;
    })*/



    $(document).on("click",".switchDs",function() {
        if($(this).prop('checked')){
            $('.pnlDs').css('display','flex');
        }else{
            $('.pnlDs').css('display','none');
        }        
    });

    $(document).on("click",".switchEt",function() {
        if($(this).prop('checked')){
            $('.pnlEt').css('display','block');
        }else{
            $('.pnlEt').css('display','none');
        }        
    });

    $(document).on("blur","#dni",function() {
        let val=$(this).val();
        if(val!=""){
            $.ajax({
                url:"/matricula/searching/student/"+val,
                type:"get",
                data:{dni:val},
                dataType:"JSON",
                success:function(data) {                   
                    if(data.count>0){
                        $("#dni").val("");
                        sweetMessage('\u00A1Atenci\u00f3n!','El estudiante con la identificacion '+ val + ' ya se encuentra matriculado  .','warning');                        
                    }else if(data.alumno.length>0){
                        console.log(data.alumno);
                        $('input[name="expedidoEn"]').val(data.alumno[0].lugar_expedicion);
                        $('input[name="firstLastName"]').val(data.alumno[0].apellido1);
                        $('input[name="secondLastName"]').val(data.alumno[0].apellido2);
                        $('input[name="firstName"]').val(data.alumno[0].nombre1);
                        $('input[name="secondName"]').val(data.alumno[0].nombre2);
                        $('input[name="direccion"]').val(data.alumno[0].direccion);

                        $('input[name="dateBirthDay"]').val(data.alumno[0].fecha_nacimiento);

                        $('#tel').val(data.alumno[0].telefono);
                        $('#celular').val(data.alumno[0].celular);                                                
                        $('#barrio>option[value='+data.alumno[0].id_barrio+']').attr('selected',true).trigger('change');            
                        $('#eps>option[value='+data.alumno[0].id_tipo_eps+']').attr('selected',true).trigger('change');             
                        $('#sexo>option[value='+data.alumno[0].genero+']').attr('selected',true).trigger('change');                                   
                        $('#tipo_doc>option[value='+data.alumno[0].id_tipo_doc+']').attr('selected',true).trigger('change');                           
                        $('#tipo_matricula>option[value='+3+']').attr('selected',true).trigger('change');   
                        
                    }
                }
            });
        }
    }); 
    
    
    $(document).on("blur","#dniPadre",function() {   

        let val=$(this).val();
        if(val!=""){
            $.ajax({
                url:"/matricula/searching/father/"+val,
                type:"get",                
                dataType:"JSON",
                success:function(data) {                                                           
                        $('input[name="nombrePadre"]').val(data[0].nombre);                        
                        $('input[name="direccionPadre"]').val(data[0].direccion);
                        $('input[name="profesionPadre"]').val(data[0].profesion);
                        $('input[name="empresaPadre"]').val(data[0].empresa);                        
                        $('input[name="celPadre"]').val(data[0].telefono);
                        $('#barrioPadre>option[value='+data[0].barrio_id+']').attr('selected',true).trigger('change');                                                                                
                }
            });
        }
    });
    
    $(document).on("blur","#ccAcudiente",function() {   

        let val=$(this).val();
        if(val!=""){
            $.ajax({
                url:"/matricula/searching/father/"+val,
                type:"get",                
                dataType:"JSON",
                success:function(data) {                                                           
                        $('input[name="nameAcudiente"]').val(data[0].nombre);                        
                        $('input[name="celAcudiente"]').val(data[0].telefono);
                        $('input[name="dirAcudiente"]').val(data[0].direccion);                                                
                        $('#barrioAcudiente>option[value='+data[0].barrio_id+']').attr('selected',true).trigger('change');                                                                                
                        $('#parentesco>option[value='+data[0].id_tipo_parentesco+']').attr('selected',true).trigger('change');
                        
                }
            });
        }
    });
    $(document).on("blur","#dniMadre",function() {   

        let val=$(this).val();
        if(val!=""){
            $.ajax({
                url:"/matricula/searching/father/"+val,
                type:"get",                
                dataType:"JSON",
                success:function(data) {                                                           
                        $('input[name="nombreMadre"]').val(data[0].nombre);                        
                        $('input[name="direccionMadre"]').val(data[0].direccion);
                        $('input[name="profesionMadre"]').val(data[0].profesion);
                        $('input[name="empresaMadre"]').val(data[0].empresa);                        
                        $('input[name="celMadre"]').val(data[0].telefono);
                        $('#barrioMadre>option[value='+data[0].barrio_id+']').attr('selected',true).trigger('change');                                                                                
                }
            });
        }
    });

    $(document).on("click","#btn_saveEnrollement",function(e) { 
                
        if( $('#ccAcudiente').val()!="" &&  $('input[name="nameAcudiente"]').val()!=""  && 
            $('#parentesco').val()!=""  &&  $('input[name="celAcudiente"]').val()!=""   &&
            $('input[name="dirAcudiente"]').val()!="" &&  $('#barrioAcudiente').val()!=""
        ){            
            var data = new FormData($('#msform')[0]);
            $.ajax({
                type: 'POST',
                url:'/matricula/storeEnrollement',
                data: data,                                               
                contentType: false,
                processData: false,                      
                headers:{ 'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content') },
            success: function(data){
                    sweetMessage('\u00A1Registro exitoso!', '\u00A1 Se ha realizado con \u00E9xito su solicitud!'); 
                    location.replace('/matricula/inicio');                    
                }
            });

        }else{
            return  sweetMessage('\u00A1Atenci\u00f3n!','Por favor diligencia todos los campos obligatorios .','warning');            
        }
               
            
            });


    });






