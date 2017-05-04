$(document).on('turbolinks:load', function () {

    $(".add_brands,.add_promo_reps").select2({
        allowClear: true,
        closeOnSelect: false,
        placeholder: "Nothing Selected"
    });

    //var start_date_props = {
    //    format: 'MM/DD/YYYY hh:mm A',
    //    minDate: new Date()
    //};
    //var start_date = "";
    //
    //var end_date_props = {
    //    format: 'MM/DD/YYYY hh:mm A'
    //};
    //end_date_props.useCurrent = false;
    //var end_date = "";
    //
    //if (end_date != "") {
    //
    //    end_date_props.defaultDate = end_date;
    //
    //    start_date_props.maxDate = end_date;
    //}
    //
    //if (start_date != "") {
    //    start_date_props.defaultDate = start_date;
    //    end_date_props.minDate = start_date;
    //}

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

    $('#start_time').datetimepicker({
        minDate: new Date()
    }).on("dp.change", function (e) {
        $('#end_time').data("DateTimePicker").minDate(e.date);
    });

    $('#end_time').datetimepicker({}).on("dp.change", function (e) {
        $('#start_time').data("DateTimePicker").maxDate(e.date);
    });

    if ($('#promo_rep_button').is(':checked')) {
        $('#event_user_ids').prop('required', true);
        $('#event_group_id').prop('required', false);
        $("#event_promo_category").val('promo_rep');
        $('#promo_reps').show();
        $('.promo_groups').hide();
    } else if ($('#promo_group_button').is(':checked')) {
        $('#event_user_ids').prop('required', false);
        $('#event_group_id').prop('required', true);
        $("#event_promo_category").val('promo_group');
        $('#promo_reps').hide();
        $('.promo_groups').show();
    }
    $('#promo_rep_button').on("click", function () {
        $('#event_user_ids').prop('required', true);
        $('#event_group_id').prop('required', false);
        $("#event_promo_category").val('promo_rep');
        $('#promo_reps').show();
        $('.promo_groups').hide();
    });

    $('#promo_group_button').on("click", function () {
        $('#event_user_ids').prop('required', false);
        $('#event_group_id').prop('required', true);
        $("#event_promo_category").val('promo_group');
        $('#promo_reps').hide();
        $('.promo_groups').show();
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
});