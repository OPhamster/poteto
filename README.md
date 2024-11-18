# Poteto

* Currently only
  * generates the diff on certain files (as specified by exclude list embedded in the lib)
  * for each file tries to find the relevant linenos only, since we don't want to throw up 
    the entire file's violations to the dev.
  * For each file we get the line range of the changes by the diffs; both Max and min (the 
    algorithm to max and min is subject to change and testing as to where it gives the best results)
  * For each file we use the `max`, `min` line nos to project only those violations in between them
* Doesn't post to Github yet with the result via octokit

```bash
# config file
$ cat poteto.yaml 
reviewers:
  - rubocop

$ ./bin/poteto HEAD~ -n
::error file=bin/poteto,line=14,col=13::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=bin/poteto,line=14,col=19::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=bin/poteto,line=14,col=29::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=bin/poteto,line=17,col=13::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=bin/poteto,line=17,col=19::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=bin/poteto,line=17,col=36::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=bin/poteto,line=24,col=1::Lint/UselessAssignment: Useless assignment to variable - `config_file`.
::error file=bin/poteto,line=25,col=22::Lint/AssignmentInCondition: Use `==` if you meant to do a comparison or wrap the expression in parentheses to indicate you meant to assign in a condition.
::error file=bin/poteto,line=29,col=8::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=lib/poteto.rb,line=4,col=18::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=lib/poteto.rb,line=5,col=18::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=lib/poteto.rb,line=6,col=18::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=lib/poteto.rb,line=7,col=9::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=lib/poteto.rb,line=9,col=1::Style/Documentation: Missing top-level documentation comment for `module Poteto`.
::error file=lib/poteto.rb,line=13,col=27::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=lib/poteto.rb,line=17,col=20::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=lib/poteto/generate_review.rb,line=28,col=19::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=lib/poteto/generate_review.rb,line=28,col=26::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=lib/poteto/generate_review.rb,line=28,col=34::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=lib/poteto/generate_review.rb,line=28,col=55::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=lib/poteto/review.rb,line=4,col=3::Style/Documentation: Missing top-level documentation comment for `class Poteto::Review`.
::error file=lib/poteto/review.rb,line=15,col=3::Style/Documentation: Missing top-level documentation comment for `class Poteto::RubocopReview`.
::error file=poteto.gemspec,line=32,col=25::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=poteto.gemspec,line=34,col=23::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=poteto.gemspec,line=34,col=32::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=poteto.gemspec,line=35,col=3::Gemspec/OrderedDependencies: Dependencies should be sorted in an alphabetical order within their section of the gemspec. Dependency `octokit` should appear before `open3`.
::error file=poteto.gemspec,line=35,col=23::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=poteto.gemspec,line=36,col=23::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=poteto.gemspec,line=36,col=35::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=poteto.gemspec,line=37,col=23::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=poteto.gemspec,line=37,col=31::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=poteto.gemspec,line=38,col=35::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=poteto.gemspec,line=38,col=44::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=poteto.gemspec,line=39,col=35::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=poteto.gemspec,line=39,col=46::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=poteto.gemspec,line=40,col=35::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.

```
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ophamster/poteto.
