use lib '.';
use strict;
use warnings;

use inc::Module::Install;

# Definition.
abstract 'Tool to switch stow dist for command.';
author 'Michal Josef Spacek <skim@cpan.org>';
author_requires 'English' => 0;
author_requires 'File::Object' => 0.05;
author_requires 'Test::More' => 0;
author_requires 'Test::NoWarnings' => 0;
author_requires 'Test::Pod' => 0;
author_requires 'Test::Pod::Coverage' => 0;
install_script 'bin/stow-switch';
license 'bsd';
name 'App-Stow-Switch';
readme_from 'bin/stow-switch';
recursive_author_tests('xt');
requires 'Curses::UI' => 0;
requires 'Encode' => 0;
requires 'Error::Pure' => 0.15;
requires 'File::Find::Rule' => 0;
requires 'File::Path' => 0;
requires 'File::Spec::Functions' => 0;
requires 'Getopt::Std' => 0;
requires 'IO::Barf' => 0;
requires 'List::MoreUtils' => 0;
requires 'perl' => '5.6.0';
resources 'bugtracker' => 'https://github.com/michal-josef-spacek/App-Stow-Switch/issues';
resources 'homepage' => 'https://github.com/michal-josef-spacek/App-Stow-Switch';
resources 'repository' => 'git://github.com/michal-josef-spacek/App-Stow-Switch';
test_requires 'English' => 0;
test_requires 'Error::Pure::Utils' => 0;
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
test_requires 'Test::Output' => 0;
tests_recursive;
version '0.01';

# Run.
WriteAll();
