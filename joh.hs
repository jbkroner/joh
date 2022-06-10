{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use exitSuccess" #-}

import System.Console.GetOpt
import System.IO
import System.Exit
import System.Environment
import Data.List
import Data.Char
import Control.Monad
import Text.Printf
-- global constants
johVersion = "0.0.1"

-- data types
data Flag
    = Array                 -- -a
    | IgnoreBoolsInWords    -- -B    
    | DeduplicateObjectKeys -- -D
    | IgnoreEmptyStdin      -- -e    
    | NoEmpyValues          -- -n    
    | PrettyPrint           -- -p    
    | ShowVersion           -- -v    
    | ShowVersionJson       -- -V
    | Help                  -- -H
    deriving(Eq, Ord, Enum, Show, Bounded)

flags =
    [Option ['a'] []       (NoArg Array)
        "Interperet the list of *words* as array values and produce an array instead of an object"
    ,Option ['B'] []       (NoArg IgnoreBoolsInWords)
        "Ignore boolean expressions and treat them as literals"
    ,Option ['D'] []       (NoArg DeduplicateObjectKeys)
        "Remove duplicate object keys."
    ,Option ['e'] []       (NoArg IgnoreEmptyStdin)
        "Ignore empty stdin (i.e don't produce an error when stdin is empty)"
    ,Option ['n'] []       (NoArg NoEmpyValues)
        "Do not add keys with empty values"
    ,Option ['p'] []       (NoArg PrettyPrint)
        "Pretty-print the JSON string format on output instead of the terse one-line output it prints by default"
    ,Option ['v'] []       (NoArg ShowVersion)
        "Show version and exit"
    ,Option ['V'] []       (NoArg ShowVersionJson)
        "Show version, but this time JSON encoded :-)"
    ,Option []    ["help"] (NoArg Help)
        "Print this help message!"
    ]

parse argv = case getOpt Permute flags argv of

    (args,fs,[]) -> do
        let files = if null fs then ["-"] else fs
        if Help `elem` args
            then do hPutStrLn stderr (usageInfo header flags)
                    exitWith ExitSuccess
            else return (nub (concatMap set args), files)

    (_,_,errs)      -> do
        hPutStrLn stderr (concat errs ++ usageInfo header flags)
        exitWith (ExitFailure 1)

    where
        header = "Usage: joh [args] | [words]"
        set a = [a] -- identity placeholder? 

-- UTIL ARGS
help :: IO ()
help   = putStrLn "<usage info here>"

version :: IO ()
version = putStrLn ("Joh JSON Encoder version " ++ johVersion)

versionAsJson :: IO ()
versionAsJson = putStrLn ("{\"version\": " ++ johVersion ++ "}") -- TODO fix quotations

-- EXIT METHODS
exit :: IO a
exit    = exitWith ExitSuccess

die :: IO a
die     = exitWith (ExitFailure 1)

-- main
main :: IO()
main = do
    (args, files) <- getArgs >>= parse
    print args



