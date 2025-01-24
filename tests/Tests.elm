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
        , simpleTest "Decode nested objects with optional fields"
            playListWithOptionalArtistsDecoder
            "{ \"playlistName\": \"Favorites\", \"songs\": [ { \"title\": \"Song A\", \"duration\": 180, \"artist\": \"Artist 1\" }, { \"title\": \"Song B\", \"duration\": 200, \"artist\": null } ] }"
            (PlayListWithOptionalArtist
                "Favorites"
                [ SongWithOptionalArtist "Song A" 180 (Just "Artist 1"), SongWithOptionalArtist "Song B" 200 Nothing ]
            )
        , simpleTest "Decode category with items"
            categoryDecoder
            "{ \"category\": \"Books\", \"items\": [ { \"title\": \"Book 1\", \"author\": { \"name\": \"Author A\", \"born\": 1975 }, \"tags\": [\"Fiction\", \"Drama\"] }, { \"title\": \"Book 2\", \"author\": { \"name\": \"Author B\", \"born\": null }, \"tags\": [] } ] }"
            (Category "Books" [ BookItem "Book 1" (AuthorWithOptionalBirthYear "Author A" (Just 1975)) [ "Fiction", "Drama" ], BookItem "Book 2" (AuthorWithOptionalBirthYear "Author B" Nothing) [] ])
        , simpleTest "Decode multi-level event"
            eventDecoder
            "{ \"event\": \"Conference\", \"details\": { \"date\": \"2025-12-01\", \"location\": { \"city\": \"New York\", \"country\": \"USA\" } }, \"attendees\": [ { \"name\": \"Alice\", \"email\": \"alice@example.com\" }, { \"name\": \"Bob\", \"email\": \"bob@example.com\" } ] }"
            (Event "Conference" (EventDetails "2025-12-01" (Location "New York" "USA")) [ Attendee "Alice" "alice@example.com", Attendee "Bob" "bob@example.com" ])
        ]
