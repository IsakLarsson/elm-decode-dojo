module Tests exposing (..)

import Decoders exposing (..)
import Expect
import Json.Decode as Decode
import Test exposing (..)


simpleTest : String -> Decode.Decoder a -> String -> a -> Test
simpleTest description decoder json expected =
    test description <|
        \_ ->
            case Decode.decodeString decoder json of
                Ok value ->
                    Expect.equal value expected

                Err err ->
                    Expect.fail ("Failed to decode: " ++ Debug.toString err)


tests : Test
tests =
    describe "Decoding Tests"
        [ simpleTest "Decode simple person"
            personDecoder
            "{ \"name\": \"Alice\", \"age\": 25 }"
            (Person "Alice" 25)
        , simpleTest "Decode person with nickname"
            personWithOptionalFieldDecoder
            "{ \"name\": \"Bob\", \"age\": 30, \"nickname\": null }"
            (PersonWithOptionalField "Bob" 30 Nothing)
        , simpleTest "Decode nested book"
            bookDecoder
            "{ \"title\": \"The Great Gatsby\", \"author\": { \"name\": \"F. Scott Fitzgerald\", \"born\": 1896 } }"
            (Book "The Great Gatsby" (Author "F. Scott Fitzgerald" 1896))
        , simpleTest "Decode playlist"
            playlistDecoder
            "{ \"playlistName\": \"Chill Beats\", \"songs\": [ { \"title\": \"Lofi Song 1\", \"duration\": 120 }, { \"title\": \"Lofi Song 2\", \"duration\": 150 } ] }"
            (Playlist "Chill Beats" [ Song "Lofi Song 1" 120, Song "Lofi Song 2" 150 ])
        , simpleTest "Decode result (success)"
            resultDecoder
            "{ \"status\": \"success\", \"data\": { \"value\": 42 } }"
            (Success 42)
        , simpleTest "Decode user with custom transformation"
            userDecoder
            "{ \"firstName\": \"Charlie\", \"lastName\": \"Brown\" }"
            (User "Charlie Brown")
        ]
