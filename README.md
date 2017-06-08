Change for a Dollar Kata in Haskell Using Property-Based Test TDD
===================================

Change for a Dollar is just a fun name for the Coin Change Kata where you are given an amount and you must convert that into coins.

Up and Running
-------
Install [Haskell](http://www.haskell.org/platform/)

Create file ``change.hs`` containing

```haskell

module CoinChanger where

```

Fire up ghci and load your file (or run it with runhaskell)

```shell
% ghci
*CoinChanger> :load change
```

Interface
---------

In Haskell we define our function name and types first

```haskell
change :: Money -> [ Coin ]
```

Before TDD there was CDD (compiler driven development)

```shell
*CoinChanger> :load change
```

Compiler says, "You haven't implemented ``change``!"

```haskell
change :: Money -> [ Coin ]
change = []
```
Compiler asks:
  - What is ``Money``?
  - What is ``Coin``?

```haskell
type Money = Int
type Coin = Int
change :: Money -> [ Coin ]
change = []
```

Complier says, "Your implementation doesn't match your signature"

```haskell
change _ = []
```

First Test There and Back Again
------------

The simplest property I can think of is *the sum of change x will equal x*

```haskell
prop_ChangeRoundTrip m = forAll (choose (0,100)) m == sum (change m)
```
Compiler says, "You need parenthesis around each argument"

```haskell
prop_ChangeRoundTrip m = forAll (choose (0,100)) $ m == sum (change m)
```

Compiler says, "The last parameter should be a function that takes a ``Money`` and returns a ``Testable``"

```haskell
prop_ChangeRoundTrip m = forAll (choose (0,100)) $ \m -> m == sum (change m)
```

Run That Test
-------------

```haskell
import Test.QuickCheck
```

```shell
*CoinChanger> quickCheck prop_ChangeRoundTrip
```

```diff
-Red
```


Pass the Test
--------------

The simplest solution to passing this test is return the amount.

```haskell
change :: Money -> [ Coin ]
change m = m : []
```

```diff
+Green
```

Test No Weird Coins
---------

It looks like we need to add `coins` to the implementation and write another test.

```haskell
coins :: [ Coin ]
coins = [25,10,5,1]
```

```haskell
prop_ChangeContainsOnlyRealCoins m = forAll (choose (1,100)) $ \m -> all (\x -> elem x coins) $ change m
```

Passing
------
Making this pass is as simple as handing out pennies.


```haskell
change :: Money -> [ Coin ]
change m = []
change m = 1 : change (m-1)
```

```diff
+Green
```

Running Multiple Tests
---------------------

You're probably tired or running tests individually. I know I am!

Adding ``runTests`` fixes that.

```haskell
runTests = $quickCheckAll
```

Compiler says, "``$`` is a part of ``TemplateHaskell``, please let me know when you meta-program."

Adding the following to the top of the file will do the trick:
```haskell
{-# LANGUAGE TemplateHaskell #-}
```

Compiler is still not happy, "``quickCheckAll``! Where can I find that?"

```haskell
import Test.QuickCheck.All
```

But how do I _run_ all my tests?

```shell
*CoinChanger> runTests
```

```diff
+Green
```

Lower Denomination Coins Will Total Less Than the Next Larger Coin.
----

```haskell
prop_ChangeCoinsWillTotalLessThanNextLargerCoin = forAll (choose (1,4)) $ \m -> 
```

TODO Continue from here (Ignore everything below)



Implementation
--------------

```haskell
change :: Money -> [ Coin ]
change 0 = []
change m = largestCoin m : change (m - largestCoin m)
```
Compiler says, "You need to implement ``largestCoin``."

In TDD, we start with a test.

```haskell
prop_LargestCoinPenny m = forAll (choose (1,4)) $ \m -> largestCoin m == 1
```
Compiler says, "You still haven't implemented ``largestCoin``?"

```haskell
largestCoin _ = 1
```
Compiler says, "I am still confused! What type is ``largestCoin``?"

```haskell
largestCoin :: Money -> Coin
largestCoin _ = 1
```
Are you feeling nickel and dimed, yet?

```haskell
prop_LargestCoinNickel m = forAll (choose (5,9)) $ \m -> largestCoin m == 5
prop_LargestCoinDime   m = forAll (choose (10,24)) $ \m -> largestCoin m == 10
```
Enough hard coding, lets implementation it.

```haskell
largestCoin :: Money -> Coin
largestCoin m = head dropWhile (>m) [25,10,5,1]
```

Compiler says, "Like Clojure, I need parenthesis around ``dropWhile`` and it's 2 args"

```haskell
largestCoin m = head $ dropWhile (>m) [25,10,5,1]
```

Refactor for Clarity
--------------------

```haskell
coins :: [ Coin ]
coins = [25,10,5,1]

largestCoin m = head $ dropWhile (>m) coins
```

Lock Down Implementation
-----------------------

If someone adds a 50 cent coin to the end of coins, our code would break. We should add a **property test** for that.


```haskell
prop_CoinsAreOrderLargestToSmallest = coins == (reverse $ sort coins)
```

Refactor Away Recursion
-----------------------

```haskell
change' = unfoldr nextCoin
    where
        nextCoin 0 = Nothing
        nextCoin m = Just (largestCoin m, m - largestCoin m)
```

Compiler says, "``unfoldr``? ``unfoldr``?! Who has heard of ``unfoldr``?!!"

```haskell
import Data.List
```

Hmm... What if we got our refactor wrong? That is where ``QuickCheck`` shines.

```haskell
prop_ChangeEqualsChangePrime m = forAll (choose (0,100)) $ \m -> change m == change' m
```

Good work! It is time for cookies and milk!
------------------------------------------

