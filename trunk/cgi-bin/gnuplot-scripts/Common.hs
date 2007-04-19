{-# OPTIONS_GHC -fglasgow-exts #-}
module Common where
import Control.Monad.Error

gnuplot_png_settings = "set terminal png transparent nocrop enhanced size 600,400\n" ++
                       "set pm3d implicit at s"

gnuplot_math_settings =  gnuplot_png_settings ++ "\n" ++
                         "set border 4095 \n\
                         \  set xlabel \"x\" \n\
                         \  set ylabel \"y\""

gnuplot_timeseries_settings = gnuplot_png_settings ++ "\n" ++
                              "set xdata time           # The x axis data is time \n" ++ 
                              "set timefmt \"%d-%b-%y\" # The dates in the file look like 10-Jun-04 \n" ++
                              "set format x \"%b %d\"   #On the x-axis, we want tics like Jun 10"


gen_gnuplot_math_script :: String -> String -> IO ()
gen_gnuplot_math_script style function = let maybePlotCmd = lookup style style_to_plotcmd 
                                             style_to_plotcmd =  [("math-2d","plot"),("math-3d","splot")]
                                           in case maybePlotCmd of
                                                Just plotcmd -> putStrLn $ gnuplot_math_settings ++ "\n" ++ plotcmd ++ " "  ++ function
                                                _            -> error $ "bad style: " ++ style


company_to_companyfile =  [("ibm","data/ibm.dat"),("cisco","data/cisco.dat")]
displaymode_to_modestring = [("points", "using 1:2 with linespoints"),
                   ("candles","using 1:($2+$3+$4+$5)/4:4:3 with yerrorbars")]
displaymode_to_titleend = [("points","daily prices"),("candles","opening prices")]

-- can we get this to fail faster on bad input?
-- do we care?
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
 lookupWith :: (Eq a) => b -> a -> [(a, b)] -> b
 lookupWith errorFunc key assocs = maybe errorFunc id $ lookup key assocs 


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
     lookupWith :: (Eq a) => String -> a -> [(a,String)] -> Either String String
     lookupWith errorMsg key assocs = maybe (Left errorMsg) Right $ lookup key assocs

class MyString a
   where mystr :: a -> Either String String

instance MyString (Either String String)
   where mystr = id

instance MyString String
   where mystr = Right

(<++>) :: (MyString a1, MyString a) => a -> a1 -> Either String String
x <++> y = do xv <- mystr x
              yv <- mystr y
              return $ xv ++ yv

