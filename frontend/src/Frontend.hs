{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE PackageImports #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Frontend where

import qualified Data.Text as T

import Obelisk.Frontend
import Obelisk.Route
import Obelisk.Generated.Static

import Reflex.Dom.Core

import Common.Route

-- import Typing (checkError)
-- import "baby-l4" L4Parser (parseNewProgram)
import L4Parser (parseNewProgram)
import Editor (widget)
import Helpers (css, script)
import StringUtils (indent)

frontend :: Frontend (R FrontendRoute)
frontend = Frontend
  { _frontend_head = do
      el "title" $ text "Try L4"
      css $ static @"main.css"
      script $ static @"z3.wasm/demo.js"
  , _frontend_body = do
      prerender_ blank $ do
          elClass "div" "container" $ do
            el "h1" $ text "L4"
            elClass "div" "content" $ do
              t :: Dynamic t T.Text <- Editor.widget
              elAttr "textArea" ("spellcheck" =: "false") $ parseDyn t
          return ()
  }

parseDyn :: (PostBuild t m, DomBuilder t m) => Dynamic t T.Text -> m ()
parseDyn t = dynText $ T.pack . indent . show . parseNewProgram "" . T.unpack <$> t