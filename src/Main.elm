module Main exposing (init, main)

import Browser
import Browser.Navigation as Navigation
import Html exposing (a, button, div, h1, li, nav, p, span, text, ul)
import Html.Attributes exposing (attribute, class, href, id, type_)
import Url



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
    { title = "Honest Living Band"
    , body =
        [ nav [ class "navbar navbar-default navbar-fixed-top" ]
            [ div [ class "container" ]
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
                    , a [ class "navbar-brand", href "#" ]
                        [ text "Project name" ]
                    ]
                , div [ class "navbar-collapse collapse", id "navbar" ]
                    [ ul [ class "nav navbar-nav" ]
                        [ li [ class "active" ]
                            [ a [ href "#" ]
                                [ text "Home" ]
                            ]
                        , li []
                            [ a [ href "#" ]
                                [ text "About" ]
                            ]
                        , li []
                            [ a [ href "#" ]
                                [ text "Contact" ]
                            ]
                        , li [ class "dropdown" ]
                            [ a [ attribute "aria-expanded" "false", attribute "aria-haspopup" "true", class "dropdown-toggle", attribute "data-toggle" "dropdown", href "#", attribute "role" "button" ]
                                [ text "Dropdown "
                                , span [ class "caret" ]
                                    []
                                ]
                            , ul [ class "dropdown-menu" ]
                                [ li []
                                    [ a [ href "#" ]
                                        [ text "Action" ]
                                    ]
                                , li []
                                    [ a [ href "#" ]
                                        [ text "Another action" ]
                                    ]
                                , li []
                                    [ a [ href "#" ]
                                        [ text "Something else here" ]
                                    ]
                                , li [ class "divider", attribute "role" "separator" ]
                                    []
                                , li [ class "dropdown-header" ]
                                    [ text "Nav header" ]
                                , li []
                                    [ a [ href "#" ]
                                        [ text "Separated link" ]
                                    ]
                                , li []
                                    [ a [ href "#" ]
                                        [ text "One more separated link" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , div [ class "container" ]
            [ div [ class "jumbotron" ]
                [ h1 []
                    [ text "Navbar example" ]
                , p []
                    [ text "This example is a quick exercise to illustrate how the default, static and fixed to top navbar work. It includes the responsive CSS and HTML, so it also adapts to your viewport and device." ]
                , p []
                    [ text "To see the difference between static and fixed top navbars, just scroll." ]
                , p []
                    [ a [ class "btn btn-lg btn-primary", href "../../components/#navbar", attribute "role" "button" ]
                        [ text "View navbar docs »" ]
                    ]
                ]
            ]
        ]
    }



-- ROUTES


type Route
    = Home
    | About
    | Videos
