module Main exposing (init, main)

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
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
            [ CDN.stylesheet -- Does Elm have something akin to `if (__DEV__)`?
            , viewNavbar model
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
                (List.map viewPhotoThumbnail bandPhotos
                    ++ List.singleton (viewPhotoModal model)
                )

        Videos ->
            Grid.container [] [ Html.div [ class "jumbotron" ] [ Html.text "Videos Coming Soon!" ] ]


viewSong : Song.Song -> Grid.Column Msg
viewSong song =
    -- TODO: Move these styles to stylesheet
    Grid.col []
        [ Html.div
            [ style "display" "flex"
            , style "flex" "1"
            , style "flex-direction" "column"
            , style "justify-content" "space-between"
            , style "align-items" "center"
            , style "padding" "10px"
            , style "margin" "5px"
            , style "border" "2px solid #946e38"
            , style "border-radius" "3px"
            , style "background-image" ("url(" ++ Song.imageSrc song ++ ")")
            , style "background-size" "100% 100%"
            , style "height" "auto"
            , style "min-height" "300px"
            ]
            [ Html.div
                [ style "color" "white"
                , style "text-shadow" "1px 1px 2px #272B30"
                , style "align-self" "flex-end"
                ]
                [ Html.text (Song.title song) ]
            , Html.div [ style "display" "flex", style "align-items" "center" ]
                [ Html.audio [ src (Song.audioSrc song), controls True, style "flex" "85" ] []
                , Html.a
                    [ href (Song.audioSrc song)
                    , download (Song.title song) -- <-- I don't think this is actually used for the download
                    , style "flex" "15"
                    , style "margin" "3px"
                    , style "background-image" "url(../assets/icons/download_icon.png)"
                    , style "background-size" "100% 100%"
                    , style "background-color" "rgb(255, 255, 255, 0.3)"
                    , style "border" "1px solid #946e38"
                    , style "height" "50px"
                    , style "width" "50px"
                    , style "border-radius" "50px"
                    ]
                    []
                ]
            ]
        ]


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


viewPhotoThumbnail : String -> Html.Html Msg
viewPhotoThumbnail src =
    Html.button
        [ onClick (TogglePhotoModal (Shown src))
        , style "background-image" ("url(../assets/images/" ++ src ++ ")")
        , style "background-size" "100% 100%"
        , style "height" "auto"
        , style "min-height" "300px"
        , style "width" "33%"
        ]
        []


viewPhotoModal : Model -> Html.Html Msg
viewPhotoModal model =
    Modal.config (TogglePhotoModal Hidden)
        |> Modal.scrollableBody True
        |> Modal.body []
            [ Html.img
                [ src (photoModalSrc model.photoModal)
                , style "height" "auto"
                , style "max-width" "100%"
                ]
                []
            ]
        |> Modal.view (toModalVisibility model.photoModal)



-- BAND PHOTOS


type PhotoModal
    = Shown String
    | Hidden


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
