#!/usr/lib/ghc-6.6/bin/runghc
import System
import Common ( blee )

main = do args <- getArgs
          let usagemsg = "usage example: $ runghc plot_f_of_x.hs math-2d 'sin (x)'"
                         
          case args of
            [style,function] -> gen_gnuplot_script style function
            _                    -> error $ "arg count does not equal 2. args: : " ++ ( show args ) ++ "\n" ++ usagemsg

gen_gnuplot_script style function = let blee = "blah"
                                      in do putStrLn $ unlines [style, function]
                                            putStrLn blee