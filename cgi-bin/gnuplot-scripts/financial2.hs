#!/usr/lib/ghc-6.6/bin/runghc 

import System
import Common 

main = do args <- getArgs
          case args of
            [company, displaymode, startDate, endDate]
              -> let result = financial_output2 company displaymode startDate endDate 
                    in either error putStrLn result
            _ -> error $ "bad arguments: " ++ ( show args ) ++ "\n" ++ usagemsg

usagemsg = "usage examples: $ runghc ./financial.hs ibm   points  31-May-04 11-Jun-04 \n" ++
           "                $ runghc ./financial.hs cisco points  31-May-04 11-Jun-04 \n" ++
           "                $ runghc ./financial.hs cisco candles 31-May-04 11-Jun-04"




