#!/usr/lib/ghc-6.6/bin/runghc 
import System
import Common 

main = do args <- getArgs
          let usagemsg = "usage examples: $ runghc plot_f_of_x.hs math-2d 'sin (x)'\n" ++
                         "                $ runghc plot_f_of_x.hs math-3d 'sin (x)'"
          case args of
            [style,function] -> gen_gnuplot_math_script style function
            _                -> error $ "bad arguments: " ++ ( show args ) ++ "\n" ++ usagemsg




