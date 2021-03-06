{-# LANGUAGE UnicodeSyntax, Safe #-}

-- | The data type definitions for the HTTP Link header.
module Network.HTTP.Link.Types where

import           Data.Text
import           Network.URI

-- | The link attribute key.
data LinkParam = Rel | Anchor | Rev | Hreflang | Media | Title | Title' | ContentType | Other Text
  deriving (Eq, Show)

-- | A single link.
data Link = Link URI [(LinkParam, Text)]
  deriving (Eq, Show)

-- | Extracts the URI from the link.
href ∷ Link → URI
href (Link h _) = h

-- | Extracts the parameters from the link.
linkParams ∷ Link → [(LinkParam, Text)]
linkParams (Link _ ps) = ps

lnk ∷ String → [(LinkParam, Text)] → Maybe Link
lnk u r = parseURI u >>= return . \x → Link x r
