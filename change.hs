{-# LANGUAGE TemplateHaskell #-}

module CoinChanger where

import Test.QuickCheck
import Test.QuickCheck.All
import Data.List


type Money = Int
type Coin = Int

coins :: [ Coin ]
coins = [25,10,5,1]

{-change :: Money -> [ Coin ]-}
{-change 0 = []-}
{-change m = largestCoin m : change (m - largestCoin m)-}

largestCoin :: Money -> Coin
largestCoin m = head $ dropWhile (>m) coins

change2 :: Money -> [ Coin ]
change2 0 = []
change2 m = 1 : change (m-1)

change = change2

change' = unfoldr nextCoin
    where
        nextCoin 0 = Nothing
        nextCoin m = Just (largestCoin m, m - largestCoin m)


prop_ChangeRoundTrip m = forAll (choose (0,100)) $ \m -> m == sum (change m)
prop_ChangeContainsOnlyRealCoins m = forAll (choose (1,100)) $ \m -> all (\x -> elem x coins) $ change m


prop_ChangeSameCoinsWillTotalLessThanNextLargerCoin = forAll (choose (1,4)) $ \m -> group $ change m



prop_LargestCoinPenny m = forAll (choose (1,4)) $ \m -> largestCoin m == 1
prop_LargestCoinNickel m = forAll (choose (5,9)) $ \m -> largestCoin m == 5
prop_LargestCoinDime   m = forAll (choose (10,24)) $ \m -> largestCoin m == 10

prop_ChangeEqualsChangePrime m = forAll (choose (0,100)) $ \m -> change m == change' m

prop_CoinsAreOrderLargestToSmallest = coins == (reverse $ sort coins)

coin_count :: [Coin] -> Coin -> Int
coin_count xs c = (length . filter (==c)) xs
max_coin c1 c2 = floor ((c1-0.1)/c2)

pair_coins = zip (100:coins) coins

{-prop_EachCoinMustBeLessThanCoinCount m = forAll (choose (0,100)) $ \m -> all (\t -> 1==1  ) pair_coins change(m)-}

{-all ( 1==1  ) pair_coins change(7)-}

{-\m -> (change m)-}

{-map (\x -> div ((fst x)-1) (snd x )) $ zip (100:coins) coins-}

{-map (\x -> ((div((fst x)-1)  (snd x)), (snd x))) pair_coins-}

{-map (\x -> ((div((fst x)-1)  (snd x)), (snd x))) pair_coins-}


return []
runTests = $quickCheckAll

