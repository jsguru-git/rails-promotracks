$(document).on('turbolinks:load', function () {

    $(".add_brands,.add_promo_reps").select2();


    $('#start_time').datetimepicker({
        useCurrent: false,
    }).on("dp.change", function (e) {
        $('#end_time').data("DateTimePicker").minDate(e.date);
    });

    $('#end_time').datetimepicker({}).on("dp.change", function (e) {
        $('#start_time').data("DateTimePicker").maxDate(e.date);
    });

    if ($('#promo_rep_button').is(':checked')) {
        $("#event_promo_category").val('promo_rep');
        $('#promo_reps').show();
        $('.promo_groups').hide();
    } else if ($('#promo_group_button').is(':checked')) {
        $("#event_promo_category").val('promo_group');
        $('#promo_reps').hide();
        $('.promo_groups').show();
    }
    $('#promo_rep_button').on("click", function () {
        $("#event_promo_category").val('promo_rep');
        $('#promo_reps').show();
        $('.promo_groups').hide();
    });

    $('#promo_group_button').on("click", function () {
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
});