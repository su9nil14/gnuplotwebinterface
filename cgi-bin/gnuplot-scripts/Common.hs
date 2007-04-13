module Common where

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

gen_gnuplot_financial_script :: String -> String -> String -> String -> Maybe String
gen_gnuplot_financial_script company displaymode startDate endDate
    = let maybeCompanyFile = lookup company     company_to_companyfile 
          maybeModeString  = lookup displaymode displaymode_to_modestring
          maybeTitleEnd    = lookup displaymode displaymode_to_titleend 
          company_to_companyfile =  [("ibm","data/ibm.dat"),("cisco","data/cisco.dat")]
          displaymode_to_modestring = [("points", "using 1:2 with linespoints"),
                                       ("candles","using 1:($2+$3+$4+$5)/4:4:3 with yerrorbars")]
          displaymode_to_titleend = [("points","daily prices"),("candles","opening prices")]
        in case ( maybeCompanyFile,
                  maybeModeString,
                  maybeTitleEnd ) of
                ( Just companyfile,
                  Just modestring,
                  Just titleEnd) -> Just $ gnuplot_timeseries_settings ++ "\n" ++
                              "plot [\"" ++ startDate ++ "\":\"" ++ endDate ++ "\"]"
                              ++ " '" ++ companyfile ++ "'"
                              ++ modestring
                              ++ " title \"" ++ company ++ " " ++ titleEnd ++ "\""
--                 _ -> error $ "bad lookup. " ++ company ++     " -> company file: " ++ ( show maybeCompanyFile ) ++ "\n" ++
--                              "            " ++ displaymode ++ " -> displaymode: "  ++ ( show maybeModeString ) ++ "\n" ++
--                              "            " ++ displaymode ++ " -> titleEnd: "     ++ ( show maybeTitleEnd) 
