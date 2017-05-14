$(document).on('turbolinks:load', function () {

    var URL = $(location).attr('href');

    $(".add_brands,.add_promo_reps").select2({
        allowClear: true,
        closeOnSelect: false,
        placeholder: "Nothing Selected"
    });

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


    $('#check_in_time').datetimepicker();
    $('#check_out_time').datetimepicker({
        useCurrent: false //Important! See issue #1075
    });
    $("#check_in_time").on("dp.change", function (e) {
        $('#check_out_time').data("DateTimePicker").minDate(e.date);
    });
    $("#check_out_time").on("dp.change", function (e) {
        $('#check_in_time').data("DateTimePicker").maxDate(e.date);
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
    var promo_id = '';
    var search_type = '';
    $(".search_rep").autocomplete({
        source: '/admin/clients/reps_and_groups',
        minLength: 3,
        select: function (event, ui) {
            if (ui.item.type == "promo_rep") {
                promo_id = ui.item.id;
                search_type = ui.item.type;

            } else if (ui.item.type == "promo_group") {
                promo_id = ui.item.id;
                search_type = ui.item.type;
            }

            $.ajax({
                method: "GET",
                url: "/admin/events?promo_id=" + promo_id + "&search_type=" + search_type + "&search=" + true,
                dataType: 'json',
                success: function (data) {

                    $("#events").find("*").remove();
                    $("#events").append(data.html);
                    $("#events-footer").find("*").remove();
                    $("#events-footer").append(data.footer);
                }
            });
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

    $('.group_users').popover();
    $('[data-toggle="popover"]').popover();

    $('.selectpicker').selectpicker();
    $('.selectpicker').selectpicker('refresh');


    var status = $('#event_status').data('status');
    if (URL.includes("status=accept")) {
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
    else if (URL.includes("status=decline")) {
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


    $('#owl3').owlCarousel({
        items: 5,
        lazyLoad: true,
        loop: false,
        margin: 10,
        responsive: {
            0: {
                items: 1
            },
            600: {
                items: 2
            },
            1000: {
                items: 4
            }
        }
    });

    $("#order-select").on("change", function () {
        var item = $(this).val();
        $.ajax({
            method: "GET",
            url: "/admin/dashboard?sort_by=" + item,
            dataType: 'json',
            success: function (data) {
                $("#events_list").find("*").remove();
                $("#events_list").append(data.html);
            }
        });
    });


    //$(".images").unbind('click').on("click", function () {
    //    var id = $(this).data("id");
    //    var event=$(this).data("event");
    //
    //    $.ajax({
    //        method: "GET",
    //        url: "/admin/events/" + event+ "?uv="+id,
    //        dataType: 'json',
    //        success: function (data) {
    //            $('#myModal').modal({
    //                backdrop: 'static',
    //                keyboard: false,
    //                show: true
    //            });
    //        }
    //    });
    //
    //});


    $(".remove_image").click(function (event) {
        var event_id = $(this).attr('data-event');
        var uv_id = $(this).attr('data-uv');
        var item = $(this).attr('data-item');
        $.ajax({
            method: "DELETE",
            url: '/admin/events/' + event_id + '/user_events/' + uv_id + '/delete_image?index=' + item,
            dataType: 'json',
            success: function (data) {

            }
        });
        $('.image_' + item).find("*").remove();

    });


});