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

Compiler says binding for change?

```haskell
change :: Money -> [ Coin ]
change = []
```
Compiler says: 
  What is Money? 
  What is Coin?

```haskell
type Money = Int
type Coin = Int
change :: money -> [ Coin ]
change = []
```

Complier says your implementation doesn't match you signature

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

Compiler says, 'It should have been an equals'

```haskell
prop_change_for_42 m = forAll choose (42,42) change m == [25,10,5,1,1]
```

Compiler doesn't know about forAll or choose.

It comes out of QuickTest or something

```haskell
import Test.QuickTest
```

Compiler sweetly says, "Did you mean QuickCheck?"

```haskell
import Test.QuickCheck
```

Compiler says you need parenthesis

```haskell
prop_change_for_42 m = forAll (choose (42,42)) $ change m == [25,10,5,1,1]
```

Compiler says, "The last parameter should be a function that take a Money and returns a Testable"

```haskell
prop_change_for_42 m = forAll (choose (42,42)) $ \m -> change m == [25,10,5,1,1]
```

