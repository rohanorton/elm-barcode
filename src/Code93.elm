module Code93 exposing (encode)

import String
import Dict exposing (Dict)
import List
import Char


encode : String -> String
encode =
    stringToSymbols >> addChecksumSymbol 20 >> addChecksumSymbol 15 >> bookend "*" >> toBinary >> appendBlackBar


toBinary : String -> String
toBinary =
    stringFlatMap (Maybe.withDefault "" << (flip Dict.get) charToBinaryMap)


appendBlackBar : String -> String
appendBlackBar str =
    str ++ "1"


stringFlatMap : (Char -> String) -> String -> String
stringFlatMap fn =
    List.foldl (\c m -> m ++ (fn c)) "" << String.toList


bookend : String -> String -> String
bookend ends middle =
    ends ++ middle ++ ends


stringToSymbols : String -> String
stringToSymbols =
    stringFlatMap (encodeChar << Char.toCode)


stringFromCode : Int -> String
stringFromCode =
    String.fromChar << Char.fromCode


encodeChar : Int -> String
encodeChar code =
    if code == 32 || code == 45 || code == 46 || code >= 48 && code <= 57 || code >= 65 && code <= 90 then
        stringFromCode code
    else if code == 0 then
        "bU"
    else if code == 64 then
        "bV"
    else if code == 96 then
        "bW"
    else if code == 127 then
        "bT"
    else if code <= 26 then
        "a" ++ (stringFromCode (code + 65 - 1))
    else if code <= 31 then
        "b" ++ (stringFromCode (code + 65 - 27))
    else if code <= 58 then
        "c" ++ (stringFromCode (code + 65 - 33))
    else if code <= 63 then
        "b" ++ (stringFromCode (code + 65 - 54))
    else if code <= 95 then
        "b" ++ (stringFromCode (code + 65 - 81))
    else if code <= 122 then
        "d" ++ (stringFromCode (code + 65 - 97))
    else if code <= 126 then
        "b" ++ (stringFromCode (code + 65 - 108))
    else
        Debug.crash "Barcode text must only contain ASCII characters"


alphabet : List Char
alphabet =
    String.toList "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%abcd*"


alphabetValues : Dict Char Int
alphabetValues =
    alphabet
        |> List.indexedMap (flip (,))
        |> Dict.fromList


addChecksumSymbol : Int -> String -> String
addChecksumSymbol modulo code =
    let
        stringLength =
            String.length code
    in
        code
            |> String.toList
            |> List.foldl (checksum modulo) ( stringLength, 0 )
            |> snd
            |> get alphabet
            |> Maybe.withDefault '0'
            |> String.fromChar
            |> (++) code


get : List a -> Int -> Maybe a
get list index =
    let
        helper count list =
            case list of
                [] ->
                    Nothing

                x :: xs ->
                    if count == index then
                        Just x
                    else
                        helper (count + 1) xs
    in
        helper 0 list


checksum : Int -> Char -> ( Int, Int ) -> ( Int, Int )
checksum modulo char ( i, sum ) =
    let
        value =
            Dict.get char alphabetValues
                |> Maybe.withDefault 0

        weight =
            ((i - 1) % modulo) + 1

        weightedValue =
            value * weight
    in
        ( i - 1, sum + weightedValue )


charToBinaryMap : Dict Char String
charToBinaryMap =
    Dict.fromList
        [ ( '0', "100010100" )
        , ( '1', "101001000" )
        , ( '2', "101000100" )
        , ( '3', "101000010" )
        , ( '4', "100101000" )
        , ( '5', "100100100" )
        , ( '6', "100100010" )
        , ( '7', "101010000" )
        , ( '8', "100010010" )
        , ( '9', "100001010" )
        , ( 'A', "110101000" )
        , ( 'B', "110100100" )
        , ( 'C', "110100010" )
        , ( 'D', "110010100" )
        , ( 'E', "110010010" )
        , ( 'F', "110001010" )
        , ( 'G', "101101000" )
        , ( 'H', "101100100" )
        , ( 'I', "101100010" )
        , ( 'J', "100110100" )
        , ( 'K', "100011010" )
        , ( 'L', "101011000" )
        , ( 'M', "101001100" )
        , ( 'N', "101000110" )
        , ( 'O', "100101100" )
        , ( 'P', "100010110" )
        , ( 'Q', "110110100" )
        , ( 'R', "110110010" )
        , ( 'S', "110101100" )
        , ( 'T', "110100110" )
        , ( 'U', "110010110" )
        , ( 'V', "110011010" )
        , ( 'W', "101101100" )
        , ( 'X', "101100110" )
        , ( 'Y', "100110110" )
        , ( 'Z', "100111010" )
        , ( '-', "100101110" )
        , ( '.', "111010100" )
        , ( ' ', "111010010" )
        , ( '$', "111001010" )
        , ( '/', "101101110" )
        , ( '+', "101110110" )
        , ( '%', "110101110" )
        , ( 'a', "100100110" )
        , ( 'b', "111011010" )
        , ( 'c', "111010110" )
        , ( 'd', "100110010" )
        , ( '*', "101011110" )
        ]
