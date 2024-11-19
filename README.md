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
$ ./bin/poteto HEAD~1
::error file=lib/poteto/generate_review.rb,line=63,col=3::Style/Documentation: Missing top-level documentation comment for `class Poteto::GenerateRubocopReview`.
::error file=lib/poteto/generate_review.rb,line=77,col=5::Metrics/AbcSize: Assignment Branch Condition size for rubocop_on_changes is too high. [<11, 13, 9> 19.26/17]
::error file=lib/poteto/generate_review.rb,line=77,col=5::Metrics/MethodLength: Method has too many lines. [19/10]
::error file=lib/poteto/generate_review.rb,line=83,col=60::Lint/ShadowingOuterLocalVariable: Shadowing outer local variable - `f`.
```
* corresponding diff
```bash
$ git diff HEAD~
```
```diff
diff --git a/lib/poteto/generate_review.rb b/lib/poteto/generate_review.rb
index 94b9a89..f458894 100644
--- a/lib/poteto/generate_review.rb
+++ b/lib/poteto/generate_review.rb
@@ -12,20 +12,9 @@ module Poteto
       @exclude = exclude
       @reviews = []
     end
-  end
-
-  class GenerateRubocopReview < GenerateReview
-    def initialize(commit_id, exclude: ["spec/", "test/"])
-      super(commit_id, exclude: exclude)
-      call
-    end
-
-    def call
-      @reviews << rubocop_on_changes(files_change_ranges_for_rubocop)
-    end
 
     def changed_files
-      git_args = ["git", "diff", "--diff-filter=ACM", "--name-only", "#{commit_id}..HEAD"]
+      git_args = ['git', 'diff', '--diff-filter=ACM', '--name-only', "#{commit_id}..HEAD"]
       command(git_args)
     end
 
@@ -52,36 +41,51 @@ module Poteto
     def change_ranges(files)
       files.to_h do |f|
         meta = command(["git diff #{commit_id}..HEAD -U0 -- #{f} | grep '^@@'"])
-        line_nos = meta.flat_map do |m|
-          remove, add = m.match(/^@@(.*)@@/)[1].strip.split()
-          line_nos = []
+        line_nos = meta.map do |m|
+          remove, add = m.match(/^@@(.*)@@/)[1].strip.split
+          hunk_line_nos = []
           unless remove.nil?
-            remove_start_line, _ = remove.split(",")
-            line_nos << remove_start_line.to_i.abs
+            remove_start_line, = remove.split(',')
+            hunk_line_nos << remove_start_line.to_i.abs
           end
           unless add.nil?
-            add_end_line, _ = add.split(",")
-            line_nos << add_end_line.to_i.abs
+            # the separation into components is just for readability
+            add_end_line, additions = add.split(',')
+            hunk_line_nos << [add_end_line, additions].map(&:to_i).sum
           end
-          line_nos
+          hunk_line_nos.minmax
         end
-        [f, [line_nos.min, line_nos.max]]
+        [f, line_nos]
       end
     end
+  end
+
+  class GenerateRubocopReview < GenerateReview
+    def initialize(commit_id, exclude: ['spec/', 'test/'])
+      super(commit_id, exclude: exclude)
+      call
...skipping...
-        line_nos = meta.flat_map do |m|
-          remove, add = m.match(/^@@(.*)@@/)[1].strip.split()
-          line_nos = []
+        line_nos = meta.map do |m|
+          remove, add = m.match(/^@@(.*)@@/)[1].strip.split
+          hunk_line_nos = []
           unless remove.nil?
-            remove_start_line, _ = remove.split(",")
-            line_nos << remove_start_line.to_i.abs
+            remove_start_line, = remove.split(',')
+            hunk_line_nos << remove_start_line.to_i.abs
           end
           unless add.nil?
-            add_end_line, _ = add.split(",")
-            line_nos << add_end_line.to_i.abs
+            # the separation into components is just for readability
+            add_end_line, additions = add.split(',')
+            hunk_line_nos << [add_end_line, additions].map(&:to_i).sum
           end
-          line_nos
+          hunk_line_nos.minmax
         end
-        [f, [line_nos.min, line_nos.max]]
+        [f, line_nos]
       end
     end
+  end
+
+  class GenerateRubocopReview < GenerateReview
+    def initialize(commit_id, exclude: ['spec/', 'test/'])
+      super(commit_id, exclude: exclude)
+      call
+    end
+
+    def call
+      @reviews << rubocop_on_changes(files_change_ranges_for_rubocop)
+    end
 
     def files_change_ranges_for_rubocop
       change_ranges(filter_files(changed_files))
     end
 
     def rubocop_on_changes(file_change_ranges)
-      rubocop_args = ["bundle", "exec", "rubocop", "--force-exclusion", "-fg", "-E", "--display-only-fail-level-offenses"]
-      file_change_ranges.flat_map do |f, f_change_range|
+      rubocop_args = ['bundle', 'exec', 'rubocop', '--force-exclusion', '-fg', '-E',
+                      '--display-only-fail-level-offenses']
+      file_change_ranges.flat_map do |f, f_change_ranges|
         rc_args = rubocop_args + [f]
         rubocop_failures = command(rc_args, expected_status_code: 256)
         rc_relevant_failures = rubocop_failures.filter do |f|
-          if f.start_with?("::error")
-            failure_line = f.split(",")[1].match(/line=(\d+)/)[1].to_i
-            f_change_range[0] <= failure_line && f_change_range[1] >= failure_line
+          if f.start_with?('::error')
+            failure_line = f.split(',')[1].match(/line=(\d+)/)[1].to_i
+            f_change_ranges.any? do |(hunk_start, hunk_end)|
+              hunk_start <= failure_line && hunk_end >= failure_line
+            end
           else
             false
           end
...skipping...
-        line_nos = meta.flat_map do |m|
-          remove, add = m.match(/^@@(.*)@@/)[1].strip.split()
-          line_nos = []
+        line_nos = meta.map do |m|
+          remove, add = m.match(/^@@(.*)@@/)[1].strip.split
+          hunk_line_nos = []
           unless remove.nil?
-            remove_start_line, _ = remove.split(",")
-            line_nos << remove_start_line.to_i.abs
+            remove_start_line, = remove.split(',')
+            hunk_line_nos << remove_start_line.to_i.abs
           end
           unless add.nil?
-            add_end_line, _ = add.split(",")
-            line_nos << add_end_line.to_i.abs
+            # the separation into components is just for readability
+            add_end_line, additions = add.split(',')
+            hunk_line_nos << [add_end_line, additions].map(&:to_i).sum
           end
-          line_nos
+          hunk_line_nos.minmax
         end
-        [f, [line_nos.min, line_nos.max]]
+        [f, line_nos]
       end
     end
+  end
+
+  class GenerateRubocopReview < GenerateReview
+    def initialize(commit_id, exclude: ['spec/', 'test/'])
+      super(commit_id, exclude: exclude)
+      call
+    end
+
+    def call
+      @reviews << rubocop_on_changes(files_change_ranges_for_rubocop)
+    end
 
     def files_change_ranges_for_rubocop
       change_ranges(filter_files(changed_files))
     end
 
     def rubocop_on_changes(file_change_ranges)
-      rubocop_args = ["bundle", "exec", "rubocop", "--force-exclusion", "-fg", "-E", "--display-only-fail-level-offenses"]
-      file_change_ranges.flat_map do |f, f_change_range|
+      rubocop_args = ['bundle', 'exec', 'rubocop', '--force-exclusion', '-fg', '-E',
+                      '--display-only-fail-level-offenses']
+      file_change_ranges.flat_map do |f, f_change_ranges|
         rc_args = rubocop_args + [f]
         rubocop_failures = command(rc_args, expected_status_code: 256)
         rc_relevant_failures = rubocop_failures.filter do |f|
-          if f.start_with?("::error")
-            failure_line = f.split(",")[1].match(/line=(\d+)/)[1].to_i
-            f_change_range[0] <= failure_line && f_change_range[1] >= failure_line
+          if f.start_with?('::error')
+            failure_line = f.split(',')[1].match(/line=(\d+)/)[1].to_i
+            f_change_ranges.any? do |(hunk_start, hunk_end)|
+              hunk_start <= failure_line && hunk_end >= failure_line
+            end
           else
             false
           end
```
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ophamster/poteto.
