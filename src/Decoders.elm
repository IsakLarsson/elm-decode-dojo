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
        (Decode.field "nickname" <| Decode.maybe Decode.string)



--LEVEL 3 : Nested object
--JSON :
--  { "title": "The Great Gatsby",
--    "author": { "name": "F. Scott Fitzgerald", "born": 1896 }
--  }


type alias Book =
    { title : String, author : Author }


type alias Author =
    { name : String, born : Int }


authorDecoder : Decode.Decoder Author
authorDecoder =
    Decode.map2 Author
        (Decode.field "name" Decode.string)
        (Decode.field "born" Decode.int)


bookDecoder : Decode.Decoder Book
bookDecoder =
    Decode.map2 Book
        (Decode.field "title" Decode.string)
        (Decode.field "author" authorDecoder)



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
    Decode.map2 Song
        (Decode.field "title" Decode.string)
        (Decode.field "duration" Decode.int)


playlistDecoder : Decode.Decoder Playlist
playlistDecoder =
    Decode.map2 Playlist
        (Decode.field "playlistName" Decode.string)
        (Decode.field "songs" <| Decode.list songDecoder)



-- LEVEL 5: One Of (Union Types)
-- JSON:
-- { "status": "success", "data": { "value": 42 } }
-- OR
-- { "status": "error", "message": "Something went wrong" }


type ResultType
    = Success Int
    | Error String


resultDecoder : Decode.Decoder ResultType
resultDecoder =
    Decode.field "status" Decode.string
        |> Decode.andThen
            (\status ->
                case status of
                    "success" ->
                        Decode.at [ "data", "value" ] Decode.int
                            |> Decode.map Success

                    "error" ->
                        Decode.at [ "message" ] Decode.string
                            |> Decode.map Error

                    _ ->
                        Decode.fail ("unexpected status " ++ status)
            )



-- LEVEL 6: Custom Transformations
-- JSON:
-- { "firstName": "Charlie", "lastName": "Brown" }


type alias User =
    { fullName : String
    }


userDecoder : Decode.Decoder User
userDecoder =
    Decode.map2 (\first last -> User (first ++ " " ++ last))
        (Decode.field "firstName" Decode.string)
        (Decode.field "lastName" Decode.string)



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


songWithOptionalArtistDecoder : Decode.Decoder SongWithOptionalArtist
songWithOptionalArtistDecoder =
    Decode.map3 SongWithOptionalArtist
        (Decode.field "title" Decode.string)
        (Decode.field "duration" Decode.int)
        (Decode.field "artist" <| Decode.maybe Decode.string)


playListWithOptionalArtistsDecoder : Decode.Decoder PlayListWithOptionalArtist
playListWithOptionalArtistsDecoder =
    Decode.map2 PlayListWithOptionalArtist
        (Decode.field "playlistName" Decode.string)
        (Decode.field "songs" <| Decode.list songWithOptionalArtistDecoder)



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


authorWithOptionalBirthYearDecoder : Decode.Decoder AuthorWithOptionalBirthYear
authorWithOptionalBirthYearDecoder =
    Decode.map2 AuthorWithOptionalBirthYear
        (Decode.field "name" Decode.string)
        (Decode.field "born" <| Decode.maybe Decode.int)


bookItemDecoder : Decode.Decoder BookItem
bookItemDecoder =
    Decode.map3 BookItem
        (Decode.field "title" Decode.string)
        (Decode.field "author" <| authorWithOptionalBirthYearDecoder)
        (Decode.field "tags" <| Decode.list Decode.string)


categoryDecoder : Decode.Decoder Category
categoryDecoder =
    Decode.map2 Category
        (Decode.field "category" Decode.string)
        (Decode.field "items" <| Decode.list bookItemDecoder)



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


detailsDecoder : Decode.Decoder EventDetails
detailsDecoder =
    Decode.map2 EventDetails
        (Decode.field "date" Decode.string)
        (Decode.field "location" locationDecoder)


locationDecoder : Decode.Decoder Location
locationDecoder =
    Decode.map2 Location
        (Decode.field "city" Decode.string)
        (Decode.field "country" Decode.string)


attendeeDecoder : Decode.Decoder Attendee
attendeeDecoder =
    Decode.map2 Attendee
        (Decode.field "name" Decode.string)
        (Decode.field "email" Decode.string)


eventDecoder : Decode.Decoder Event
eventDecoder =
    Decode.map3 Event
        (Decode.field "event" Decode.string)
        (Decode.field "details" detailsDecoder)
        (Decode.field "attendees" <| Decode.list attendeeDecoder)
