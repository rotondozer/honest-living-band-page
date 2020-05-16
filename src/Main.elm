module Main exposing (init, main)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Modal as Modal
import Bootstrap.Navbar as Navbar
import Browser
import Browser.Navigation as Navigation
import Html
import Html.Attributes exposing (class, controls, download, href, src, style)
import Html.Events exposing (onClick)
import Song
import Url
import Url.Parser as Parser



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


init : () -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        ( navbarState, navbarCmd ) =
            Navbar.initialState NavbarMsg
    in
    -- Can I use a Model constructor? i.e. ( { Model url key navbarState }, navbarCmd )
    ( { url = url
      , key = key
      , navbarState = navbarState
      , photoModal = Hidden
      }
    , navbarCmd
    )


type alias Model =
    { url : Url.Url
    , key : Navigation.Key
    , navbarState : Navbar.State
    , photoModal : PhotoModal
    }



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NavbarMsg Navbar.State
    | TogglePhotoModal PhotoModal


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Navigation.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Navigation.load href )

        UrlChanged url ->
            ( { model | url = url }, Cmd.none )

        NavbarMsg state ->
            ( { model | navbarState = state }, Cmd.none )

        TogglePhotoModal photoModalVisibility ->
            ( { model | photoModal = photoModalVisibility }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navbarState NavbarMsg



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Honest Living"
    , body =
        [ Html.div [ class "app-container" ]
            [ viewNavbar model
            , viewCurrentPage model
            ]
        ]
    }


viewNavbar : Model -> Html.Html Msg
viewNavbar model =
    Grid.container
        []
        [ Navbar.config NavbarMsg
            |> Navbar.withAnimation
            |> Navbar.dark
            |> Navbar.container
            |> Navbar.brand [ href "/" ] [ Html.text "Honest Living" ]
            |> Navbar.items
                [ Navbar.itemLink [ href "/About" ] [ Html.text "About" ]
                , Navbar.itemLink [ href "/Photos" ] [ Html.text "Photos" ]
                , Navbar.itemLink [ href "/Videos" ] [ Html.text "Videos" ]
                ]
            |> Navbar.view model.navbarState
        ]


viewCurrentPage : Model -> Html.Html Msg
viewCurrentPage model =
    case toRoute model.url of
        Home ->
            Grid.container []
                [ Grid.row []
                    [ viewSong Song.Seasonal
                    , viewSong Song.NeverACloser
                    ]
                , Grid.row []
                    [ viewSong Song.Isswttd
                    , viewSong Song.HopeAndOlney
                    ]
                ]

        About ->
            Grid.container []
                [ Html.div [ class "jumbotron" ]
                    [ Html.h3 [ class "headline" ] [ Html.text "Heavily inspired by mid 90s - early 2000s emo" ]
                    , Html.h4 [] [ Html.text "Guitar: David Marcotte" ]
                    , Html.h4 [] [ Html.text "Drums: Nick Rotondo" ]
                    , Html.h4 [ style "margin-bottom" "30px" ] [ Html.text "Home: Providence,  Rhode Island" ]
                    , Html.p []
                        [ Html.text "Twinkley riffs in weird time signatures \\\\\\\\" -- these render as `\\\\`
                        , Html.text " American Football inspired open guitar tuning \\\\\\\\"
                        , Html.text " half time all the time \\\\\\\\"
                        , Html.text " quiet/loud/quiet/loud \\\\\\\\"
                        , Html.text " sometimes chugging and palm muted stuff \\\\\\\\"
                        , Html.text " lots of nick and david geeking out when they do that cool thing at the same time."
                        , Html.hr [] []
                        , Html.text "We recorded one EP together in 2016, which was never actually released. This here is the rough EP - just as we would perform it live."
                        , Html.text "There is a more polished version of the EP that also has David playing bass and singing! We'll get that up here soon, too."
                        ]
                    ]
                ]

        Photos ->
            Grid.container []
                [ Grid.row []
                    ((bandPhotos |> List.map viewPhotoThumbnail)
                        ++ (model.photoModal |> viewPhotoModal |> List.singleton)
                    )
                ]

        Videos ->
            Grid.container [] [ Html.div [ class "jumbotron" ] [ Html.text "Videos Coming Soon!" ] ]


viewSong : Song.Song -> Grid.Column Msg
viewSong song =
    Grid.col []
        [ Html.div
            [ class "song-container", style "background-image" ("url(" ++ Song.imageSrc song ++ ")") ]
            [ Html.div [ class "song-title" ] [ Html.text (Song.title song) ]
            , Html.div [ class "audio-player-container" ]
                [ Html.audio
                    [ src (Song.audioSrc song), controls True, class "audio-player" ]
                    []
                , Html.a
                    [ href (Song.audioSrc song), download (Song.title song), class "download-icon-button" ]
                    []
                ]
            ]
        ]


viewPhotoThumbnail : String -> Grid.Column Msg
viewPhotoThumbnail imageSrc =
    Grid.col [ Col.sm6 ]
        [ Html.img
            [ src ("../assets/images/" ++ imageSrc)
            , onClick (TogglePhotoModal (Shown imageSrc))
            , class "photo"
            ]
            []
        ]


viewPhotoModal : PhotoModal -> Grid.Column Msg
viewPhotoModal photoModal =
    Grid.col []
        [ Modal.config (TogglePhotoModal Hidden)
            |> Modal.scrollableBody True
            |> Modal.body []
                [ Html.img
                    [ src (photoModalSrc photoModal), class "photo" ]
                    []
                ]
            |> Modal.view (toModalVisibility photoModal)
        ]



-- BAND PHOTOS


type PhotoModal
    = Shown String
    | Hidden


bandPhotos : List String
bandPhotos =
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


photoModalSrc : PhotoModal -> String
photoModalSrc photoModal =
    case photoModal of
        Shown src ->
            "../assets/images/" ++ src

        Hidden ->
            ""



-- ROUTES


type Route
    = Home
    | About
    | Photos
    | Videos


routeParser : Parser.Parser (Route -> a) a
routeParser =
    Parser.oneOf
        [ Parser.map Home Parser.top
        , Parser.map About (Parser.s "About")
        , Parser.map Photos (Parser.s "Photos")
        , Parser.map Videos (Parser.s "Videos")
        ]


toRoute : Url.Url -> Route
toRoute url =
    Maybe.withDefault Home (Parser.parse routeParser url)
