pckage Pollute;

use 5.006;
use strict;
no strict 'refs';
use warnings;
use vars qw/$Package $Package1 %Before/;

our $VERSION = '0.02';	# 16 August 2001.
#	Changes: see Changes file

sub Pollute(){
	($Package) = caller;
	($Package1) = caller(1);
	foreach (keys %{"${Package}::"}){
		$Before{$_} and next;
		*{"${Package1}::$_"} = *{"${Package}::$_"};
	};
	
	undef %Before;
	undef $Package;
	undef $Package1;
};


sub import{
	($Package) = caller;
	%Before = map {($_,1)} keys %{"${Package}::"};

	*{"${Package}::Pollute"} = \&Pollute;
};

1;
__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

Pollute - Perl extension to re-export imported symbols

=head1 SYNOPSIS

  use Pollute;
  use This;
  use That;
  use TheOther;
  Pollute;	# exports anything imported from This, That or TheOther

=head1 DESCRIPTION

  On use, all the symbols in the caller's symbol table are listed into
  %Pollute::Before, and the Pollute subroutine is exported (through direct
  symbol table manipulation, not through "Exporter.")

  After importing various things, run Pollute to export everything
  you imported since the C<use Pollute> line into the calling package.


=head2 EXPORT

the C<Pollute> function, which pollutes its caller
with the symbols listed in @Pollute::Symbols

=head1 AUTHOR

David Nicol, <lt>pollute_author@davidnicol.com<gt>

The name was suggested by Garrett Goebel.  I was going to
call it "ImportExport."

=head1 LICENSE

GPL/Artistic.  Enjoy.

=head1 SEE ALSO

L<perl>.

=cut
