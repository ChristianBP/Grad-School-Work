$(document).ready(function() {
    if (document.cookie.includes('userInfo')) {
        const cookieValue = decodeURIComponent(document.cookie
            .split('; ')
            .find(row => row.startsWith('userInfo='))
            .split('=')[1]
        );

        const { phoneNumber } = JSON.parse(cookieValue);

        if (phoneNumber === '222-222-2222') {
            $('#admin-panel').show();

            $('#load-flights').click(() => {
                $.post('php/admin/load_flights.php', () => alert('Flights loaded successfully!'));
            });

            $('#load-hotels').click(() => {
                $.post('php/admin/load_hotels.php', () => alert('Hotels loaded successfully!'));
            });

            $('#sep-to-oct-flights').click(() => {
                $.get('php/admin/sep_to_oct_flights.php',
                    sepToOctFlights =>
                        $(sepToOctFlights).dialog({
                            title: 'Flights Departing Texas Booked in September and October',
                            modal: true,
                            dialogClass: 'text-center',
                            buttons: {
                                Ok: function () {
                                    $(this).dialog('close');
                                }
                            }
                        })
                );
            });

            $('#sep-to-oct-hotels').click(() => {
                $.get('php/admin/sep_to_oct_hotels.php',
                    sepToOctHotels =>
                        $(sepToOctHotels).dialog({
                            title: 'Texas Hotels Booked in September and October',
                            modal: true,
                            dialogClass: 'text-center',
                            buttons: {
                                Ok: function () {
                                    $(this).dialog('close');
                                }
                            }
                        })
                );
            });

            $('#expensive-hotels').click(() => {
                $.get('php/admin/expensive_hotels.php',
                    expensiveHotels =>
                        $(expensiveHotels).dialog({
                            title: 'Top 3 Expensive Hotels',
                            modal: true,
                            dialogClass: 'text-center',
                            buttons: {
                                Ok: function () {
                                    $(this).dialog('close');
                                }
                            }
                        })
                );
            });

            $('#infant-flights').click(() => {
                $.get('php/admin/infant_flights.php',
                    infantFlights =>
                        $(infantFlights).dialog({
                            title: 'Flights with Infants',
                            modal: true,
                            dialogClass: 'text-center',
                            buttons: {
                                Ok: function () {
                                    $(this).dialog('close');
                                }
                            }
                        })
                );
            });

            $('#infant-child-flights').click(() => {
                $.get('php/admin/infant_child_flights.php',
                    infantChildFlights =>
                        $(infantChildFlights).dialog({
                            title: 'Flights with an Infant and at Least 5 Children',
                            modal: true,
                            dialogClass: 'text-center',
                            buttons: {
                                Ok: function () {
                                    $(this).dialog('close');
                                }
                            }
                        })
                );
            });

            $('#expensive-flights').click(() => {
                $.get('php/admin/expensive_flights.php',
                    expensiveFlights =>
                        $(expensiveFlights).dialog({
                            title: 'Top 3 Expensive Flights',
                            modal: true,
                            dialogClass: 'text-center',
                            buttons: {
                                Ok: function () {
                                    $(this).dialog('close');
                                }
                            }
                        })
                );
            });

            $('#texas-no-infant-flights').click(() => {
                $.get('php/admin/texas_no_infant_flights.php',
                    texasNoInfantFlights =>
                        $(texasNoInfantFlights).dialog({
                            title: 'Flights from Texas with No Infants',
                            modal: true,
                            dialogClass: 'text-center',
                            buttons: {
                                Ok: function () {
                                    $(this).dialog('close');
                                }
                            }
                        })
                );
            });

            $('#california-flights').click(() => {
                $.get('php/admin/california_flights.php',
                    californiaFlights =>
                        $(californiaFlights).dialog({
                            title: 'Number of Booked Flights to California in September or October',
                            modal: true,
                            dialogClass: 'text-center',
                            buttons: {
                                Ok: function () {
                                    $(this).dialog('close');
                                }
                            }
                        })
                );
            });
        }

        $('#flights-by-booking-id').click(() => {
            $.get('php/my-account/flights_by_booking_id.php',
                {
                    bookingId: $('#flight-booking-id').val()
                },
                flightsByBookingId =>
                    $(flightsByBookingId).dialog({
                        title: 'Flights by Booking ID',
                        modal: true,
                        dialogClass: 'text-center',
                        buttons: {
                            Ok: function () {
                                $(this).dialog('close');
                            }
                        }
                    })
            );
        });

        $('#hotels-by-booking-id').click(() => {
            $.get('php/my-account/hotels_by_booking_id.php',
                {
                    bookingId: $('#hotel-booking-id').val()
                },
                hotelsByBookingId =>
                    $(hotelsByBookingId).dialog({
                        title: 'Hotels by Booking ID',
                        modal: true,
                        dialogClass: 'text-center',
                        buttons: {
                            Ok: function () {
                                $(this).dialog('close');
                            }
                        }
                    })
            );
        });

        $('#flight-passengers-by-booking-id').click(() => {
            $.get('php/my-account/flight_passengers_by_booking_id.php',
                {
                    bookingId: $('#passenger-booking-id').val()
                },
                passengersByBookingId =>
                    $(passengersByBookingId).dialog({
                        title: 'Passengers by Booking ID',
                        modal: true,
                        dialogClass: 'text-center',
                        buttons: {
                            Ok: function () {
                                $(this).dialog('close');
                            }
                        }
                    })
            );
        });

        $('#booked-flights-sep').click(() => {
            $.get('php/my-account/booked_flights_sep.php',
                bookedFlightsSep =>
                    $(bookedFlightsSep).dialog({
                        title: 'Booked Flights in September',
                        modal: true,
                        dialogClass: 'text-center',
                        buttons: {
                            Ok: function () {
                                $(this).dialog('close');
                            }
                        }
                    })
            );
        });

        $('#booked-hotels-sep').click(() => {
            $.get('php/my-account/booked_hotels_sep.php',
                bookedHotelsSep =>
                    $(bookedHotelsSep).dialog({
                        title: 'Booked Hotels in September',
                        modal: true,
                        dialogClass: 'text-center',
                        buttons: {
                            Ok: function () {
                                $(this).dialog('close');
                            }
                        }
                    })
            );
        });

        $('#booked-flights-by-ssn').click(() => {
            $.get('php/my-account/booked_flights_by_ssn.php',
                {
                    ssn: $('#ssn').val()
                },
                bookedFlightsBySsn =>
                    $(bookedFlightsBySsn).dialog({
                        title: 'Booked Flights by SSN',
                        modal: true,
                        dialogClass: 'text-center',
                        buttons: {
                            Ok: function () {
                                $(this).dialog('close');
                            }
                        }
                    })
            );
        });
    }
});