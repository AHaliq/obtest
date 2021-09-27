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

-- import Lib (someStr)

-- This runs in a monad that can be run on the client or the server.
-- To run code in a pure client or pure server context, use one of the
-- `prerender` functions.
frontend :: Frontend (R FrontendRoute)
frontend = Frontend
  { _frontend_head = do
      el "title" $ text "Try L4"
      css $ static @"main.css"
      script $ static @"z3.wasm/demo.js"
      script "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.63.0/codemirror.min.js"
      css "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.63.0/codemirror.min.css"
      css "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.63.0/theme/nord.min.css"
      script "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.63.0/mode/haskell/haskell.min.js"
  , _frontend_body = do
      prerender_ blank $ do
          elClass "div" "container" $ do
            el "h1" $ text "L4"
            elClass "div" "content" $ do
              t :: Dynamic t T.Text <- Editor.widget
              elAttr "textArea" ("spellcheck" =: "false") $ parseDyn t
          script $ static @"codemirror/index.js"
          return ()
  }

css src = elAttr "link" ("href" =: src <> "type" =: "text/css" <> "rel" =: "stylesheet") blank

script src = elAttr "script" ("type" =: "text/javascript" <> "src" =: src) blank

parseDyn t = dynText $ T.pack . indent . show . parseNewProgram "" . T.unpack <$> t
  where
    indent [] = []
    indent xs = intercalate "\n" $ map (\(s, i) -> replicate (i*2) ' ' ++ s ) $ filter (\(s,_) -> s /= []) $ break 0 xs
      where
        ixs = ['(', '{']
        dxs = [')', '}']
        break i [] = [([], i)]
        break i (x:xs) = case if x `elem` ixs then Just True
          else if x `elem` dxs then Just False
          else Nothing of
            Just True  -> (x:"", i):break (i + 1) xs
            Just False -> let i' = i - 1 in ("", i):(x:"", i'):break i' xs
            Nothing -> case break i xs of
              (str, i):rs -> (x:str, i):rs
               
    {-}
    indent _ [] = []
    indent i (x:xs) = concat [ns, indent i' xs]
      where
        inc = if x `elem` ['(', '{'] then Just True else if x `elem` [')', '}'] then Just False else Nothing
        i' = i + case inc of
          Just True -> 1
          Just False -> -1
          Nothing -> 0
        ws = replicate (i' * 2) ' '
        ns = case inc of
          Just True -> concat [x:"\n", ws]
          Just False -> concat ["\n", ws, x:""]
          Nothing -> x:""
          -}

{- original scaffolding code
do
      el "h1" $ text "L4"
      t <- inputElement def
      text " "
      dynText $ _inputElement_value t

      el "p" $ dynText $ T.pack . show . parseNewProgram "dummyPath" . T.unpack <$> _inputElement_value t

      -- `prerender` and `prerender_` let you choose a widget to run on the server
      -- during prerendering and a different widget to run on the client with
      -- JavaScript. The following will generate a `blank` widget on the server and
      -- print "Hello, World!" on the client.
      prerender_ blank $ liftJSM $ void $ eval ("console.log('Hello, World!')" :: T.Text)

      elAttr "img" ("src" =: static @"obelisk.jpg") blank
      el "div" $ do
        exampleConfig <- getConfig "common/example"
        case exampleConfig of
          Nothing -> text "No config file found in config/common/example"
          Just s -> text $ T.decodeUtf8 s
      return ()
      -}