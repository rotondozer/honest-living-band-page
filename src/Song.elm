module Song exposing (Song(..), audioSrc, imageSrc, title)


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


audioSrc : Song -> String
audioSrc song =
    case song of
        Seasonal ->
            "../assets/songs/seasonal.mp3"

        Isswttd ->
            "../assets/songs/i_should_start_writing_these_things_down.mp3"

        HopeAndOlney ->
            "../assets/songs/hope_and_olney.mp3"

        NeverACloser ->
            "../assets/songs/never_a_closer.mp3"
