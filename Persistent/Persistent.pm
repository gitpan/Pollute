package Pollute::Persistent;

use 5.006;
use strict;
no strict 'refs';
no warnings;	# all those subroutine redefinitions :)
use vars qw/$Package %Before/;

our $VERSION = '0.03';

sub import{
	my ($Package) = caller;
	my %Before = map {($_,1)} keys %{"${Package}::"};
	
	*{"${Package}::import"} = sub {

		my %Symbols;	# will be remembered in closure 
		foreach (keys %{"${Package}::"}){
			$Before{$_} and next;
			$Symbols{"${Package}::$_"} = $_ ;
			# print "will set *{\"PACKAGE::$_\"} to *{${Package}::$_} \n";
		};
		undef %Before;
		*{"${Package}::import"} =
		    sub {	# may give a redef. warning
			($Package) = caller;
			foreach (keys %Symbols) {
				# print "setting *{\"${Package}::$Symbols{$_}\"} = *{$_}\n";
				*{"${Package}::$Symbols{$_}"} = *{$_};
			};
		    };
		goto &{"${Package}::import"};
	};
};

1;
__END__

=head1 NAME

Pollute::Persistent - Perl extension to re-export imported symbols

=head1 SYNOPSIS

  use Pollute::Persistent;
  use This;
  use That;
  use TheOther;
  	# exports anything imported from This, That or TheOther

=head1 DESCRIPTION

  On use, all the symbols in the caller's symbol table are listed into
  %Pollute::Before, and the Pollute subroutine is exported (through direct
  symbol table manipulation, not through "Exporter.")

  Pollute::Persistent rewrites its caller's import routine.
  for later use.  Example:

  In one file, called MyFavoriteModules.pm:
  package MyFavoriteModules;
  use Pollute::Persistent;
  use fred;
  use jim;
  use shiela;

  In another file:
  use MyFavoriteModules;	# imports all symbols exported by fred, jim and shiela

  In yet another file:
  use MyFavoriteModules;	# uses newly-defined import function.


=head2 EXPORT

Pollute::Persistent clobbers its caller's import routine.

=head1 AUTHOR

David Nicol, <lt>pollute_author@davidnicol.com<gt>

=head1 LICENSE

GPL/Artistic.  Enjoy.

=head1 SEE ALSO

L<perl>.

=cut
