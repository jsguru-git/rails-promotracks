var getAutoCompleteData = function (query, callback) {
    var geocoder = new google.maps.Geocoder;
    if (query.length > 2) {
        geocoder.geocode({
            'address': query,
            "newForwardGeocoder": false,
            componentRestrictions: {
                country: 'US'
            }
        }, function (results) {
            var locations = [];
            if (results != null) {
                results.forEach(function (result) {
                    locations.push({label: result.formatted_address, value: getAddressFromGoogleResponse(result)});
                });
            }
            callback(locations);
        });
    }
};

var getAddressFromGoogleResponse = function (response) {
    var address = {
        lat: response.geometry.location.lat,
        lng: response.geometry.location.lng,
        city: "",
        state: "",
        zip: "",
        country: "",
        county: "",
        route: "",
        name: ""
    };
    response.address_components.forEach(function (addrComponent) {

        switch (addrComponent.types[0]) {
            case "route":
                address.route = addrComponent.long_name;
                break;
            case "locality":
                address.city = addrComponent.long_name;
                break;
            case "administrative_area_level_2":
                address.county = addrComponent.long_name;
                break;
            case "administrative_area_level_1":
                address.state = addrComponent.short_name;
                break;
            case "country":
                address.country = addrComponent.short_name;
                break;
            case "postal_code":
                address.zip = addrComponent.long_name;
                break;
            case "establishment":
                address.name = addrComponent.long_name;
                break;
            default:
                break;
        }
    });

    return address;
};


