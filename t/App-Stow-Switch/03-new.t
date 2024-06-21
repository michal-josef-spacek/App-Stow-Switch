use strict;
use warnings;

use App::Stow::Switch;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
my $obj = App::Stow::Switch->new;
isa_ok($obj, 'App::Stow::Switch');
