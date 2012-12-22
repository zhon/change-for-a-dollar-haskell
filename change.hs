import Test.QuickCheck

type Money = Int
type Coin = Int
change :: Money -> [ Coin ]
change m = []


prop_change_for_42 m = forAll (choose (42,42)) $ \m -> change m == [25,10,5,1,1]
