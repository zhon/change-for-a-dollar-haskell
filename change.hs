import Test.QuickCheck
import Data.List

type Money = Int
type Coin = Int
change :: Money -> [ Coin ]
change 0 = []
change m = largestCoin m : change (m - largestCoin m)

largestCoin :: Money -> Coin
largestCoin m = head $ takeWhile (>m) coins

coins = [25,10,5,1]


prop_change_for_42 m = forAll (choose (42,42)) $ \m -> change m == [25,10,5,1,1]

prop_change_for_0 m = forAll (choose (0,0)) $ \m -> change m == []

prop_change_identity m = forAll (choose (0,100)) $ \m -> m == sum (change m)

prop_largestCoin_penny m = forAll (choose (1,4)) $ \m -> largestCoin m == 1

prop_largestCoin_nickel m = forAll (choose (5,9)) $ \m -> largestCoin m == 5

