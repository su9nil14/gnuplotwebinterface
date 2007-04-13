#!/usr/lib/ghc-6.6/bin/runghc 
import System
import Common 

main = do args <- getArgs
          case args of
            [company, displaymode, startDate, endDate]
              -> financial_output_wrapper company displaymode startDate endDate
            _ -> error $ "bad arguments: " ++ ( show args ) ++ "\n" ++ usagemsg



financial_output_wrapper :: String -> String -> String -> String -> IO ()
financial_output_wrapper company displaymode startDate endDate =
  do
    let  maybeCompanyFile = lookup company company_to_companyfile
    validate_arg "company" company maybeCompanyFile usagemsg

    let  maybeModeString  = lookup displaymode displaymode_to_modestring
    validate_arg "display mode" displaymode maybeModeString usagemsg


    let  maybeTitleEnd = lookup displaymode displaymode_to_titleend 
    validate_arg "title end" displaymode maybeTitleEnd usagemsg

    let maybeScript  = gen_gnuplot_financial_script company
                                                    ( maybeCompanyFile  )
                                                    ( maybeModeString )
                                                    ( maybeTitleEnd )
                                                    startDate endDate
    case maybeScript of 
             Just script -> putStrLn script
             _           -> error $ "bad script" ++ "\n" ++ usagemsg


usagemsg = "usage examples: $ runghc ./financial.hs ibm   points  31-May-04 11-Jun-04 \n" ++
           "                $ runghc ./financial.hs cisco points  31-May-04 11-Jun-04 \n" ++
           "                $ runghc ./financial.hs cisco candles 31-May-04 11-Jun-04"