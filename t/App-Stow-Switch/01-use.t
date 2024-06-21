use strict;
use warnings;

use Test::More 'tests' => 3;
use Test::NoWarnings;

BEGIN {

	# Test.
	use_ok('App::Stow::Switch');
}

# Test.
require_ok('App::Stow::Switch');
