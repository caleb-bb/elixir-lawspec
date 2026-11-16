# LawSpec Lesson 01 (Elixir): work plan

*Written by Claude, Monday, November 16, 2026, ~1:25 PM, at Caleb's request. A plan to edit, not a ruling. Repo facts marked "README, read Nov 16" come from one fetch of github.com/brain-fuel/lawspec today; check them against what your terminal says.*

## The deliverable

**A handwritten first tutorial for LawSpec, Elixir-targeted:** one law, taken from an empty directory to a passing generated test, written by you from your own walk through it. Laine's ask, as you relayed it Saturday: the tutorials in the repo are LLM-generated and he wants handwritten ones.

**Finish line for today (results, not time):** `notes.md` records every step from install to one passing law, and Laine has it as a gist or a branch. Prose polish is a later session.

**If the tooling fights you again:** the notes on that fight are still the deliverable. A first lesson has to get a newcomer through install, and you are the newcomer.

## Step 0: send Laine what you already have (5 minutes)

These are finished and unsent. One Signal message:

1. The crash you saw on Cake under 0.31.0 is gone under 0.32.0 (verified Wed Nov 11).
2. Two findings from the Nov 9 diff, as questions:
   - Keys fold into 0..15 as a UInt8, where the old generator ranged to 32. Intended?
   - The totality law generates valid Text only, where the hand-written property fed arbitrary binaries including invalid UTF-8. Intended, and where is invalid UTF-8 handled?
3. What happens to a law suite when an impure native adapter is left undeclared?
4. Is Elixir a supported `init` target today? The README's target table doesn't list it (see below).
5. "I'm writing lesson 01 by hand for Elixir today; notes to follow."

## Step 1: what to read first (cap it at 20 minutes)

Read only these, in this order. Everything else waits until a step fails.

| File in the repo | Why |
|---|---|
| `README.md`, install section | The current install route. README, read Nov 16: Node 22+, no Haskell toolchain, the compiler ships on npm as prebuilt WebAssembly, and the steps install from a local checkout (`npm install --save-dev ../lawspec/npm`). |
| `docs/how-to/install-and-init.md` | The official version of the thing your lesson walks through. Note every place it assumes knowledge a newcomer lacks. |
| `docs/how-to/targets/index.md` | **Whether Elixir is a documented target.** README's table lists java, python, javascript, typescript, go, haskell, kotlin, rust. Elixir appears only in the intro's list of languages. You have run LawSpec on Cake, so it works in practice; the docs may simply lag. |
| `docs/reference/language/laws-and-examples.md` | The syntax for the one law you will write. |
| One existing lesson 01 (Java, Python or JavaScript track, under `docs/`) | To see the shape Laine's current tutorials take, so yours can replace one. Skim; don't imitate the voice. |

Write down, as you read: **each sentence that made you stop.** Those are WTF-log entries.

## Step 2: the walk

Work in `lawspec-elixir-first-law` (already exists, with a `notes.md` skeleton). After every command, paste the command and the relevant output into `notes.md` before running the next one.

| # | Do | Record in `notes.md` |
|---|---|---|
| 1 | `type -a lawspec` | Every binary on the path and its version (`lawspec --version`). Saturday's finding: a stale npm global at `/opt/homebrew/bin/lawspec` (0.31.3) that asdf couldn't see. |
| 2 | Remove the stale Homebrew-prefix install | The exact command that worked. Saturday `npm uninstall` removed nothing ("wtf?"); find out why. |
| 3 | Install the version you want, the way the README says | Which route you used (npm registry, local checkout, asdf-managed Node) and which version you ended on. README names 0.24.0 released and 0.25.0 "in preparation" while you were running 0.32.0; note the mismatch for Laine. |
| 4 | `lawspec doctor` (listed in the README) | What it checks and whether it would have caught the stale binary. |
| 5 | `mix new . --app first_law` | Saturday's finding: `mix new .` refuses the hyphenated folder name; `--app first_law` is the fix. |
| 6 | `lawspec init` for Elixir | The exact flag (`--target elixir`, if that is what it takes), what files it created, what it printed. If it refuses Elixir, that is finding #1 for Laine and you stop here with a complete install lesson. |
| 7 | Open `lawspec.edn` | What is in it. README, read Nov 16: new projects start with `verification.layers: []` and you set it to `[:property :examples]`. Confirm that is still true. |
| 8 | Write one law | Pick something a 15-year-old can hold in their head. Suggestion: reversing a list twice returns the original list. Record the law's full text and every error on the way to valid syntax. |
| 9 | `lawspec check`, then `lawspec fmt` | Output of each. What `fmt` changed. |
| 10 | `lawspec generate` | Which files appeared and where. Open the generated test and read it. |
| 11 | `mix test` | Pass or fail, with output. If it fails, the failure and the fix are lesson material. |
| 12 | Break the law on purpose | Change the implementation so the law is false; run the tests; paste the counterexample. This is the moment a reader sees why laws matter. |

**The stopping rule:** when a step blocks you for more than about 15 minutes, write down exactly where you are stuck, mark it **[ask Laine]**, and send him the notes as they stand.

## Step 3: what to write

### `notes.md` (today)

Raw and chronological. Three sections:

1. **The walk.** Commands and output, in order, as above.
2. **WTF log.** Numbered. Start with the three from Saturday:
   - `lawspec update` and `lawspec fetch` do not upgrade the CLI (it wanted a `lawspec.edn`).
   - Check `type -a lawspec` before starting; a stale global can shadow the version you think you have.
   - `mix new .` breaks on hyphenated folder names.
3. **Questions for Laine.** Anything marked [ask Laine].

### The lesson itself (a later session, from the notes)

A Diátaxis tutorial: one guided path, no choices, no explanation beyond what the next step needs. Proposed outline:

1. What you will have at the end (one sentence and the passing test output).
2. Before you start (Node version, Elixir version, how to check for a stale install).
3. Make the project.
4. Initialize LawSpec.
5. Write your first law.
6. Generate and run the test.
7. Watch it catch a bug.
8. Where to go next (link out; no detail).

Rules for the prose: every command the reader types is shown with the output they should see; nothing is explained that the reader doesn't need for the next step; the "why" goes in an Explanation page and gets linked.

## Step 4: what goes to Laine today

- The `notes.md` as a gist, or a branch in the repo under `docs/` if you'd rather he see it in place. A gist avoids triggering a Copilot review.
- One line on where you stopped and what you need from him.

## Open questions this plan can't answer

- Is Elixir a supported `init` target, or was Cake set up another way?
- Which version should the lesson pin: the npm release or `main`?
- Does Laine want the Elixir track to mirror the existing eight-lesson shape, or is one good lesson the unit?
- Should the lesson live beside the Java/Python/JavaScript tracks or replace one?

## Files this plan leaves stale

`claude/lawspec_docs_skeleton.md` still names the nullary page as the first deliverable. Its WTF log (eight entries) and its questions for Laine are still good and feed Step 0 above.

