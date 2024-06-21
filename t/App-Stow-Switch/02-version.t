use strict;
use warnings;

use App::Stow::Switch;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($App::Stow::Switch::VERSION, 0.01, 'Version.');
