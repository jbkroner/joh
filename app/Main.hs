{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}

module Main where
import Prelude hiding (Bool)
import Prelude.Compat
import Data.Aeson ( object, Key, Value(String), toJSON, decode, encode)
import Data.Aeson.Types
import Data.Scientific

import Control.Applicative (empty)
import qualified Data.ByteString.Lazy.Char8 as BL
import Data.ByteString.Lazy.Char8 (unpack, toStrict)
import Data.Aeson.Encode.Pretty (encodePretty)
import System.Environment (getArgs)
import Data.List.Split ( split, splitOn )
import Data.Aeson.Encoding (pair)
import Data.Text (pack, Text)
import Data.Text.Encoding ( decodeASCII, decodeUtf8 )
import Data.Aeson.Key
import GHC.Base
import Data.Maybe
import Text.Read (readMaybe)
import qualified Data.ByteString
import qualified Data.ByteString.Lazy
import qualified Data.Text.Encoding as Data.Text.IO
import qualified Data.Text.Encoding as Data.Text
import qualified Data.Text.Encoding as Data.Text.Lazy
import qualified Control.Monad
import System.Exit (exitWith, exitFailure, exitSuccess, die)

version :: String
version = "1.0.0"

jsonVersionPair :: (Key, Value)
jsonVersionPair = ("version", toValue $ BL.pack version)

delim :: String
delim = "="

argsData :: [(String, String)]
argsData = [("-a", "return args in a list. joh -a 1 2 3 -> [1,2,3]"), -- TODO
            ("-B", "Disable boolean and null interpretation"), -- TODO
            ("-D", "Deduplicate object keys"), -- TODO
            ("-e", "Ignore empty stdin"),
            ("-n", "Do not add keys with empty values "), -- TODO
            ("-p", "Pretty-print the JSON string on output instead of terse one-line"),
            ("-v", "show version and exit"),
            ("-V", "show version as a JSON object and exit"),
            ("-H", "print the help text")] -- TODO pretty print this

-- list of cli flags to check for later
flagList :: [String]
flagList = map fst argsData

helpText :: [String]
helpText = map snd argsData

splitArgs :: Eq a => [a] -> [[a]] -> [[[a]]]
splitArgs delim [] = []
splitArgs delim [x] = splitOn delim x : splitArgs delim []
splitArgs delim (x:xs) = splitOn delim x : splitArgs delim xs

buildPairList :: [[String]] -> [(Key, Value)]
buildPairList [] = []
buildPairList [x] = [(k, v)]
  where
    k = fromString $ head x
    v = toValue $ BL.pack $ last x
buildPairList (x:xs) = (k, v) : buildPairList xs
  where
    k = fromString $ head x
    v = toValue $ BL.pack $ last x
-- toValue :: BL.ByteString -> Value
toValue :: BL.ByteString -> Value
toValue x = case decode x of
              Just x -> x
              Nothing -> toJSON $ lazyToText x

-- convert from lazy bytestring to text
lazyToText :: Data.ByteString.Lazy.ByteString -> Text
lazyToText = Data.Text.decodeUtf8 . Data.ByteString.concat . BL.toChunks

-- splitFlags :: ([a], [a], [a]) -> ([a], [a])
splitFlags :: ([String], [String], [String]) -> ([a], [String], [String])
splitFlags ([], flags, rest) = ([], flags, rest)
splitFlags ([x], flags, rest) = if x `elem` flagList then splitFlags ([], x : flags, rest) else splitFlags ([], flags, x : rest)
splitFlags (x:xs, flags, rest) = if x `elem` flagList then splitFlags (xs, x : flags, rest) else splitFlags (xs, flags, x : rest)

getFlagsAfterSplit :: (a, b, c) -> b
getFlagsAfterSplit (_, x, _) = x

getArgsAfterSplit :: (a, b, c) -> c
getArgsAfterSplit (_, _, x) = x

main :: IO ()
main = do
  args_ <- getArgs

  let result = splitFlags (args_, [], [])
  let flags = getFlagsAfterSplit result
  let args = getArgsAfterSplit result

  if "-H" `elem` flags then do
    print argsData
  else if "-v" `elem` flags then do
    print ("joh json encoder version " ++ version)
  else if "-V" `elem` flags then do
    BL.putStrLn $ encode $ object [jsonVersionPair]
  else do
    if not (null args) || "-e" `elem` flags then do
      let listOfPairs = buildPairList $ splitArgs delim args
      let o = object listOfPairs
      if "-p" `elem` flags then do
        BL.putStrLn $ encodePretty o
      else do 
        BL.putStrLn $ encode o
    else do
      die "error, no data passed in and -e flag not set"
    exitSuccess

  -- old test driver code below

  -- lets make a pair.
  -- a pair is a key/value pair for an Object. 
  -- type Pair = (Text, Value).  We will need to do some conversion for this to work!

  -- let k = fromString $ head aPair
  -- let v = String $ pack $ last aPair
  -- let myPair = (k, v)
  -- let pleaseWork = [myPair]



  -- let req = decode "{\"x\":3.0,\"y\":-1.0}" :: Maybe Coord
  -- let t = KVPair "bruh" 2
  -- let k_ = KVPair "test" 1

--   let req = decode "\"x\"=3.0 \"y\"=-1.0" :: Maybe Coord
  -- print req
  -- let reply = Coord 123.4 20

  -- BL.putStrLn (encode reply)
  -- BL.putStrLn (encode t)

  -- let v0 = String "cody"
  -- let v1 = Bool True
  -- let v2 = Number 1
  -- let v3 = Number 1.234
  -- let v5 = Null

  -- let o = object [
  --                   "name" .= v0
  --                 , "isDoggy"  .= v1
  --                 , "flips" .= v2
  --                 , "flips_precise" .= v3
  --                 -- , ("nuggets" .= v5)
  --               ]

  -- let o2 = object [
  --                   "nestedDataToo!" .= v1
  --                   , "nestedObject" .= o
  --                 ]

  -- BL.putStrLn (encodePretty o2)


