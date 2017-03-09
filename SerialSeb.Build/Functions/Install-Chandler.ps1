$gemfile = "./Gemfile"
if (-not (test-path $gemfile)) {
    add-content -encoding ascii -path $gemfile -value "gem 'chandler'"
    add-content -encoding ascii -path $gemfile -value "source 'https://rubygems.org'"
}
bundle install --path vendor/ --binstubs
if ($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode)  }