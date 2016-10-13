module Barcode exposing (..)

import Svg exposing (Svg, svg, g, rect, text')
import Svg.Attributes exposing (x, y, textAnchor, alignmentBaseline, viewBox, preserveAspectRatio, height, width, fill, transform)
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import String
import Code93


main =
    render "1164112750000109"


render : String -> Html a
render content =
    let
        encoded =
            Code93.encode content

        w =
            encoded
                |> String.length
                |> (+) 4
                |> (*) 2
    in
        div [ class "container" ]
            [ svg
                [ viewBox <| "-4 0 " ++ (toString w) ++ " 120"
                ]
                <| List.concat
                    [ barsView encoded
                    , contentView content w
                    ]
            ]


barsView : String -> List (Svg a)
barsView =
    List.indexedMap barView << String.toList


barView : Int -> Char -> Svg a
barView i c =
    let
        h =
            if c == '1' then
                "100"
            else
                "0"

        translation =
            toString <| i * 2
    in
        g [ transform <| "translate(" ++ translation ++ ")" ]
            [ rect [ height h, width "2", fill "black" ] []
            ]


contentView : String -> Int -> List (Svg a)
contentView content barcodeWidth =
    [ text'
        [ x <| toString <| barcodeWidth // 2
        , y "110"
        , textAnchor "middle"
        , alignmentBaseline "central"
        , fill "black"
        ]
        [ text content ]
    ]
