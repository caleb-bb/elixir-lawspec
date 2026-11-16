# LawSpec, Elixir, first law — walk notes
Date: Sat Nov 14, 2026 · start: 6:5_ PM
Versions: lawspec 0.32.0 · Elixir ____ · OTP ____ · Node ____

For every step: the command exactly as typed, the output pasted, and
anything that made me stop (WTF). No prose yet.

## 0. Starting state
- `pwd`, `ls -la` emtpy except for this markdown file `notes.md`
- Lawspec CLI is coming from NPM
- `lawspec --version` → 0.33.1

## 1. Make the Elixir project
- ? `mix new .` or `mix new first_law` — before or after init?


## 2. Init LawSpec
- ? `npx lawspec init --target elixir`
- Printed setup instructions (paste all of it):
- Files created (`git status` or `ls -R`):
- Contents of `lawspec.edn`:
- The starter spec it gave me (path + paste):
- WTF:

## 3. Check and explain
- `npx lawspec check` →
- `npx lawspec doctor` →
- `npx lawspec explain '<unit>::<law>'` →
- Same with `--view dev` →
- Could I say what the law means before running explain? (y/n, what I guessed)
- WTF:

## 4. Turn on verification, generate
- Edit `lawspec.edn`: `verification.layers` from `[]` to `[:property :examples]`
- `npx lawspec generate` →
- New files (paths):
- Which test library do the generated tests use?
- Anything added to `mix.exs` / deps I had to fetch?
- WTF:

## 5. Red
- `mix test` BEFORE writing the adapter →
- Is the failure message readable to someone who's never seen this?
- WTF:

## 6. Write the adapter
- File path it expects:
- Code I wrote:
- How did I know the module/function names it wanted?
- WTF:

## 7. Green
- `mix test` →
- How many cases ran? What does the output tell me was checked?
- WTF:

## 8. Break it on purpose
- The bug I introduced:
- `mix test` → (paste the counterexample)
- Did it shrink to something small?
- Put it back, rerun →

## 9. After
- End time:
- Total WTFs:
- The three sentences that would have saved me the most time:
- Questions for Laine:
