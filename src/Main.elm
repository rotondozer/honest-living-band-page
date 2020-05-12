module Main exposing (init, main)

import Bootstrap.Button as Button
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar
import Browser
import Browser.Navigation as Navigation
import Html
import Html.Attributes exposing (class, controls, href, src, style)
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
    | Download Song.Song


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

        Download song ->
            ( model, Navigation.load (Song.downloadLink song) )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navbarState NavbarMsg



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Honest Living"
    , body =
        [ Html.div []
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
                [ Grid.row [] [ Grid.col [] [ Html.h1 [] [ Html.text "Songs" ] ] ]
                , Grid.row []
                    [ viewSong Song.Seasonal
                    , viewSong Song.HopeAndOlney
                    , viewSong Song.Isswttd
                    , viewSong Song.NeverACloser
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
        [ Card.config [ Card.attrs [] ]
            |> Card.block []
                [ Block.titleH4 [] [ Html.text (Song.title song) ]
                , Block.text []
                    [ Html.img [ src (Song.imageSrc song), Html.Attributes.width 250, Html.Attributes.height 250 ] []
                    , Html.audio [ src (Song.previewLink song), controls True ] []
                    ]
                , Block.custom <|
                    Button.button [ Button.primary, Button.attrs [ onClick (Download song) ] ] [ Html.text "Download" ]
                ]
            |> Card.view
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
