use strict;
use warnings;

use App::Stow::Switch;
use English;
use File::Object;
use File::Spec::Functions qw(abs2rel);
use Test::More 'tests' => 4;
use Test::NoWarnings;
use Test::Output;
use Test::Warn;

# Test.
@ARGV = (
	'-h',
);
my $right_ret = help();
stderr_is(
	sub {
		App::Stow::Switch->new->run;
		return;
	},
	$right_ret,
	'Run help (-h).',
);

# Test.
@ARGV = (
	'-x',
);
$right_ret = help();
stderr_is(
	sub {
		warning_is { App::Stow::Switch->new->run } "Unknown option: x\n",
			'Warning about bad argument';
		return;
	},
	$right_ret,
	'Run help (-x - bad option).',
);

sub help {
	my $script = abs2rel(File::Object->new->file('04-run.t')->s);
	# XXX Hack for missing abs2rel on Windows.
	if ($OSNAME eq 'MSWin32') {
		$script =~ s/\\/\//msg;
	}
	my $right_ret = <<"END";
Usage: $script [-c config_dir] [-d stow_dir] [-h] [-l] [--version] [target]
	-c config_dir	Configuration directory (default value is \$HOME/.config/stow-switch)
	-d stow_dir	Stow directory (default value is '/usr/local/stow').
	-h		Print help.
	-l		List of targets.
	--version	Print version.
	target		Target name for switch.
END

	return $right_ret;
}
