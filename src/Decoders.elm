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


personWithOptionalFieldDecoder : Decode.Decoder PersonWithOptionalField
personWithOptionalFieldDecoder =
    Decode.map3 PersonWithOptionalField
        (Decode.field "name" Decode.string)
        (Decode.field "age" Decode.int)
        (Decode.field "nickname" (Decode.maybe Decode.string))



--LEVEL 3 : Nested object
--JSON :
--  { "title": "The Great Gatsby",
--    "author": { "name": "F. Scott Fitzgerald", "born": 1896 }
--  }


type alias Book =
    { title : String, author : Author }


type alias Author =
    { name : String, born : Int }


bookDecoder : Decode.Decoder Book
bookDecoder =
    Decode.fail "Implement book decoder"



--LEVEL 4: Decode Lists
--JSON:
--  { "playlistName": "Chill Beats",
--    "songs": [
--      { "title": "Lofi Song 1", "duration": 120 },
--      { "title": "Lofi Song 2", "duration": 150 }
--    ]
--  }


type alias Playlist =
    { playlistName : String
    , songs : List Song
    }


type alias Song =
    { title : String
    , duration : Int
    }


songDecoder : Decode.Decoder Song
songDecoder =
    Decode.fail "Implement song decoder"


playlistDecoder : Decode.Decoder Playlist
playlistDecoder =
    Decode.fail "Implement playlist decoder"



-- LEVEL 5: One Of (Union Types)
-- JSON:
-- { "status": "success", "data": { "value": 42 } }
-- OR
-- { "status": "error", "message": "Something went wrong" }


type Result
    = Success Int
    | Error String


resultDecoder : Decode.Decoder Result
resultDecoder =
    Decode.fail "Implement Result decoder"



-- LEVEL 6: Custom Transformations
-- JSON:
-- { "firstName": "Charlie", "lastName": "Brown" }


type alias User =
    { fullName : String
    }


userDecoder : Decode.Decoder User
userDecoder =
    Decode.fail "Implement User decoder"
