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

Compiler says, "You havn't implemented 'change'"

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

Complier says, "Your implementation doesn't match you signature"

```haskell
change m = []
```

First Test
---------------

Finally we get to write a test!

Testing change 0 would pass so you won't do that.

Instead lets write change 42

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

Compiler sweetly says, "I think you ment QuickCheck?"

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

Wahoo a failing test. I can make that pass :-D

```haskell
prop_change_for_42 m = forAll (choose (42,42)) $ \m -> change m == [25,10,5,1,1]
```
