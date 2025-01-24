module Decoders exposing (..)

import Json.Decode as Decode



--LEVEL 1 : Simple person


{-| JSON: { name: "Alice" age: 25 }
-}
type alias Person =
    { name : String, age : Int }


personDecoder : Decode.Decoder Person
personDecoder =
    Decode.fail "Implement person decoder"



--LEVEL 2 : Person with optional field


{-| JSON: "{ "name": "Bob", "age": 30, "nickname": null }"
-}
type alias PersonWithOptionalField =
    { name : String, age : Int, nickname : Maybe String }


personWithOptionalFieldDecoder : Decode.Decoder PersonWithOptionalField
personWithOptionalFieldDecoder =
    Decode.fail "Implement person with optional field decoder"



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



--LEVEL 7 Nested Object with optional fields
--JSON:
-- {
--   "playlistName": "Favorites",
--   "songs": [
--     { "title": "Song A", "duration": 180, "artist": "Artist 1" },
--     { "title": "Song B", "duration": 200, "artist": null }
--   ]
-- }


type alias SongWithOptionalArtist =
    { title : String, duration : Int, artist : Maybe String }


type alias PlayListWithOptionalArtist =
    { playListName : String, songs : List SongWithOptionalArtist }


playListWithOptionalArtistsDecoder : Decode.Decoder PlayListWithOptionalArtist
playListWithOptionalArtistsDecoder =
    Decode.fail "Implement playListWithOptionalArtistsDecoder"



-- LEVEL 8: One-Of Nested Structure
-- JSON:
-- {
--   "category": "Books",
--   "items": [
--     {
--       "title": "Book 1",
--       "author": {
--         "name": "Author A",
--         "born": 1975
--       },
--       "tags": ["Fiction", "Drama"]
--     },
--     {
--       "title": "Book 2",
--       "author": {
--         "name": "Author B",
--         "born": null
--       },
--       "tags": []
--     }
--   ]
-- }


type alias AuthorWithOptionalBirthYear =
    { name : String
    , born : Maybe Int
    }


type alias BookItem =
    { title : String
    , author : AuthorWithOptionalBirthYear
    , tags : List String
    }


type alias Category =
    { category : String
    , items : List BookItem
    }


categoryDecoder : Decode.Decoder Category
categoryDecoder =
    Decode.fail "implement Category decoder"



-- JSON:
-- {
--   "event": "Conference",
--   "details": {
--     "date": "2025-12-01",
--     "location": {
--       "city": "New York",
--       "country": "USA"
--     }
--   },
--   "attendees": [
--     {
--       "name": "Alice",
--       "email": "alice@example.com"
--     },
--     {
--       "name": "Bob",
--       "email": "bob@example.com"
--     }
--   ]
-- }


type alias Location =
    { city : String
    , country : String
    }


type alias Attendee =
    { name : String
    , email : String
    }


type alias EventDetails =
    { date : String
    , location : Location
    }


type alias Event =
    { eventName : String
    , details : EventDetails
    , attendees : List Attendee
    }


eventDecoder : Decode.Decoder Event
eventDecoder =
    Decode.fail "implement event decoder"
