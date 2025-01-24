module Tests exposing (..)

import Decoders exposing (..)
import Expect
import Fuzz
import Json.Decode as Decode
import Test exposing (..)


suite : Test
suite =
    describe "---- Testing decoders ----"
        [ test "Decode simple person"
            (\_ ->
                let
                    json =
                        "{\"name\": \"Alice\", \"age\": 25}"

                    result =
                        Decode.decodeString personDecoder json
                in
                case result of
                    Ok person ->
                        Expect.equal person (Person "Alice" 25)

                    Err _ ->
                        Expect.fail "Failed to decode simple person"
            )
        , test "Decode optional field"
            (\_ ->
                let
                    json =
                        "{ \"name\": \"Bob\", \"age\": 30, \"nickname\": null }"

                    result =
                        Decode.decodeString personWithOptionalFieldDecoder json
                in
                case result of
                    Ok person ->
                        Expect.equal person (PersonWithOptionalField "Bob" 30 Nothing)

                    Err _ ->
                        Expect.fail "Failed to decode person with optional field"
            )
        ]
