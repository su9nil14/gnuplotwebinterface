module Common where

gnuplot_png_settings = "set terminal png transparent nocrop enhanced size 600,400\n\
                        \  set pm3d implicit at s"

gnuplot_math_settings =  gnuplot_png_settings ++ "\n" ++
                         "set border 4095 \n\
                         \  set xlabel \"x\" \n\
                         \  set ylabel \"y\""

gnuplot_timeseries_settings = "set xdata time\n" ++  	                -- The x axis data is time
                              "  set timefmt \"%d-%b-%y\" \n" ++	-- The dates in the file look like 10-Jun-04
                              "  set format x \"%b %d\""	        -- On the x-axis, we want tics like Jun 10'


gen_gnuplot_math_script style function = let maybePlotCmd = lookup style style_to_plotcmd 
                                             style_to_plotcmd =  [("math-2d","plot"),("math-3d","splot")]
                                           in case maybePlotCmd of
                                                Just plotcmd -> putStrLn $ gnuplot_math_settings ++ "\n" ++ plotcmd ++ " "  ++ function
                                                _            -> error $ "bad style: " ++ style

gen_gnuplot_financial_script company displaymode startDate endDate
    = let maybeCompanyFile = lookup company company_to_companyfile 
          maybeModeString = lookup displaymode displaymode_to_modestring
          company_to_companyfile =  [("math-2d","plot"),("math-3d","splot")]
          displaymode_to_modestring = [("",""),("","")]
        in case ( maybeCompanyFile, maybeModeString ) of
             ( Just companyfile, Just displaymodestring )  -> putStrLn $ gnuplot_math_settings ++ "\n" ++
                                                                         "plot "  
             _            -> error $ "bad lookup. " ++ company ++     " -> company file: " ++ ( show maybeCompanyFile ) ++ "\n" ++
                                     "            " ++ displaymode ++ " -> displaymode: "  ++ ( show maybeModeString ) 
