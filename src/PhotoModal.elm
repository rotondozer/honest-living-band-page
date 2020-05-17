module PhotoModal exposing (PhotoModal(..), imageSrc, photos, toModalVisibility)

import Bootstrap.Modal as Modal


type PhotoModal
    = Shown String
    | Hidden


photos : List String
photos =
    [ "as220_black_and_white.jpg"
    , "davids_axes.jpg"
    , "dusk_blurry_and_reddish.jpg"
    , "louie_sticker.jpg"
    , "nick_david_blurry_beer.jpg"
    , "setlist_w_tunings.jpg"
    , "practice_black_white_from_behind_drums.jpg"
    , "nick_david_mass_pike.jpg"
    , "practice_flannels_and_stick_motion.jpg"
    , "smithfield_barn.jpg"
    , "nick_recording.jpg"
    ]


toModalVisibility : PhotoModal -> Modal.Visibility
toModalVisibility photoModal =
    case photoModal of
        Shown _ ->
            Modal.shown

        Hidden ->
            Modal.hidden


imageSrc : PhotoModal -> String
imageSrc photoModal =
    case photoModal of
        Shown src ->
            "../assets/images/" ++ src

        Hidden ->
            ""
