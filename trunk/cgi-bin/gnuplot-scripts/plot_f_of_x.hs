#!/usr/lib/ghc-6.6/bin/runghc
import System
import Common 

main = do args <- getArgs
          let usagemsg = "usage examples: $ runghc plot_f_of_x.hs math-2d 'sin (x)'\n" ++
                         "                $ runghc plot_f_of_x.hs math-3d 'sin (x)'"
          case args of
            [style,function] -> gen_gnuplot_script style function
            _                    -> error $ "arg count does not equal 2. args: : " ++ ( show args ) ++ "\n" ++ usagemsg

gen_gnuplot_script style function = case style of 
                                      "math-2d" -> do putStrLn $ gnuplot_png_settings ++ "\n" ++
                                                                 gnuplot_math_settings ++ "\n" ++
                                                                 "plot " ++ function
                                      _         -> error $ "bad stle: " ++ style
