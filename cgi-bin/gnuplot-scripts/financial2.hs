#!/usr/lib/ghc-6.6/bin/runghc 
{-# OPTIONS_GHC -fglasgow-exts #-}
import System
import Common 
import Control.Monad.Error

main = do args <- getArgs
          case args of
            [company, displaymode, startDate, endDate]
              -> do let result = financial_output2 company displaymode startDate endDate 
                    -- this is yucky, can we do it better?
                    -- like, by definning putStrLn for Either string?
                    case result of 
                      Left result  -> putStrLn result
                      Right result -> putStrLn result
            _ -> error $ "bad arguments: " ++ ( show args ) ++ "\n" ++ usagemsg

usagemsg = "usage examples: $ runghc ./financial.hs ibm   points  31-May-04 11-Jun-04 \n" ++
           "                $ runghc ./financial.hs cisco points  31-May-04 11-Jun-04 \n" ++
           "                $ runghc ./financial.hs cisco candles 31-May-04 11-Jun-04"

{----
Here is a variation on Claus' code which returns an Either type
rather than fails with error. This could be further generalized to use
any instance of MonadError, rather than Either.
-Jeff
----}
financial_output2 :: String -> String -> String -> String -> Either String String
financial_output2 company displaymode startDate endDate = financial_script
   where
     financial_script = gnuplot_timeseries_settings <++> "\n"
                        <++> "plot [\"" <++> startDate <++> "\":\""
                        <++> endDate <++> "\"]"
                        <++> " '" <++> companyFile <++> "'" <++> modeString
                        <++> " title \"" <++> company <++> " " <++> titleEnd <++> "\""

     companyFile = lookupWith ("no company file for " ++ company)
                   company company_to_companyfile

     modeString  = lookupWith ("no mode string for " ++ displaymode)
                   displaymode displaymode_to_modestring

     titleEnd    = lookupWith ("no title end for " ++ displaymode)
                   displaymode displaymode_to_titleend



class MyString a
   where mystr :: a -> Either String String

instance MyString (Either String String)
   where mystr = id

instance MyString String
   where mystr = Right

x <++> y = do xv <- mystr x
              yv <- mystr y
              return $ xv ++ yv

lookupWith :: (Eq a) => String -> a -> [(a,String)] -> Either String String
lookupWith error key assocs = maybe (Left error) Right $ lookup key assocs