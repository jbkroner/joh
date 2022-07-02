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

-- data Coord = Coord { x :: Double, y :: Double } deriving (Show)

-- data KVPair = KVPair { k :: String, v :: Int} deriving (Show)

-- data KVPair_ = KVPair_ { k_ :: String, v_ :: Int} deriving (Show)

-- -- core data type
-- -- data Value 
-- --   = Object Object
-- --   | Array Array
-- --   | String Text
-- --   | Number Scientific
-- --   | Bool Bool
-- --   | Null

-- b = "test"
-- c = 12345
-- customValue :: Value
-- customValue = object 
--   [
--     "list_price" .= (15000 :: Int)
--     , b .= (c :: Int)
--   ]

-- -- A ToJSON instance allows us to encode a value as JSON.

-- instance ToJSON Coord where
--   toJSON (Coord xV yV) = object [ "x" .= xV,
--                                   "y" .= yV ]

--   toEncoding Coord{..} = pairs $
--     "x" .= x <>
--     "y" .= y

-- instance ToJSON KVPair where 
--   toJSON (KVPair kV vV) = object [ "key" .= kV,
--                                    "val" .= vV ]

-- A FromJSON instance allows us to decode a value from JSON.  This
-- should match the format used by the ToJSON instance.

-- instance FromJSON Coord where
--   parseJSON (Object v) = Coord <$>
--                          v .: "x" <*>
--                          v .: "y"
--   parseJSON _          = empty

-- data Value 
--   = Object Object
--   | Array Array
--   -- | String Text
--   | Number Scientific
--   | Bool Bool
--   | Null

data Num = Num Float | Catdog Int deriving Show

main :: IO ()
main = do
  -- let req = decode "{\"x\":3.0,\"y\":-1.0}" :: Maybe Coord
  -- let t = KVPair "bruh" 2
  -- let k_ = KVPair "test" 1

--   let req = decode "\"x\"=3.0 \"y\"=-1.0" :: Maybe Coord
  -- print req
  -- let reply = Coord 123.4 20

  -- BL.putStrLn (encode reply)
  -- BL.putStrLn (encode t)
  
  let v0 = String "cody"
  let v1 = Bool True
  let v2 = Number 1
  let v3 = Number 1.234
  let v5 = Null

  let o = object [
                    "name" .= v0
                  , "isDoggy"  .= v1
                  , "flips" .= v2
                  , "flips_precise" .= v3
                  , ("nuggets" .= v5)
                ]
  BL.putStrLn (encodePretty o)
