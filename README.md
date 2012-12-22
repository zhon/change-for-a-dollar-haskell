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

Before TDD came CDD (compiler driven development)

We need a binding for change?

```haskell
change :: Money -> [ Coin ]
change = []
```
What type is Money? What type is Coin?

```haskell
type Money = Int
type Coin = Int
change :: money -> [ Coin ]
change = []
```

Complier says our implementation is messed up

```haskell
change m = []
```


Acceptance Test
---------------

First we write a test

```haskell
import Test.QuickTest
```
Whoops

```haskell
import Test.QuickCheck
```

Abusing QuickCheck we write

```haskell
prop_change_for_42 n = forall choose (42,42) change n
```



