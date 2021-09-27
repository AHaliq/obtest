{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE PackageImports #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Frontend where

import Control.Monad
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import Language.Javascript.JSaddle (eval, liftJSM)
import Data.List (intercalate)

import Obelisk.Frontend
import Obelisk.Configs
import Obelisk.Route
import Obelisk.Generated.Static

import Reflex.Dom.Core

import Common.Api
import Common.Route

-- import Typing (checkError)
-- import "baby-l4" L4Parser (parseNewProgram)
import L4Parser (parseNewProgram)
import Reflex.Dom (def)
import Editor (widget)

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

-- REFLEX HELPERS

css src = elAttr "link" ("href" =: src <> "type" =: "text/css" <> "rel" =: "stylesheet") blank

script src = elAttr "script" ("type" =: "text/javascript" <> "src" =: src) blank

-- STRING UTILS

parseDyn t = dynText $ T.pack . indent . show . parseNewProgram "" . T.unpack <$> t

indent [] = []
indent xs = intercalate "\n" $ map (\(s, i) -> replicate (i*2) ' ' ++ s ) $ breaki 0 xs

breaki i [] = [([], i)]
breaki i (x:xs) = 
  if x `elem` ['(', '[', '{']         then (x:"", i):breaki (i + 1) xs
  else if x `elem` [')', ']', '}']    then case breaki (i - 1) xs of (str, i'):rs -> ("", i):(x:str, i'):rs
                                      else case breaki i xs of (str, i):rs -> (x:str, i):rs