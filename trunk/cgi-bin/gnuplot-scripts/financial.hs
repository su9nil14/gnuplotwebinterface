#!/usr/lib/ghc-6.6/bin/runghc 
import System
import Common 

main = do args <- getArgs
          let usagemsg = "usage examples: $ runghc ./financial.hs ibm   points  31-May-04 11-Jun-04 \n" ++
                         "                $ runghc ./financial.hs cisco points  31-May-04 11-Jun-04 \n" ++
                         "                $ runghc ./financial.hs cisco candles 31-May-04 11-Jun-04"
          case args of
            [company, displaymode, startDate, endDate]
              -> output_wrapper company displaymode startDate endDate
            _ -> error $ "bad arguments: " ++ ( show args ) ++ "\n" ++ usagemsg


output_wrapper company displaymode startDate endDate =
    let maybeCompanyFile = lookup company company_to_companyfile
        maybeModeString  = lookup displaymode displaymode_to_modestring
        maybeTitleEnd    = lookup displaymode displaymode_to_titleend 
        maybeScript  = gen_gnuplot_financial_script company
                                                    ( maybeCompanyFile  )
                                                    ( maybeModeString )
                                                    ( maybeTitleEnd )
                                                    startDate endDate
          in 
           case maybeScript of 
             Just script -> putStrLn script
             _           -> error $ unwords ["bad script for ",
                                              company, "->", (show maybeCompanyFile), ",", "\n",
                                              displaymode, "->", (show maybeModeString), "->", (show maybeTitleEnd),
                                              startDate,
                                              endDate]

--                 _ -> error $ "bad lookup. " ++ company ++     " -> company file: " ++ ( show maybeCompanyFile ) ++ "\n" ++
--                              "            " ++ displaymode ++ " -> displaymode: "  ++ ( show maybeModeString ) ++ "\n" ++
--                              "            " ++ displaymode ++ " -> titleEnd: "     ++ ( show maybeTitleEnd) 
