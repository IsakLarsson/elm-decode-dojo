module Main exposing (main)

import Browser
import Html


main : Program () () ()
main =
    Browser.sandbox
        { init = ()
        , view = always (Html.text "Run elm-test to test your decoding skills")
        , update = \_ model -> model
        }
