package Blocks::Controller::Root;
use Moose;
use namespace::autoclean;

use Data::Dumper;

use HTTP::AcceptLanguage;
use Text::Markdown 'markdown';
use Try::Tiny;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=encoding utf-8

=head1 NAME

Blocks::Controller::Root - Root Controller for Blocks

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

my @supported_languages = qw/en pt/;

sub begin :Private {
    my ( $self, $c ) = @_;

    $c->session->{ lang } = HTTP::AcceptLanguage->new($_)->match(
        @supported_languages
    );

}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # redirect to block 1
    $c->response->redirect( '/page/1' );
}

sub block :Path( '/block' ) :Args(1) {
    my ( $self, $c , $arg ) = @_;

    my $block = _block( @_ );

    if ( $block ) {
        $c->response->body( markdown $block->content() );
    }else{
        $c->response->status(404);
        $c->response->body( 'Block not found' );
    }
}

sub page :Local :Args(1) {
    my ( $self, $c , $arg ) = @_;

    my $block = _block( @_ );

    if ( $block ) {
        $c->stash( {
            block =>  markdown( $block->content() ),
            page => {
                title => $block->title(),
            }
        });
    }else{
        $c->response->status(404);
        $c->response->body( 'Page not found' );
    }
}

sub _block {
    my ( $self, $c , $arg ) = @_;

    my $block_rs = $c->model( 'Blocks::Block' );
    my $language_rs = $c->model( 'Blocks::Language' );

    my $id = $language_rs->find({
        idblocks => $arg,
        language => $c->session->{ lang },
    });

    my $block;

    if ( $id ) {
        $block = $block_rs->find($id->linked_block);
    }else{
        $block = $block_rs->find($arg);
    }

    return $block;
}


=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Todo Devel

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
