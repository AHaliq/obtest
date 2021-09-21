import Frontend
import Common.Route
import Obelisk.Frontend
import Obelisk.Route.Frontend
import Reflex.Dom

import Lib (somePrc)

main :: IO ()
main = do
  let Right validFullEncoder = checkEncoder fullRouteEncoder
  somePrc (static @"z3.wasm/z3w.wasm")
  run $ runFrontend validFullEncoder frontend
