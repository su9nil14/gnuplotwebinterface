module Common where

gnuplot_png_settings = "set terminal png transparent nocrop enhanced size 600,400\n\
                        \  set pm3d implicit at s"

gnuplot_math_settings = "set border 4095 \n\
                         \  set xlabel \"x\" \n\
                         \  set ylabel \"y\""

gnuplot_timeseries_settings = "set xdata time\n" ++  	                -- The x axis data is time
                              "  set timefmt \"%d-%b-%y\" \n" ++	-- The dates in the file look like 10-Jun-04
                              "  set format x \"%b %d\""	        -- On the x-axis, we want tics like Jun 10'


