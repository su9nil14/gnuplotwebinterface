#!/usr/lib/ghc-6.6/bin/runghc 
import System
import Common 
import Control.Monad.Error

main = do args <- getArgs
          case args of
            [company, displaymode, startDate, endDate]
              -> putStrLn $ financial_output company displaymode startDate endDate
            _ -> error $ "bad arguments: " ++ ( show args ) ++ "\n" ++ usagemsg

usagemsg = "usage examples: $ runghc ./financial.hs ibm   points  31-May-04 11-Jun-04 \n" ++
           "                $ runghc ./financial.hs cisco points  31-May-04 11-Jun-04 \n" ++
           "                $ runghc ./financial.hs cisco candles 31-May-04 11-Jun-04"





