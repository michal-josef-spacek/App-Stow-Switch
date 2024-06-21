package App::Stow::Switch;

use strict;
use warnings;

use Curses::UI;
use Error::Pure qw(err);
use File::Find::Rule;
use File::Path qw(mkpath);
use File::Spec::Functions qw(catfile);
use File::Touch;
use Getopt::Std;
use IO::Barf qw(barf);
use List::MoreUtils qw(none);
use List::Util qw(max);
use Readonly;

Readonly::Scalar our $DEFAULT_STOW_DIR => '/usr/local/stow';

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my $self = bless {}, $class;

	# Object.
	return $self;
}

# Run.
sub run {
	my $self = shift;

	# Process arguments.
	$self->{'_opts'} = {
		'c' => catfile($ENV{'HOME'}, '.config', 'stow-switch'),
		'd' => $DEFAULT_STOW_DIR,
		'h' => 0,
		'l' => 0,
	};
	if (! getopts('c:d:hl', $self->{'_opts'}) || $self->{'_opts'}->{'h'}) {
		print STDERR "Usage: $0 [-c config_dir] [-d stow_dir] [-h] [-l] [--version] [target]\n";
		print STDERR "\t-c config_dir\tConfiguration directory (default ".
			"value is \$HOME/.config/stow-switch)\n";
		print STDERR "\t-d stow_dir\tStow directory (default value is '$DEFAULT_STOW_DIR').\n";
		print STDERR "\t-h\t\tPrint help.\n";
		print STDERR "\t-l\t\tList of targets.\n";
		print STDERR "\t--version\tPrint version.\n";
		print STDERR "\ttarget\t\tTarget name for switch.\n";
		return 1;
	}
	$self->{'_target'} = $ARGV[0];

	if (! -d $self->{'_opts'}->{'c'}) {
		mkpath($self->{'_opts'}->{'c'});
	}
	my $targets_dir = catfile($self->{'_opts'}->{'c'}, 'targets');
	if (! -d $targets_dir) {
		mkpath($targets_dir);
	}

	# Get targets list.
	my @targets = File::Find::Rule->file->relative->in($targets_dir);
	my $target_max_length = max(map { length($_); } @targets) || 0;

	# Check target.
	if (defined $self->{'_target'}) {
		if (none { $self->{'_target'} eq $_ } @targets) {
			err "Target '$self->{'_target'}' doesn't exist.";
		}

#	# Only one target.
#	} elsif (@targets == 1) {
#		$self->{'_target'} = $targets[0];

	# GUI for selecting of target.
	} else {
		# Window.
		my $cui = Curses::UI->new;
		my $win = $cui->add('window_id', 'Window');
		$win->set_binding(\&exit, "\cQ", "\cC");

		# Popup menu.
		my $popupbox = $win->add(
			undef, 'Popupmenu',
			'-labels' => {
				map { $_, $_ } @targets,
			},
			'-onchange' => sub {
				my $cui_self = shift;

				$self->{'_target'} = $cui_self->get;

				return;
			},
			'-values' => \@targets,
		);
		$popupbox->focus;

		$win->add(
			undef, 'Buttonbox',
			'-buttons' => [{
				'-label' => '[Create target]',
				'-value' => 1,
				'-shortcut' => 'C',
				'-onpress' => sub {
					my $create_target_button = shift;

					my $new_target = $create_target_button->root->question('Create target');
					if ($new_target) {
						File::Touch->new->touch(
							catfile($targets_dir, $new_target),
						);
					}

					return;
				},
			}],
			# TODO Delete target.
			'-x' => $target_max_length + 4,
		);

		$win->add(
			undef, 'Popupmenu',
			'-label' => {
			},
		); 

		# Loop.
		$cui->mainloop;
	}

	return 0;
}

1;


__END__

=pod

=encoding utf8

=head1 NAME

App::Stow::Switch - Base class for stow-switch script.

=head1 SYNOPSIS

 use App::Stow::Switch;

 my $app = App::Stow::Switch->new;
 exit $app->run;

=head1 METHODS

=head2 C<new>

 my $app = App::Stow::Switch->new;

Constructor.

Returns instance of object.

=head2 C<run>

 exit $app->run;

Run method.

Returns exit code.

=back

=head1 ERRORS

 run():
         Unicode block '%s' doesn't exist.

=head1 EXAMPLE

 use strict;
 use warnings;

 use App::Stow::Switch;

 # Arguments.
 @ARGV = (
         '-h',
 );

 # Run.
 exit App::Stow::Switch->new->run;

 # Output:
 # TODO

=head1 DEPENDENCIES

L<Class::Utils>,
L<Curses::UI>,
L<Encode>,
L<Error::Pure>,
L<Getopt::Std>,
L<List::MoreUtils>,
L<Unicode::Block::Ascii>,
L<Unicode::Block::List>.

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/App-Unicode-Block>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2021-2024 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
