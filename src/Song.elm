module Song exposing (Song(..), imageSrc, previewLink, title)

-- Songs are stored in a personal google drive.
-- https://drive.google.com/open?id=1qKTDdmhHrC7_2p2l1IQta7d_YIJOyz3W Seasonal
-- https://drive.google.com/open?id=1L7YOr9L4gvARk6orSxbdkLflOWXfNKZF isswttd
-- https://drive.google.com/open?id=1xMRM-0heaytWptb66yFG0jyofXGI2AXD Hope and Olney
-- 1XHvfbaR5zQliqErhuTRua6UGfJoUinDt Closer


type Song
    = Seasonal
    | Isswttd
    | HopeAndOlney
    | NeverACloser


title : Song -> String
title song =
    case song of
        Seasonal ->
            "Seasonal"

        Isswttd ->
            "I should start writing these things down."

        HopeAndOlney ->
            "Hope and Olney"

        NeverACloser ->
            "Never a Closer"


imageSrc : Song -> String
imageSrc song =
    case song of
        Seasonal ->
            "../assets/images/leaf_changing_color.jpg"

        Isswttd ->
            "../assets/images/isswttd_david_recording.jpg"

        HopeAndOlney ->
            "../assets/images/pond_late_summer.jpg"

        NeverACloser ->
            "../assets/images/never_a_closer.jpg"


previewLink : Song -> String
previewLink song =
    case song of
        Seasonal ->
            "../assets/songs/seasonal.mp3"

        Isswttd ->
            "../assets/songs/i_should_start_writing_these_things_down.mp3"

        HopeAndOlney ->
            "../assets/songs/hope_and_olney.mp3"

        NeverACloser ->
            "../assets/songs/never_a_closer.mp3"
