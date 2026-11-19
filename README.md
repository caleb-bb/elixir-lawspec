# FirstLaw

This is a guide to using LawSpec to build software.

## Requirements

- Node 22 or later.
- The build tools of the target language you choose. See
  [compatibility](../reference/compatibility.md) for the supported versions.

You do not need a Haskell toolchain. The reference platforms are macOS and Linux.

## Installation

First, let's set up LawSpec for our project. This step just gets all the files and tools in place so that we can start writing laws for our Elixir project.

Run

```sh
git clone https://github.com/brain-fuel/lawspec.git lawspec
cd lawspec/npm && npm install && cd -
```

to install the development checkout. Then create `lawspec-example`. You want `lawspec-example` and `lawspec` (cloned from Github) to both live in the same parent directory. Then run:

```sh
mix new lawspec-example
cd lawspec-example
node ../lawspec/npm/bin/lawspec.mjs init --target elixir
npm install --save-dev ../lawspec/npm
npx lawspec --version
npx lawspec check
npx lawspec explain 'example.codec::codec'
npx lawspec doctor
```

Since we're running an Elixir project, we want to replace the contents of `test/test_helper.ex` with

``` elixir
ExUnit.start(formatters: [ExUnit.CLIFormatter, LawSpec.Beam.ExUnitFormatter])
```

Now, when you run `lawspec init --target elixir` you should have something like

``` sh
➜  lawspec-elixir-first-law git:(master) ✗ lawspec init --target elixir
(node:72690) ExperimentalWarning: WASI is an experimental feature and might change at any time
(Use `node --trace-warnings ...` to show where the warning was created)
Resolving Hex dependencies...
Resolution completed in 0.008s
All dependencies have been fetched
Configured elixir. Existing build files preserved.
Dependencies are installed and lawspec doctor passes.
Next: lawspec generate, then lawspec test.
```

You should have:

- a `lawspec.edn` in your project root that looks kind of like this:

``` edn

{
   2 │   :manifest-version 1
   3 │   :component {
   4 │     :name "lawspec-elixir-first-law"
   5 │     :version "0.1.0"
   6 │   }
   7 │   :language-profile "1.0-rc.2"
   8 │   :verification {
   9 │     :layers []
  10 │   }
  11 │   :sources ["laws"]
  12 │   :targets [
  13 │     {
  14 │       :language :elixir
  15 │       :root "."
  16 │     }
  17 │   ]
  18 │ }
```

- a `laws` directory containing an `atoi_codec.lawspec` that looks something like:

```
unit example.codec

itoa of type Int32 -> Text
atoi of type Text -> Int32

law codec is
  description:
    "Converting an integer to decimal text and reading it back preserves it."
  end description

  definition:
    for all (x of type Int32) =>
      atoi (itoa x) must be x
    end for all
  end definition

  expect itoa x = encoded
  expect atoi encoded = x
  in table (x, encoded):
    row -42, "-42"
    row 0, "0"
    row 42, "42"
  end table
end law
end unit
```

`itoa` and `atoi` here are two functions. This is a round-trip law with a three-row expectation table. What does that actually say? Briefly: you have two functions named `itoa` and `atoi`. The `codec` law specifies a round-trip: if you feed an Int32 to `itoa` and feed the output of `itoa` to `atoi`, then you get back whatever the original input was. The `in table` block says what specific values `encoded` and `x` should have relative to one another for certain inputs.



## Activation

LawSpec can verify laws in multiple ways. Each of those ways is called a "layer". `lawspec.edn` has a key, `:verification`, and one of that key's values is `:layers`, which has its own value, `[]`, an empty list. Even when that list is empty, LawSpec still does its compiler checks on definitions. Ergo, LawSpec always checks that your law file parses and type-checks. If you run `lawspec check` right now, it will pass, but warn you that it didn't actually test anything (besides compiler checks on definitions). 

If you run `lawspec check` right now, you should get:

``` sh

Compiled 1 law(s). Intrinsic definition checks passed. **No law checks selected.**
```

Now go into your `lawspec.edn` and change `:layers`' line to:

``` edn
    :layers ["property" "examples"]
```

Run `lawspec check` again and you'll get something more like:


``` sh
Compiled 1 law(s). Intrinsic definition checks passed. Evidence: 0 proved, 0 exhaustively checked, 0 property tested, 0 measured, 0 runtime checked, 0 default handler, 2 assumed / external, 1 planned.
```

Run `lawspec generate` and you should get

``` sh
elixir: 26 applied change(s), 0 user adapter(s) preserved.
```

Then run `mix test`. You should get some test failures now. They should all fail on `not implemented: example.codec::itoa`.

## Implementation

This means you haven't implemented the adapter yet. So, it's time to do that. But before we do, a brief word on what adapters actually are.

LawSpec gives you an ML-like syntax for specifying laws. These laws are mathematical statements that must be true of a codebase. Your actual code, the *native* code, has to follow LawSpec as a set of constraints. But LawSpec lives in its own language, its own little country, whereas your native code lives in whatever programming language you already write in. The laws need some sort of way to connect to your native code. The adapters are what do that.


### How LawSpec sees your native code
The process is simple.

1. The laws written in LawSpec specify a law: all As must be B.
2. The LawSpec compiler reads the laws and uses them to generate property tests
3. The property tests call functions in the adapter, which call functions in your native code.
4. Your code passes or fails the generated property tests.

So, from a ten-thousand foot view: you write laws in LawSpec that generate property tests, and you write adapters that plug your native code into the property tests, and you just trust the LawSpec compiler that its generated property tests reflect its laws.

### itoa and atoi

Back in the Jurassic Era, when the only people working on computers were fat guys who looked like George RR Martin and had fingers covered in Cheetoh dust, people wrote things in C. C tends to use terse names for things because it comes from an era when memory was at a premium. Two very common functions back then were integer-to-ASCII (itoa) and ASCII-to-integer (atoi). In Elixir, these roles are filled by `Integer.to_string/1` and `String.to_integer/1`.

That `not implemented: example.codec::itoa` error from before is happening because you have not yet implemented the adapter to plug your code into the generated tests. So let's do that.

### Example.Codec

The adapter you want to work on has already been stubbed out by the LawSpec compiler and lives under `lib/example_codec.ex`. It looks like this:

``` elixir
# User-owned LawSpec adapter. Implement these functions.
defmodule Example.Codec do
  @spec itoa(-2_147_483_648..2_147_483_647) :: binary()

  def itoa(_int32) do
    raise "Not implemented: example.codec::itoa"
  end

  @spec atoi(binary()) :: -2_147_483_648..2_147_483_647

  def atoi(_text) do
    raise "Not implemented: example.codec::atoi"
  end
end
```

Stop now and try and implement it yourself. It's almost trivial. You can figure it out from how I explained `atoi` and `itoa`.

Finished? It should look like this:

``` elixir
# User-owned LawSpec adapter. Implement these functions.
defmodule Example.Codec do
  @spec itoa(-2_147_483_648..2_147_483_647) :: binary()

  def itoa(int32) do
    Integer.to_string(int32)
  end

  @spec atoi(binary()) :: -2_147_483_648..2_147_483_647

  def atoi(text) do
    String.to_integer(text)
  end
end
```

This will pass when you run `mix test`.

[terminal output needed]

### Now, let's break it

A test that has only ever passed usually doesn't prove anything. You want to see it fail at least once.

First, let's break `itoa` in the adapter `Example.Codec` by deleting the sign:

``` elixir
def itoa(int32) do
  Integer.to_string(abs(int32))
end
```

Run `mix test` again and you should get failures from both layers. The examples layer fails on the hardcoded `row -42, "-42"`: thanks to the absolute value function, `itoa` now returns `"42"` where the row expects `"-42"`. The property layer fails too, and for a different reason. It went looking for an input where what went in is not what came back, and it found one on its own. You never told it which number to try. The round trip breaks, invalidating the law and failing the test.

[terminal output needed]

Now, that break is caught by the hardcoded table, so a skeptical person could assert that we have not really demonstrated anything about the property tests. Very well, then. Let's break `itoa` a little differently:

``` elixir
def itoa(int32) when int32 > 42, do: "1000"
def itoa(int32), do: Integer.to_string(int32)
```

Note that none of the three hardcoded rows is above 42, so none of them reaches the broken clause, and all three pass. Only the property tests can catch this. Run `mix test` and seeing is believing: the property tests work!

[terminal output needed]

Now change your adapter back to:

``` elixir
# User-owned LawSpec adapter. Implement these functions.
defmodule Example.Codec do
  @spec itoa(-2_147_483_648..2_147_483_647) :: binary()

  def itoa(int32) do
    Integer.to_string(int32)
  end

  @spec atoi(binary()) :: -2_147_483_648..2_147_483_647

  def atoi(text) do
    String.to_integer(text)
  end
end
```

Run `mix test` one more time and everything passes again.

[terminal output needed]

