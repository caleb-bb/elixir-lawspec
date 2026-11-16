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

`itoa` and `atoi` here are two functions. This is a round-trip law with a three-row expectation table.

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
