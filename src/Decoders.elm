module Decoders exposing (..)

import Json.Decode as Decode



--LEVEL 1 : Simple person


{-| JSON: { name: "Alice" age: 25 }
-}
type alias Person =
    { name : String, age : Int }


personDecoder : Decode.Decoder Person
personDecoder =
    Decode.map2 Person
        (Decode.field "name" Decode.string)
        (Decode.field "age" Decode.int)



--LEVEL 2 : Person with optional field


{-| JSON: "{ "name": "Bob", "age": 30, "nickname": null }"
-}
type alias PersonWithOptionalField =
    { name : String, age : Int, nickname : Maybe String }


personWithOptionalFieldDecoder =
    Decode.map3 PersonWithOptionalField
        (Decode.field "name" Decode.string)
        (Decode.field "age" Decode.int)
        (Decode.field "nickname" (Decode.maybe Decode.string))
