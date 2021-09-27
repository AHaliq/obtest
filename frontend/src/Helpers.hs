
{-# LANGUAGE OverloadedStrings #-}
module Helpers
  ( css
  , script
  )where

import Reflex.Dom.Core
import Data.Text.Internal (Text)

css :: DomBuilder t m => Text -> m ()
css src = elAttr "link" ("href" =: src <> "type" =: "text/css" <> "rel" =: "stylesheet") blank

script :: DomBuilder t m => Text -> m ()
script src = elAttr "script" ("type" =: "text/javascript" <> "src" =: src) blank