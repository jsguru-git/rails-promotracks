$(document).on('turbolinks:load', function () {

    $(".add_brands,.add_promo_reps").select2({
        allowClear: true,
        closeOnSelect: false,
        placeholder: "Nothing Selected"
    });

    //$('#start_time')
    //    .datetimepicker(start_date_props)
    //    .on("dp.change", function (e) {
    //        $('#end_time').data("DateTimePicker").minDate(e.date);
    //    });
    //$('#end_time')
    //    .datetimepicker(end_date_props)
    //    .on("dp.change", function (e) {
    //        $('#start_time').data("DateTimePicker").maxDate(e.date);
    //    });

    $('#start_time').datetimepicker();
    $('#end_time').datetimepicker({
        useCurrent: false //Important! See issue #1075
    });
    $("#start_time").on("dp.change", function (e) {
        $('#end_time').data("DateTimePicker").minDate(e.date);
    });
    $("#end_time").on("dp.change", function (e) {
        $('#start_time').data("DateTimePicker").maxDate(e.date);
    });




    $(".city").keyup(function () {
        $(this).autocomplete({
            source: getAutoCompleteData(this.value),
            select: function (event, ui) {

                ['route', 'city', 'county', 'country', 'state', 'zip'].forEach(function (item) {
                    if (ui.item.value[item].length > 0) {
                        var cityVal = ui.item.value.city;
                        var stateVal = ui.item.value.state;
                        var countryVal = ui.item.value.country;
                        var zipVal = ui.item.value.zip;
                        var routeVal = ui.item.value.route;
                        var countyVal = ui.item.value.county;
                        $('.latitude').val(ui.item.value.lat);
                        $('.longitude').val(ui.item.value.lng);
                        $(".formatted_address").val(ui.item.value.formatted_address);


                        if (cityVal == '') {
                            $('.city').val('');
                        }
                        else {
                            $(".city").val(cityVal);
                        }

                        if (zipVal == '') {
                            $('.zip').val('');
                        }
                        else {
                            $(".zip").val(zipVal);
                        }

                        if (countryVal == '') {
                            $('.country').val('');
                        }
                        else {
                            $(".country").val(countryVal);

                        }

                        if (stateVal == '') {
                            $('.state').val('');
                        }
                        else {
                            $(".state").val(stateVal);

                        }

                    }
                });
                return false;
            }
        });
        //jQuery('.ui-autocomplete').css('z-index', 5000);
    });
    $(".search_rep").autocomplete({
        source: '/admin/clients/reps_and_groups',
        minLength: 3,
        select: function (event, ui) {
            if (ui.item.type == "promo_rep") {
                $('#promo_id').val(ui.item.id);
                $('#search_type').val(ui.item.type);
            } else if (ui.item.type == "promo_group") {
                $('#promo_id').val(ui.item.id);
                $('#search_type').val(ui.item.type);
            }
        }
    });
    //Form Validation
    $('#form-validation').validate({
        submit: {
            settings: {
                inputContainer: '.form-group',
                errorListClass: 'form-control-error',
                errorClass: 'has-danger'
            }
        }
    });

    //Show/Hide Password
    $('.password').password({
        eyeClass: '',
        eyeOpenClass: 'icmn-eye',
        eyeCloseClass: 'icmn-eye-blocked'
    });

    $('#us-phone-mask-input').mask('(000) 000-0000', {placeholder: "(___) ___-____"});


    $('[data-toggle="popover"]').popover();

    $('.selectpicker').selectpicker();
    $('.selectpicker').selectpicker('refresh');



    var URL = $(location).attr('href');

    var status = $('#event_status').data('status');
    if (URL.contains("status=accept")) {
        swal({
            title: "Thank You",
            text: status,
            type: "success",
            confirmButtonClass: "btn-success",
            confirmButtonText: "Close"
        });
        $(document).click(function () {
            window.close()
        });
        setTimeout(function () {
            window.close();
        }, 6000);

    }
    else if (URL.contains("status=decline")) {
        swal({
            title: status,
            text: "Thank you for your response!",
            type: "error",
            confirmButtonClass: "btn-danger",
            confirmButtonText: "Close"
        });
        $(document).click(function () {
            window.close()
        });
        setTimeout(function () {
            window.close();
        }, 6000);

    }

});