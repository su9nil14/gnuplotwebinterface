#!/usr/lib/ghc-6.6/bin/runghc 
import System
import Common 

main = do args <- getArgs
          let usagemsg = "usage examples: $ runghc ./financial.hs ibm   points  31-May-04 11-Jun-04 \n" ++
                         "                $ runghc ./financial.hs cisco points  31-May-04 11-Jun-04 \n" ++
                         "                $ runghc ./financial.hs cisco candles 31-May-04 11-Jun-04"
          case args of
            [company, displaymode, startDate, endDate]
              -> gen_gnuplot_financial_script company displaymode startDate endDate
            _ -> error $ "bad arguments: " ++ ( show args ) ++ "\n" ++ usagemsg




