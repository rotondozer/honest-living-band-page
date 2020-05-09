module Main exposing (init, main)

import Browser
import Browser.Navigation as Navigation
import Html exposing (Html, a, button, div, h1, iframe, li, nav, p, span, text, ul)
import Html.Attributes exposing (attribute, class, download, href, id, src, type_)
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
    ( { url = url
      , key = key
      }
    , Cmd.none
    )


type alias Model =
    { url : Url.Url
    , key : Navigation.Key
    }



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Honest Living"
    , body =
        [ div [ class "container" ]
            [ viewNavbar model
            , viewCurrentPage model
            ]
        ]
    }


viewNavbar : Model -> Html Msg
viewNavbar model =
    nav [ class "navbar navbar-default navbar-fixed-top" ]
        [ div [ class "navbar-header" ]
            [ button
                [ attribute "aria-controls" "navbar"
                , attribute "aria-expanded" "false"
                , class "navbar-toggle collapsed"
                , attribute "data-target" "#navbar"
                , attribute "data-toggle" "collapse"
                , type_ "button"
                ]
                [ span [ class "sr-only" ]
                    [ text "Toggle navigation" ]
                , span [ class "icon-bar" ]
                    []
                , span [ class "icon-bar" ]
                    []
                , span [ class "icon-bar" ]
                    []
                ]
            , a [ class "navbar-brand", href "/Home" ]
                [ text "Honest Living" ]
            ]
        , div [ class "navbar-collapse collapse", id "navbar" ]
            [ ul [ class "nav navbar-nav" ]
                [ viewRouteLink "About"
                , viewRouteLink "Videos"
                ]
            ]
        ]


viewRouteLink : String -> Html msg
viewRouteLink routeName =
    li [] [ a [ href ("/" ++ routeName) ] [ text routeName ] ]


viewCurrentPage : Model -> Html Msg
viewCurrentPage model =
    case toRoute model.url of
        Home ->
            div [ class "jumbotron" ]
                [ h1 [] [ text "Songs" ]
                , p []
                    [ viewSong "Seasonal" "1qKTDdmhHrC7_2p2l1IQta7d_YIJOyz3W"
                    , viewSong "Hope and Olney" "1xMRM-0heaytWptb66yFG0jyofXGI2AXD"
                    , viewSong "I Should Start Writing These Things Down" "1L7YOr9L4gvARk6orSxbdkLflOWXfNKZF"
                    , viewSong "Never a Closer" "1XHvfbaR5zQliqErhuTRua6UGfJoUinDt"
                    ]
                ]

        About ->
            div [ class "jumbotron" ]
                [ h1 [] [ text "About" ]
                , p [] [ text "Strings/Vocals: David Marcotte\nDrums: Nick Rotondo" ]
                , p [] [ text "Two dudes from Providence, Rhode Island who slang mostly instrumental hits from 2015 to 2017." ]
                ]

        Videos ->
            div [ class "jumbotron" ] [ text "Coming Soon!" ]



-- SONGS
-- https://drive.google.com/open?id=1qKTDdmhHrC7_2p2l1IQta7d_YIJOyz3W Seasonal
-- https://drive.google.com/open?id=1L7YOr9L4gvARk6orSxbdkLflOWXfNKZF isswttd
-- https://drive.google.com/open?id=1xMRM-0heaytWptb66yFG0jyofXGI2AXD Hope and Olney
-- 1XHvfbaR5zQliqErhuTRua6UGfJoUinDt Closer


viewSong : String -> String -> Html Msg
viewSong songTitle songId =
    div []
        [ iframe
            [ attribute "frameborder" "0"
            , attribute "height" "200"
            , src ("https://drive.google.com/file/d/" ++ songId ++ "/preview")
            , attribute "width" "400"
            ]
            []
        , a
            [ href ("https://drive.google.com/u/0/uc?id=" ++ songId ++ "&export=download"), download songTitle ]
            [ text songTitle ]
        ]



-- ROUTES


type Route
    = Home
    | About
    | Videos


routeParser : Parser.Parser (Route -> a) a
routeParser =
    Parser.oneOf
        [ Parser.map Home Parser.top
        , Parser.map About (Parser.s "About")
        , Parser.map Videos (Parser.s "Videos")
        ]


toRoute : Url.Url -> Route
toRoute url =
    Maybe.withDefault Home (Parser.parse routeParser url)
