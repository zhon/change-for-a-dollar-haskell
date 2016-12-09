{-# LANGUAGE TemplateHaskell #-}

module CoinChanger where

import Test.QuickCheck
import Test.QuickCheck.All
import Data.List


type Money = Int
type Coin = Int

coins :: [ Coin ]
coins = [25,10,5,1]

change :: Money -> [ Coin ]
change 0 = []
change m = largestCoin m : change (m - largestCoin m)

largestCoin :: Money -> Coin
largestCoin m = head $ dropWhile (>m) coins

change' = unfoldr nextCoin
    where
        nextCoin 0 = Nothing
        nextCoin m = Just (largestCoin m, m - largestCoin m)


prop_ChangeFor42 = change 42 == [25,10,5,1,1]
prop_ChangeFor0 = change 0 == []
prop_ChangeRoundTrip m = forAll (choose (0,100)) $ \m -> m == sum (change m)

prop_LargestCoinPenny m = forAll (choose (1,4)) $ \m -> largestCoin m == 1
prop_LargestCoinNickel m = forAll (choose (5,9)) $ \m -> largestCoin m == 5
prop_LargestCoinDime   m = forAll (choose (10,24)) $ \m -> largestCoin m == 10

prop_ChangeEqualsChangePrime m = forAll (choose (0,100)) $ \m -> change m == change' m


runTests = $quickCheckAll

