package Blocks::Controller::Root;
use Moose;
use namespace::autoclean;

use Data::Dumper;
use Encode;

use HTML::Element;
use HTML::TreeBuilder 5 -weak;
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

my @supported_languages = qw/pt en pt_BR/;

sub begin :Private {
    my ( $self, $c ) = @_;

    if ( ! $c->session->{ lang }  ) {
        $c->session->{ lang } = HTTP::AcceptLanguage->new( $c->request->env->{ HTTP_ACCEPT_LANGUAGE } )->match(
            @supported_languages
        );
    }
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $block = $self->_block( $c, 1 );
    $c->session->{ last_page } =  $block->idblock();
    $c->response->redirect( '/page/' . $block->idblock() );
}

sub lang :Local :Args(1) {
    my ( $self, $c, $arg ) = @_;

    $c->session->{ lang } = HTTP::AcceptLanguage->new( $arg )->match( @supported_languages );;

    my $block = $self->_block( $c, 1 );
    $c->session->{ last_page } =  $block->idblock();
    $c->response->redirect( '/page/' . $block->idblock() );
}

sub block :Path( '/block' ) :ActionClass('REST') { }

sub block_GET :Args(1) {
    my ( $self, $c , $arg ) = @_;

    my $block = _block( @_ );

    my $content = $self->_render( $c, $block );

    if ( $block ) {
            $c->response->body( $content );
    }else{
        $c->response->status(404);
        $c->response->body( 'Block not found' );
    }
}

sub block_POST {
    my ( $self, $c ) = @_;

    my $arg = $c->request->param("idblock");
    my $preview = $c->request->param("content");
    my $block = $self->_block( $c, $arg );
    $block->content( $preview );
    my $content = $self->_render( $c, $block );

    if ( $block ) {
            $c->response->body( $content );
    }else{
        $c->response->status(404);
        $c->response->body( 'Block not found' );
    }
}

sub page :Local :Args(1) {
    my ( $self, $c , $arg ) = @_;

    my $block = _block( @_ );

    my $content = $self->_render( $c, $block );

    if ( $block ) {
        # TODO choose template ( based on block? )
        $c->stash( {
            block => $content,
            page => {
                title => $block->title(),
            }
        });
    }else{
        $c->response->status(404);
        $c->response->body( 'Page not found' );
    }
}

sub _div {
    my ( $self, $c, $block ) = @_;

    my $tagsblock_rs = $c->model( 'Blocks::TagsBlock' );

    my @tags = $tagsblock_rs->search({ idblock => $block->idblock() });
    my $content = decode_utf8( markdown $block->content() );

    my $tree = HTML::TreeBuilder->new_from_content( $content );
    my $div = HTML::Element->new('div');

    my @class;
    for my $tag ( @tags ) {
        my $tagname = $tag->tag->name();
        $tagname =~ /class\:(.*)/;
        if ( $1 ) {
            push @class, $1;
        }
    }
    if ( @class ) {
        $div->attr( 'class', join( " ", @class ) );
    }
    $div->push_content( $tree  );

    return $div->as_HTML;
}

# block_process ( types on configuration )   raw/markdown/blocks
sub _render{
    my ( $self, $c , $block ) = @_;

    # dispatch
    if ( $block->type() eq 'markdown' ){
        return $self->_div( $c, $block );
    }
    if ( $block->type() eq 'raw' || $block->type() eq 'html') {
        return $block->content();
    }
    else{
        my $output;
        # TODO search by title
        for my $line ( split ( '\n', $block->content() ) ){
            chomp $line;
            my $block = $self->_block( $c, $line );
            if ( $block->type() eq "raw" ) {
                $output .= $block->content();
            }else{
                $output .= $self->_div( $c, $block );
            }
        }
        return $output;
    }

}

# block resolve ( language and name )
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
