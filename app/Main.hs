{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Main where
import Prelude hiding (Bool)
import Prelude.Compat
import Data.Aeson
import Data.Aeson.Types
import Data.Scientific

import Control.Applicative (empty)
import qualified Data.ByteString.Lazy.Char8 as BL
import Data.Aeson.Encode.Pretty (encodePretty)
import System.Environment (getArgs)
import Data.List.Split ( split, splitOn )
import Data.Aeson.Encoding (pair)
import Data.Text (pack)
import Data.Aeson.Key
-- import System.Posix.Env.ByteString (getArgs)
-- import Data.ByteString (split, ByteString)
-- import Data.ByteString.Lazy (toChunks)

splitArgs :: Eq a => [a] -> [[a]] -> [[[a]]]
splitArgs delim [] = []
splitArgs delim [x] = splitOn delim x : splitArgs delim []
splitArgs delim (x:xs) = splitOn delim x : splitArgs delim xs

buildPairList :: [[String]] -> [(Key, Value)]
buildPairList [] = []
buildPairList [x] = [(k, v)]
  where 
    k = fromString $ head x
    v = String $ pack $ last x
buildPairList (x:xs) = (k, v) : buildPairList xs
  where 
    k = fromString $ head x
    v = String $ pack $ last x

main :: IO ()
main = do
  -- get the args from the command line
  args <- getArgs

  -- define a delim
  let delim = "="

  -- split this into a list of pairs
  let listOfPairs = buildPairList $ splitArgs delim args

  let o = object listOfPairs

  BL.putStrLn $ encodePretty o

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


