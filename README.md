Change for a Dollar Kata in Haskell
===================================

Up and Running
-------
Install [Haskell](http://www.haskell.org/platform/)

Create a file ``change.hs``

with

```haskell

module CoinChanger where

```

Fire up ghci and load your file (or run it with runhaskell)

```shell
% ghci
Prelude> :load change
```

Interface
---------

In Haskell we define our function name and types first

```haskell
change :: Money -> [ Coin ]
```

Before TDD there was CDD (compiler driven development)

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
change :: money -> [ Coin ]
change = []
```

Complier says, "Your implementation doesn't match your signature"

```haskell
change _ = []
```

Acceptance Test
---------------

Finally we get to write a test!

Testing ``change 0`` would pass so we won't do that. Instead lets change the meaning of life.

```haskell
prop_ChangeFor42 m = forAll choose (42,42) change m = [25,10,5,1,1]
```

Compiler says, "``=`` should be ``==``"

```haskell
prop_ChangeFor42 m = forAll choose (42,42) change m == [25,10,5,1,1]
```

Compiler says, "Import the module that contains ``forAll`` and ``choose``."

```haskell
import Test.QuickTest
```

Compiler sweetly says, "I think you mean``QuickCheck``"

```haskell
import Test.QuickCheck
```

Compiler says, "You need parenthesis around each argument"

```haskell
prop_ChangeFor42 m = forAll (choose (42,42)) $ change m == [25,10,5,1,1]
```

Compiler says, "The last parameter should be a function that takes a ``Money`` and returns a ``Testable``"

```haskell
prop_ChangeFor42 m = forAll (choose (42,42)) $ \m -> change m == [25,10,5,1,1]
```

Run That Test
-------------

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
prop_ChangeFor0 m = forAll (choose (0,0)) $ \m -> change m == []
```

Running it
```shell
*CoinChanger> prop_ChangeFor0
```

Make it pass

```haskell
change :: Money -> [ Coin ]
change 0 = []
change _ = [25,10,5,1,1]
```

Running Mutiple Tests
---------------------

You're probably tired or running tests individually. I know I am!

Adding the following to the bottom of the file should fix that

```haskell
runTests = $quickCheckAll
```

Compiler says, "``$`` is a part of ``TemplateHaskell``, please let me know you want meta-programming!"

Adding
```haskell
{-# LANGUAGE TemplateHaskell #-}
```
to the top of file should do the trick.

Compiler says, "``quickCheckAll``! Where can I find that?"

```haskell
import Test.QuickCheck.All
```

But how do I _run_ all my tests?

```shell
*CoinChanger> runTests
```

There and Back Again
-------------

Enough evil pair! Lets write a check that requires a _real_ implementation.

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
Compiler says, "Obviously, you need to implement ``largestCoin``"

In TDD, we always start with a test.

```haskell
prop_LargestCoinPenny m = forAll (choose (1,4)) $ \m -> largestCoin m == 1
```
Compiler says, "You still need to implement ``largestCoin``?"

```haskell
largestCoin m = 1
```
Compiler says, "I am still confused! What type is ``largestCoin``?"

```haskell
largestCoin :: Money -> Coin
largestCoin _ = 1
```
Are you feeling nickel and dimed?

```haskell
prop_LargestCoinNickel m = forAll (choose (5,9)) $ \m -> largestCoin m == 5
prop_LargestCoinDime   m = forAll (choose (10,24)) $ \m -> largestCoin m == 10
```

```haskell
largestCoin :: Money -> Coin
largestCoin m = head dropWhile (>m) [10,5,1]
```

Compiler says, "Like Clojure, I need parenthesis around ``dropWhile`` and it's 2 args"

```haskell
largestCoin m = head $ dropWhile (>m) [10,5,1]
```

Refactor for Clairity
--------------------

...and finish the implementation

```haskell
largestCoin m = head $ dropWhile (>m) coins

coins = [25,10,5,1]
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

Hmm... What if we got our refactor wrong? A test would be perfect now.

```haskell
prop_ChangeEqualsChangePrime m = forAll (choose (0,100)) $ \m -> change m == change' m
```


