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
$ ./bin/poteto HEAD~2 -n
::error file=bin/poteto,line=17,col=13::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=bin/poteto,line=17,col=19::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=bin/poteto,line=17,col=36::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=bin/poteto,line=24,col=1::Lint/UselessAssignment: Useless assignment to variable - `config_file`.
::error file=bin/poteto,line=25,col=22::Lint/AssignmentInCondition: Use `==` if you meant to do a comparison or wrap the expression in parentheses to indicate you meant to assign in a condition.
::error file=bin/poteto,line=29,col=8::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=lib/poteto.rb,line=6,col=18::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=lib/poteto.rb,line=7,col=9::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
::error file=lib/poteto.rb,line=9,col=1::Style/Documentation: Missing top-level documentation comment for `module Poteto`.
::error file=lib/poteto/review.rb,line=15,col=3::Style/Documentation: Missing top-level documentation comment for `class Poteto::RubocopReview`.
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
::error file=poteto.gemspec,line=40,col=35::Style/StringLiterals: Prefer
single-quoted strings when you don't need string interpolation or special
symbols.
```

corresponding diff
```diff
diff --git a/Gemfile.lock b/Gemfile.lock
index d135744..518d914 100644
--- a/Gemfile.lock
+++ b/Gemfile.lock
@@ -7,0 +8 @@ PATH
+      yaml (~> 0.2.0)
@@ -80,0 +82 @@ GEM
+    yaml (0.2.1)
diff --git a/README.md b/README.md
index 67464f5..e057cde 100644
--- a/README.md
+++ b/README.md
@@ -3,26 +3,54 @@
-TODO: Delete this and the text below, and describe your gem
-
-Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/poteto`. To experiment with that code, run `bin/console` for an interactive prompt.
-
-## Installation
-
-TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.
-
-Install the gem and add to the application's Gemfile by executing:
-
-    $ bundle add UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
-
-If bundler is not being used to manage dependencies, install the gem by executing:
-
-    $ gem install UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
-
-## Usage
-
-TODO: Write usage instructions here
-
-## Development
-
-After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.
-
-To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).
-
+* Currently only
+  * generates the diff on certain files (as specified by exclude list embedded in the lib)
+  * for each file tries to find the relevant linenos only, since we don't want to throw up
+    the entire file's violations to the dev.
+  * For each file we get the line range of the changes by the diffs; both Max and min (the
+    algorithm to max and min is subject to change and testing as to where it gives the best results)
+  * For each file we use the `max`, `min` line nos to project only those violations in between them
+* Doesn't post to Github yet with the result via octokit
+
+```bash
+# config file
+$ cat poteto.yaml
+reviewers:
+  - rubocop
+
+$ ./bin/poteto HEAD~ -n
+::error file=bin/poteto,line=14,col=13::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=bin/poteto,line=14,col=19::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=bin/poteto,line=14,col=29::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=bin/poteto,line=17,col=13::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=bin/poteto,line=17,col=19::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=bin/poteto,line=17,col=36::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=bin/poteto,line=24,col=1::Lint/UselessAssignment: Useless assignment to variable - `config_file`.
+::error file=bin/poteto,line=25,col=22::Lint/AssignmentInCondition: Use `==` if you meant to do a comparison or wrap the expression in parentheses to indicate you meant to assign in a condition.
+::error file=bin/poteto,line=29,col=8::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=lib/poteto.rb,line=4,col=18::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=lib/poteto.rb,line=5,col=18::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=lib/poteto.rb,line=6,col=18::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=lib/poteto.rb,line=7,col=9::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=lib/poteto.rb,line=9,col=1::Style/Documentation: Missing top-level documentation comment for `module Poteto`.
+::error file=lib/poteto.rb,line=13,col=27::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=lib/poteto.rb,line=17,col=20::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=lib/poteto/generate_review.rb,line=28,col=19::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=lib/poteto/generate_review.rb,line=28,col=26::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=lib/poteto/generate_review.rb,line=28,col=34::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=lib/poteto/generate_review.rb,line=28,col=55::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=lib/poteto/review.rb,line=4,col=3::Style/Documentation: Missing top-level documentation comment for `class Poteto::Review`.
+::error file=lib/poteto/review.rb,line=15,col=3::Style/Documentation: Missing top-level documentation comment for `class Poteto::RubocopReview`.
+::error file=poteto.gemspec,line=32,col=25::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=poteto.gemspec,line=34,col=23::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=poteto.gemspec,line=34,col=32::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=poteto.gemspec,line=35,col=3::Gemspec/OrderedDependencies: Dependencies should be sorted in an alphabetical order within their section of the gemspec. Dependency `octokit` should appear before `open3`.
+::error file=poteto.gemspec,line=35,col=23::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=poteto.gemspec,line=36,col=23::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=poteto.gemspec,line=36,col=35::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=poteto.gemspec,line=37,col=23::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=poteto.gemspec,line=37,col=31::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=poteto.gemspec,line=38,col=35::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=poteto.gemspec,line=38,col=44::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=poteto.gemspec,line=39,col=35::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=poteto.gemspec,line=39,col=46::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+::error file=poteto.gemspec,line=40,col=35::Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
+
+```
@@ -31 +59 @@ To install this gem onto your local machine, run `bundle exec rake install`. To
-Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/poteto.
+Bug reports and pull requests are welcome on GitHub at https://github.com/ophamster/poteto.
diff --git a/bin/poteto b/bin/poteto
index 406aff9..6383ad3 100755
--- a/bin/poteto
+++ b/bin/poteto
@@ -16,0 +17,3 @@ OptionParser.new do |parser|
+  parser.on("-f", "--config-file", "Name of the config file") do |c|
+    options[:config_file] = c
+  end
@@ -21,3 +24 @@ pr_id = ARGV[1]
-gr = Poteto::GenerateRubocopReview.new(commit_id)
-reviews = gr.call
-puts reviews
+config_file = options[:config_file]
@@ -24,0 +26 @@ if options[:no_post] = true
+  puts Poteto.generate_reviews(commit_id, nil).flatten.map(&:raw_data)
@@ -28 +30 @@ else
-  # Poteto::PostReview.new(options[:repo], commit_id, pr_id)
+  Poteto.perform(commit_id, pr_id, repo, config_file: nil)
diff --git a/lib/poteto.rb b/lib/poteto.rb
index b446509..e356bd9 100644
--- a/lib/poteto.rb
+++ b/lib/poteto.rb
@@ -6,0 +7 @@ require_relative "poteto/review"
+require "yaml"
@@ -10 +11,24 @@ module Poteto
-  # Your code goes here...
+
+  class << self
+    DEFAULT_CONFIG_FILE = "poteto.yaml"
+    def generate_reviews(commit_id, config_file)
+      config_file ||= DEFAULT_CONFIG_FILE
+      config = YAML.load_file(config_file)
+      config.fetch("reviewers").map do |reviewer|
+        case reviewer.to_sym
+        when :rubocop
+          Poteto::GenerateRubocopReview.new(commit_id).reviews
+        else
+          raise ArgumentError, "unknown Reviewer #{reviewer}"
+        end
+      end
+    end
+
+    def perform(commit_id, pr_id, repo, config_file: nil)
+      generate_reviews(commit_id, config_file).each do |reviews|
+        post_reviews(reviews, commit_id, pr_id, repo)
+      end
+    end
+
+    def post_reviews(reviews, commit_id, pr_id, repo); end
+  end
diff --git a/lib/poteto/generate_review.rb b/lib/poteto/generate_review.rb
index fb395cf..94b9a89 100644
--- a/lib/poteto/generate_review.rb
+++ b/lib/poteto/generate_review.rb
@@ -24 +24 @@ module Poteto
-      rubocop_on_changes(files_change_ranges_for_rubocop)
+      @reviews << rubocop_on_changes(files_change_ranges_for_rubocop)
@@ -54 +54 @@ module Poteto
-        meta = command(["git diff #{commit_id}..HEAD -- #{f} | grep '^@@'"])
+        meta = command(["git diff #{commit_id}..HEAD -U0 -- #{f} | grep '^@@'"])
@@ -63,2 +63,2 @@ module Poteto
-            add_end_line = add.split(",").map(&:to_i).sum
-            line_nos << add_end_line
+            add_end_line, _ = add.split(",")
+            line_nos << add_end_line.to_i.abs
diff --git a/lib/poteto/review.rb b/lib/poteto/review.rb
index 53fd1f3..d4a689e 100644
--- a/lib/poteto/review.rb
+++ b/lib/poteto/review.rb
@@ -5,3 +5,2 @@ module Poteto
-    attr_accessor :path
-    attr_accessor :line
-    attr_accessor :comment
+    attr_accessor :path, :line, :comment
+    attr_reader :raw_data
@@ -12,3 +11 @@ module Poteto
-      if file_name.present?
-        @path = file_name
-      end
+      @path = file_name unless file_name.nil?
@@ -20 +17 @@ module Poteto
-      super(data, file_name: file_name)
+      super(raw_data, file_name: file_name)
diff --git a/poteto.gemspec b/poteto.gemspec
index 5d1f7a6..ebed145 100644
--- a/poteto.gemspec
+++ b/poteto.gemspec
@@ -34 +33,0 @@ Gem::Specification.new do |spec|
-  # Uncomment to register a new dependency of your gem
@@ -37,0 +37 @@ Gem::Specification.new do |spec|
+  spec.add_dependency "yaml", "~> 0.2.0"
@@ -41,3 +40,0 @@ Gem::Specification.new do |spec|
-
-  # For more information and examples about making a new gem, check out our
-  # guide at: https://bundler.io/guides/creating_gem.html
diff --git a/poteto.yaml b/poteto.yaml
new file mode 100644
index 0000000..6297a21
--- /dev/null
+++ b/poteto.yaml
@@ -0,0 +1,2 @@
+reviewers:
+  - rubocop
```
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ophamster/poteto.
