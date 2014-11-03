{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Network.HTTP.LinkSpec (module Network.HTTP.LinkSpec) where

import           Test.Hspec
import           Test.QuickCheck
import           Data.Monoid (mconcat)
import qualified Data.Text as T
import           Network.HTTP.Link

instance Arbitrary Link where
  arbitrary = do
    urlScheme <- elements ["http://", "https://", "ftp://", "git+ssh://"]
    urlDomain <- listOf1 $ elements ['a'..'z']
    urlTld <- elements ["com", "net", "org", "me", "is", "technology", "club"]
    urlPath <- listOf $ elements ['a'..'z']
    params <- listOf genParam
    return $ Link (T.pack $ mconcat [urlScheme, urlDomain, ".", urlTld, "/", urlPath]) params
    where genParam = do
            otherParamKey <- listOf1 $ elements ['a'..'z']
            paramKey <- elements [Rel, Rev, Title, Hreflang, Anchor, Media, ContentType, Other (T.pack otherParamKey)]
            paramValue <- listOf $ elements ['a'..'z']
            return (paramKey, T.pack paramValue)

spec :: Spec
spec = do
  describe "writeLinkHeader -> parseLinkHeader" $
    it "roundtrips successfully" $
      property $ \x -> parseLinkHeader (writeLinkHeader x) == Just x