//= require jquery
//= require jquery_ujs
//= require bootstrap/bootstrap-tooltip
//= require twitter/bootstrap
//= require bootstrap/bootstrap-tooltip
//= require_tree .
//= require jquery.validate
//= require jquery.validate.additional-methods

var ToggleMyrecords = function(){
    $('.hero-unit table').eq(0).toggle();
};

var ToggleAllRecords = function(){
    $('.hero-unit table').eq(1).toggle();
}
$(function(){
    $("a").tooltip();
})
jQuery.validator.addMethod("ipv4", function(value, element, param) {
    return this.optional(element) || /^(25[0-5]|2[0-4]\d|[01]?\d\d?)\.(25[0-5]|2[0-4]\d|[01]?\d\d?)\.(25[0-5]|2[0-4]\d|[01]?\d\d?)\.(25[0-5]|2[0-4]\d|[01]?\d\d?)$/i.test(value);
}, "<b style='color:red'>Неверный IP адрес</b>");



$(document).ready(function () {
    $("#new_record, #edit_record").on('change', "#record_record_type", function() {
        if($("#record_record_type").val() == "TXT") {
            $('#numeru').html('<textarea cols="40" id="record_ttl" name="record[data]" rows="20"></textarea>');
            $("#record_host").attr('readonly',false);
            return false;
        } else if($('#record_record_type').val() == "MX") {
            $('#numeru').html('<input id="record_data" name="record[data]" size="30" type="text">');
            $('#numeru').append('<label>Приоритет MX</label><input id="record_data" name="record[mx_priority]" size="30" type="text">');
            $("#record_host").attr('readonly',false);
            return false;
        }else if($('#record_record_type').val() == "NS") {
            $("#record_host").attr('readonly','readonly');
            $('#numeru').html('<input id="record_data" name="record[data]" size="30" type="text">');
            return false;
        } else {
            $('#numeru').html('<input id="record_data" name="record[data]" size="30" type="text">');
            $("#record_host").attr('readonly',false);
            return false;
        };
    });

    $("#new_record").on("focus", "#record_data", (function() {
        $(function(){ if($("#record_record_type").val() == "A") {boolval = true } else {boolval = false}});
        $("#new_record").validate({
            errorPlacement: function(error, element) {
                $("#record_data").addClass('.error');
                error.insertBefore('#record_data');
            },
            rules: {
                "record[data]": {
                    ipv4: {
                        depends:function() {
                            if ($("#record_record_type").val() == "A"){
                                return true;
                            }else{
                                return false;
                            }
                        }
                    }
                }
            }
        });
    }));
    $("#edit_record").on("focus", "#record_data", (function() {
        $(function(){ if($("#record_record_type").val() == "A") {boolval = true } else {boolval = false}});
        $("#edit_record").validate({
            errorPlacement: function(error, element) {
                $("#record_data").addClass('.error');
                error.insertBefore('#record_data');
            },
            rules: {
                "record[data]": {
                    ipv4: {
                        depends:function() {
                            if ($("#record_record_type").val() == "A"){
                                return true;
                            }else{
                                return false;
                            }
                        }
                    }
                }
            }
        });
    }));
});

