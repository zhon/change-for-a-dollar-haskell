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

{-change2 :: Money -> [ Coin ]-}
{-change2 0 = []-}
{-change2 m = 1 : change (m-1)-}

{-change = change2-}

change' = unfoldr nextCoin
    where
        nextCoin 0 = Nothing
        nextCoin m = Just (largestCoin m, m - largestCoin m)


prop_ChangeRoundTrip m = forAll (choose (0,100)) $ \m -> m == sum (change m)
prop_ChangeContainsOnlyRealCoins m = forAll (choose (1,100)) $ \m -> all (\x -> elem x coins) $ change m


prop_ChangeSameCoinsWillTotalLessThanNextLargerCoin = forAll (choose (0,100)) $ \m ->
  let _change = change m
  in all (\x -> (maxAllowedCoins coins x) >= (coinCount _change  x)) $ _change

coinCount :: [Coin] -> Coin -> Int
coinCount xs c = (length . filter (==c)) xs

higherCoin :: [Coin] -> Coin -> Coin
higherCoin (_:[]) _ = maxBound::Coin
higherCoin (x:y:xs) c
  | x == c && y > c = y
  | y == c && x > c = x
  | otherwise = higherCoin (y:xs) c

maxAllowedCoins :: [Coin] -> Coin -> Int
maxAllowedCoins xs c = ((higherCoin xs c)-1) `div` c


prop_LargestCoinPenny m = forAll (choose (1,4)) $ \m -> largestCoin m == 1
prop_LargestCoinNickel m = forAll (choose (5,9)) $ \m -> largestCoin m == 5
prop_LargestCoinDime   m = forAll (choose (10,24)) $ \m -> largestCoin m == 10

prop_ChangeEqualsChangePrime m = forAll (choose (0,100)) $ \m -> change m == change' m

prop_CoinsAreOrderLargestToSmallest = coins == (reverse $ sort coins)


return []
runTests = $quickCheckAll
