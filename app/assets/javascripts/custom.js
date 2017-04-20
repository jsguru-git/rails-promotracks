$(document).ready(function () {
    $(".add_brands,.add_promo_reps").select2();


    $('#start_time').datetimepicker({
        useCurrent: false,
    }).on("dp.change", function (e) {
        $('#end_time').data("DateTimePicker").minDate(e.date);
    });

    $('#end_time').datetimepicker({}).on("dp.change", function (e) {
        $('#start_time').data("DateTimePicker").maxDate(e.date);
    });

    //$(".city").keyup(function () {
    //    var name=$(this);
    //    //delay( function () {
    //    //debugger
    //    var searchElement = $(".city");
    //    getAutoCompleteData($(".city").val(), function(results) {
    //        $(this).autocomplete({
    //            source: results,
    //            select: function (event, ui) {
    //                ['route', 'name', 'city', 'county', 'country', 'state', 'zip'].forEach(function (item) {
    //                    if (ui.item.value[item].length > 0) {
    //                        name.val(ui.item.value.city);
    //
    //                    }
    //                });
    //                return false;
    //            }
    //        });
    //    });
    //    //jQuery('.ui-autocomplete').css('z-index', 5000);
    //    // },2000);
    //});
});