module Tests exposing (..)

import Test exposing (Test, describe)
import Code93.Tests


all : Test
all =
    describe "Barcode Generator"
        [ Code93.Tests.all
        ]
