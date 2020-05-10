module Main exposing (init, main)

import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar
import Browser
import Browser.Navigation as Navigation
import Html exposing (Html, a, div, h1, iframe, p, text)
import Html.Attributes exposing (attribute, class, download, href, src)
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
        [ div []
            [ viewNavbar model
            , viewCurrentPage model
            ]
        ]
    }


viewNavbar : Model -> Html Msg
viewNavbar model =
    Grid.container
        []
        [ Navbar.config NavbarMsg
            |> Navbar.withAnimation
            |> Navbar.container
            |> Navbar.brand [ href "/Home" ] [ text "Honest Living" ]
            |> Navbar.items
                [ Navbar.itemLink [ href "/About" ] [ text "About" ]
                , Navbar.itemLink [ href "/Photos" ] [ text "Photos" ]
                , Navbar.itemLink [ href "/Videos" ] [ text "Videos" ]
                ]
            |> Navbar.view model.navbarState
        ]


viewCurrentPage : Model -> Html Msg
viewCurrentPage model =
    case toRoute model.url of
        Home ->
            div [ class "jumbotron" ]
                [ h1 [] [ text "Songs" ]
                , p []
                    [ viewSong Song.Seasonal
                    , viewSong Song.HopeAndOlney
                    , viewSong Song.Isswttd
                    , viewSong Song.NeverACloser
                    ]
                ]

        About ->
            div [ class "jumbotron" ]
                [ h1 [] [ text "About" ]
                , p [] [ text "Strings/Vocals: David Marcotte\nDrums: Nick Rotondo" ]
                , p [] [ text "Two dudes from Providence, Rhode Island who slang mostly instrumental hits from 2015 to 2017." ]
                ]

        Photos ->
            div [ class "jumbotron" ] [ text "Photos Coming Soon!" ]

        Videos ->
            div [ class "jumbotron" ] [ text "Videos Coming Soon!" ]


viewSong : Song.Song -> Html Msg
viewSong song =
    div []
        [ iframe
            [ attribute "frameborder" "0"
            , attribute "height" "200"
            , src (Song.previewLink song)
            , attribute "width" "400"
            ]
            []
        , a
            [ href (Song.downloadLink song), download (Song.getTitle song) ]
            [ text (Song.getTitle song) ]
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
