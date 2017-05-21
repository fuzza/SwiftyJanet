# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
declared_trivial = github.pr_labels.include? "trivial"

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress and shouldn't be merged") if github.pr_labels.include? "WIP"

# Warn when there is a big PR
warn("This PR seems to be big. Is there any chance to reduce it's size to simplify and speedup code review?") if git.lines_of_code > 500

# Warn if CI config was changed
codecov_updated = !git.modified_files.grep(/.codecov.yml/).empty?
travis_updated = !git.modified_files.grep(/.travis.yml/).empty?
message("CI job config is updated") if codecov_updated || travis_updated

# Notify if Dangerfile itself was modified
message("Danger config is updated") if !git.modified_files.grep(/Dangerfile/).empty?

# Notify if Fastlane config was modified
message("Fastlane config is updated") if !git.modified_files.grep(/fastlane\/Fastfile/).empty?

# Notify if Gemfile or Gemfile.lock was updated
gemfile_updated = !git.modified_files.grep(/Gemfile/).empty?
lockfile_updated = !git.modified_files.grep(/Gemfile.lock/).empty?

# Notify if Gemfile or Gemfile.lock was updated
message("Rubygems list is updated") if gemfile_updated || lockfile_updated

# Warn if Gemfile was updated without updating Gemfile.lock
if gemfile_updated && !lockfile_updated
  warn("Gemfile was updated, but threr is not changes in Gemfile.lock. Did you forget to commit it?")
end

# Notify if Brewfile was modified
message("Brew dependency list is updated") if !git.modified_files.grep(/Brewfile/).empty?

# Warn when either the podspec or Cartfile + Cartfile.resolved has been updated,
# but not both.
podspec_updated = !git.modified_files.grep(/SwiftyJanet.podspec/).empty?
cartfile_updated = !git.modified_files.grep(/Cartfile/).empty?
cartfile_resolved_updated = !git.modified_files.grep(/Cartfile.resolved/).empty?

if podspec_updated && (!cartfile_updated || !cartfile_resolved_updated)
  warn("The `podspec` was updated, but there were no changes in either the `Cartfile` nor `Cartfile.resolved`. Did you forget updating `Cartfile` or `Cartfile.resolved`?")
end

if (cartfile_updated || cartfile_resolved_updated) && !podspec_updated
  warn("The `Cartfile` or `Cartfile.resolved` was updated, but there were no changes in the `podspec`. Did you forget updating the `podspec`?")
end

# Run swiftlint
swiftlint.lint_files

# Validate commit rules
commit_lint.check warn: :all

# Report unit tests result
junit.parse "fastlane/test_output/report-ios.junit"
junit.report

# Report slowest unit test
all_test = junit.tests.map(&:attributes)
slowest_test = all_test.sort_by { |attributes| attributes[:time].to_f }.last

message = "### Slowest tests \n\n"
message << "File | Name | Time |\n"
message << "| --- | ----- | ----- |\n"
message << "| #{slowest_test[:file]} | #{slowest_test[:name]} | #{slowest_test[:time]} |\n"
markdown message
