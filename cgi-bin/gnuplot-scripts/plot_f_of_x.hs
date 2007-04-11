#!/usr/lib/ghc-6.6/bin/runghc
import System
import Common 

main = do args <- getArgs
          let usagemsg = "usage examples: $ runghc plot_f_of_x.hs math-2d 'sin (x)'\n" ++
                         "                $ runghc plot_f_of_x.hs math-3d 'sin (x)'"
          case args of
            [style,function] -> gen_gnuplot_script style function
            _                    -> error $ "arg count does not equal 2. args: : " ++ ( show args ) ++ "\n" ++ usagemsg

style_to_plotcmd =  [("math-2d","plot"),("math-3d","splot")]

{-

| Just plotcmd
    <- lookup style_to_plotcmd style
    = putStrLn $ gnuplot_math_settings ++ "\n" ++ plotcmd ++ " "  ++ function
| otherwise = error $ "bad style: " ++ style
-}

gen_gnuplot_script style function | style == "math-2d" = putStrLn $ gnuplot_math_settings ++ "\n" ++ "  plot " ++ function
                                  | otherwise = error $ "bad style: " ++ style
