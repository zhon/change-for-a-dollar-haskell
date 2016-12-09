Change for a Dollar Kata in Haskell
===================================

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

Example Test
------------

Finally we get to write a test!

Testing ``change 0`` would pass so we won't do that. Instead lets change the meaning of life.

```haskell
prop_ChangeFor42 = change 42 = [25,10,5,1,1]
```

Compiler says, "``=`` should be ``==``"

```haskell
prop_ChangeFor42 = change 42 == [25,10,5,1,1]
```

Run That Test
-------------

```haskell
import Test.QuickCheck
```

```shell
*CoinChanger> quickCheck prop_ChangeFor42
```

Wahoo a failing test. You can make it pass :-D

```haskell
change _ = [25,10,5,1,1]
```

Test Zero
---------

```haskell
prop_ChangeFor0 = change 0 == []
```

<span style="color:red">Red</span>

```shell
*CoinChanger> quickCheck prop_ChangeFor0
```

Green

```haskell
change :: Money -> [ Coin ]
change 0 = []
change _ = [25,10,5,1,1]
```

Running Mutiple Tests
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

There and Back Again
-------------

Enough evil pair writting **example tests**! Lets write a **property-based** test that requires a _real_ implementation.

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

Refactor for Clairity
--------------------

```haskell
coins :: [ Coin ]
coins = [25,10,5,1]

largestCoin m = head $ dropWhile (>m) coins
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

