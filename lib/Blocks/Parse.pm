package Blocks::Parse;

use strict;
use warnings;

use Data::Dumper;

use base 'Text::Markdown';

our $VERSION   = '0.1';
$VERSION = eval $VERSION;
our @EXPORT_OK = qw(bparams);

sub bparams {
    my ($text) = @_;

    $text = _process_line( $text );

    # REGEX SHOULD BE FIXED TO START WITH NUMBER
    my $id_match = qr/([\d+|,?]+)/;

    $text =~ $id_match;

    if ( $1 ) {
        return $1;
    }else{
        return undef;
    }
}

sub _process_line{
    my ($text) = @_;

    $text =~ /(.*)\n?/;

    return $1;

}


1;
__END__
1
id:1
last 10





