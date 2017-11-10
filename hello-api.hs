{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

import Data.Aeson (ToJSON)
import GHC.Generics (Generic)
import Web.Scotty (get)
import Web.Scotty (json)
import Web.Scotty (scotty)
import Network.HostName (getHostName)

data Greeting = Greeting { greeting :: String
                         , hostname :: String
                         } deriving (Show, Generic)

instance ToJSON Greeting

main :: IO ()
main = do
  hostname <- getHostName
  scotty 3000 $ do
    get "/greeting" $ do
      json $ Greeting "Hello" hostname
