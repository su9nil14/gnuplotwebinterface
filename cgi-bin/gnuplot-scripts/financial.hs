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


financial_output :: String -> String -> String -> String -> String
financial_output company displaymode startDate endDate = financial_script
 where
 financial_script = gnuplot_timeseries_settings ++ "\n"
                 ++ "plot [\"" ++ startDate ++ "\":\"" ++ endDate ++ "\"]"
                 ++ " '" ++ companyFile ++ "'" ++ modeString
                 ++ " title \"" ++ company ++ " " ++ titleEnd ++ "\""

 companyFile = lookupWith (error $ "no company file for " ++ company)
                 company company_to_companyfile

 modeString  = lookupWith (error $ "no mode string for " ++ displaymode)
                 displaymode displaymode_to_modestring

 titleEnd    = lookupWith (error $ "no title end for " ++ displaymode)
                 displaymode displaymode_to_titleend

lookupWith error key assocs = maybe error id $ lookup key assocs


