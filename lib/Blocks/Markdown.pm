package Blocks::Markdown;

use strict;
use warnings;

use Data::Dumper;

use base 'Text::Markdown';

#use Blocks::Parse qw/bparams/;
use Text::Balanced qw/extract_bracketed extract_tagged/;

our $VERSION   = '0.1';
$VERSION = eval $VERSION;
our @EXPORT_OK = qw(markdown blocks);

sub blocks{
    my ( $self, $text ) = @_;

    $DB::single = 1;

    if ( ! ref $self ){
        if ( $self ne __PACKAGE__ ){
            $text = $self;
            my $ob = __PACKAGE__->new();
            return $ob->blocks( $text );
        }else{
            croak( 'Calling' . $self . '->markdown ( as class method ) is not supported.');
        }
    }

    # We are seeking for \n<blocks://>\n only and that only

    $DB::single = 1;
    my $output;

    while( $text =~ s{(.*\n)}{}m ){
        my $line = $1;

        my @extraction = extract_tagged( $line, "<blocks_cms>", "</blocks_cms>",undef, {} );
        if ( $extraction[0] ) {
            # do not recurse yet
            if ( $self->{ resolve } ){
                my $params = bparams( $extraction[1] );
                $output .= $self->{ resolve }( $params );
            }else{
                # add nothing
                #$output .= "" . "\n";  # this \n should not be
            }
        } else {
            $output .= $extraction[1];
        }
    }

    return $output;
}

sub resolve_block {
    my ( $self, $code ) = @_;

    if ( ref $code eq 'CODE' ){
        $self->{ resolve } = $code;
    }
}

1;
