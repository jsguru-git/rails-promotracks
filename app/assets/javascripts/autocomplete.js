var getAutoCompleteData = function (query) {
    var locations = [];
    if (query.length >= 3) {
        $.get("http://maps.googleapis.com/maps/api/geocode/json?address=" + query, function (data) {
            data.results.forEach(function (result) {
                locations.push({label: result.formatted_address, value: getAddressFromGoogleResponse(result)});
                //locations.push({label: result.formatted_address, value: result.formatted_address});
            });
        });
    }
    return locations;
};

var getAddressFromGoogleResponse = function (response) {
    var lat = response.geometry.location.lat;
    var lng = response.geometry.location.lng;
    var city = "";
    var state = "";
    var zip = "";
    var country = "";
    var county = "";
    var route = "";
    var formatted_address = response.formatted_address;
    ;
    console.log(response);
    response.address_components.forEach(function (addrComponent) {
        //console.log(addrComponent.types[0]);
        switch (addrComponent.types[0]) {
            case "route":
                route = addrComponent.long_name;
                break;
            case "locality":
                city = addrComponent.long_name;
                break;
            case "administrative_area_level_2":
                county = addrComponent.long_name;
                break;
            case "administrative_area_level_1":
                state = addrComponent.short_name;
                break;
            case "country":
                country = addrComponent.short_name;
                break;
            case "postal_code":
                zip = addrComponent.long_name;
                break;
            default:
                break;
        }
    });
    return {
        route: route,
        city: city,
        county: county,
        state: state,
        zip: zip,
        country: country,
        formatted_address: formatted_address,
        lat: lat,
        lng: lng
    };
};


