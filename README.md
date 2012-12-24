Change for a Dollar Kata in Haskell
===================================

Up and Running
-------
Install [Haskell](http://www.haskell.org/platform/)

Fire up ghci and load your file (or run it with runhaskell)

```shell
% ghci
Prelude> :load change
```

Interface
---------

In haskell we define our function name and types first

```haskell
change :: Money -> [ Coin ]
```

Before TDD there was CDD (compiler driven development)

Compiler says, "You havn't implemented 'change'!"

```haskell
change :: Money -> [ Coin ]
change = []
```
Compiler askes:
  - What is Money?
  - What is Coin?

```haskell
type Money = Int
type Coin = Int
change :: money -> [ Coin ]
change = []
```

Complier says, "Your implementation doesn't match your signature"

```haskell
change m = []
```

Acceptance Test
---------------

Finally we get to write a test!

Testing 'change 0' would pass so we won't do that. Instead lets change the meaning of life.

```haskell
prop_change_for_42 m = forAll choose (42,42) change m = [25,10,5,1,1]
```

Compiler says, "'=' should be '=='"

```haskell
prop_change_for_42 m = forAll choose (42,42) change m == [25,10,5,1,1]
```

Compiler says, "Import the module that contains 'forAll' ond 'choose'."

I think they come from something like Test.QuickTest

```haskell
import Test.QuickTest
```

Compiler sweetly says, "I think you ment QuickCheck"

```haskell
import Test.QuickCheck
```

Compiler says, "You need parenthesis around each argument"

```haskell
prop_change_for_42 m = forAll (choose (42,42)) $ change m == [25,10,5,1,1]
```

Compiler says, "The last parameter should be a function that take a Money and returns a Testable"

```haskell
prop_change_for_42 m = forAll (choose (42,42)) $ \m -> change m == [25,10,5,1,1]
```

Run That Test
-------------

```shell
main> quickCheck prop_change_for_42
```

Wahoo a failing test. You can make it pass :-D

```haskell
change m = [25,10,5,1,1]
```

Test Zero
---------

```haskell
prop_change_for_0 m = forAll (choose (0,0)) $ \m -> change m == []
```

Make it pass

```haskell
change :: Money -> [ Coin ]
change 0 = []
change m = [25,10,5,1,1]
```

Test Identity
-------------

Enough evil pair! Lets write a check that requires a _real_ implementation.

```haskell
prop_change_identity m = forAll (choose (0,100)) $ \m -> m == sum change m
```

Implementation
--------------

```haskell
change :: Money -> [ Coin ]
change 0 = []
change m = largestCoin m : change (m - largestCoin m)
```
Compiler says, "Obviously, you need to implement largestCoin"

In TDD, we always start with a test.

```haskell
prop_largestCoin_penny m = forAll (choose (1,4)) $ \m -> largestCoin m == 1
```
Compiler asks, "What is largestCoin?"

```haskell
largestCoin m = 1
```
Compiler says, "You need to declare the type of 'largestCoin'"

```haskell
largestCoin :: Money -> Coin
largestCoin m = 1
```

```haskell
prop_largestCoin_nickel m = forAll (choose (5,9)) $ \m -> largestCoin m == 5
```

```haskell
largestCoin :: Money -> Coin
largestCoin m = head dropWhile (>m) [5,1]
```

Compiler says, "You need parenthesis around 'dropWhile' and it's args"

```haskell
largestCoin m = head $ dropWhile (>m) [5,1]
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

