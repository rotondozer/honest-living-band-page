module Main exposing (init, main)

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar
import Browser
import Browser.Navigation as Navigation
import Html
import Html.Attributes exposing (class, controls, href, src, style)
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
      }
    , navbarCmd
    )


type alias Model =
    { url : Url.Url
    , key : Navigation.Key
    , navbarState : Navbar.State
    }



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NavbarMsg Navbar.State


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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navbarState NavbarMsg



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Honest Living"
    , body =
        [ Html.div [ style "background-color" "#272B30", style "font-family" "'Amatic SC', monospace" ]
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
            |> Navbar.brand [ href "/Home" ] [ Html.text "Honest Living" ]
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
                    [ viewSong Song.HopeAndOlney
                    , viewSong Song.Isswttd
                    ]
                ]

        About ->
            Html.div [ class "jumbotron" ]
                [ Html.h1 [] [ Html.text "About" ]
                , Html.p [] [ Html.text "Strings/Vocals: David Marcotte\nDrums: Nick Rotondo" ]
                , Html.p [] [ Html.text "Two dudes from Providence, Rhode Island who slang mostly instrumental hits from 2015 to 2017." ]
                ]

        Photos ->
            Html.div [ class "jumbotron" ] [ Html.text "Photos Coming Soon!" ]

        Videos ->
            Html.div [ class "jumbotron" ] [ Html.text "Videos Coming Soon!" ]


viewSong : Song.Song -> Grid.Column Msg
viewSong song =
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
            [ Html.div [ style "color" "white", style "text-shadow" "2px 2px 2px #272B30", style "align-self" "flex-end" ] [ Html.text (Song.title song) ]
            , Html.audio [ src (Song.audioSrc song), controls True ] [] -- Audio has the option to download
            ]
        ]



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
