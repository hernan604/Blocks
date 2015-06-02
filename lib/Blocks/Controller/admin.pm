package Blocks::Controller::admin;
use Moose;
use namespace::autoclean;

use Data::Dumper;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blocks::Controller::admin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub begin :Private {
    my ( $self, $c ) = @_;

    if (! $c->user() ){
        $c->session->{ return_uri } = $c->request->uri;
        $c->response->redirect( '/auth/login' );
    }
}

# login
sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->redirect( '/admin/blocks' );
}

sub blocks :Local :ActionClass('REST') { }

sub blocks_GET {
    my ( $self, $c ) = @_;

    my $block_rs = $c->model( 'Blocks::Block' );

    my @blocks = $block_rs->search({},{ rows => 10 });

    $c->stash( blocks => \@blocks );

}

sub blocks_POST {
    my ( $self, $c ) = @_;

    my $param = $c->request->param("title");

    my $block_rs = $c->model( 'Blocks::Block' );

    my @blocks = $block_rs->search({ title => { like => $param } });

    $c->stash( blocks => \@blocks );
}

sub block :Local :ActionClass('REST') { }

sub block_GET :Args(1){
    my ( $self, $c, $arg ) = @_;

    my $block_rs = $c->model( 'Blocks::Block' );

    my $block;
    if ( $arg ) {
        $block = $block_rs->find($arg);
    }

    if ( $block ){
        $c->stash(
            block => $block,
        );
    }else{
        $c->stash(

        );
    }
}

sub block_POST :Args(1) {
    my ( $self, $c, $arg ) = @_;

    my $title = $c->request->param("title");
    my $content = $c->request->param("content");
    my $type = $c->request->param("type");

    my $block_rs = $c->model( 'Blocks::Block' );
    my $block;
    if ( $arg ){
        $block = $block_rs->find($arg);
        if ( $block ) {
            $block->type( $type );
            $block->title( $title );
            $block->content( $content );
            $block->update();
        }else{
            $c->response->code( 500 );
            die;
        }
    }else{
        $block = $block_rs->create({
            title => $title,
            content => $content,
        });
        $block->update();
    }
    $c->response->redirect( '/admin/block/'. $block->idblock() );
}

sub languages :Local :ActionClass( 'REST' ) { }

sub languages_GET :Args(1) {
    my ( $self, $c, $arg ) = @_;

    my $languages_rs = $c->model( 'Blocks::Language' );
    my @languages = $languages_rs->search([  { idblocks => $arg }, { linked_block => $arg} ] );

    $c->stash({
        idblock     => $arg,
        languages   => \@languages,
    });

}

sub languages_POST :Args(1) {
    my ( $self, $c, $arg ) = @_;

    my $language = $c->request->param("language");

    my $block_rs = $c->model( 'Blocks::Block' );
    my $languages_rs = $c->model( 'Blocks::Language' );

    my ( $block, $lang );

    $block = $block_rs->create({
        title => $arg,
        content => undef,
    });
    $block->update();

    $lang = $languages_rs->create({
        idblocks        => $arg,
        language        => $language,
        linked_block    => $block->idblock(),
    });

    $c->response->redirect( '/admin/block/' .  $block->idblock() );

}

# makes more sense chained

sub tags :Local :ActionClass('REST') { }

sub tags_GET{
    my ( $self, $c, $arg ) = @_;

    my $tags_rs = $c->model( 'Blocks::Tag' );

    my @tags = $tags_rs->all;

    $c->stash( tags => \@tags );

}

sub tags_POST{
    my ( $self, $c, $arg ) = @_;

    my $tag = $c->request->param('name');

    my $tags_rs = $c->model( 'Blocks::Tag' );
    my $tagsblock_rs = $c->model( 'Blocks::TagsBlock' );

    my $tag_object = $tags_rs->create({ name => $tag });

    $c->response->redirect( '/admin/tags/');
}

sub tagsblocks :Local :ActionClass('REST') { }

sub tagsblocks_GET :Args(1) {
    my ( $self, $c, $arg ) = @_;

    my $tags_rs = $c->model( 'Blocks::Tag' );
    my $tagsblock_rs = $c->model( 'Blocks::TagsBlock' );

    my @tags = $tagsblock_rs->search({ idblock => $arg });
    $c->stash({ tags => \@tags, idblock => $arg });
}

sub tagsblocks_POST :Args(1) {
    my ( $self, $c, $arg ) = @_;

    my $tags_rs = $c->model( 'Blocks::Tag' );
    my $tagsblock_rs = $c->model( 'Blocks::Tagsblock' );

    my $name = $c->request->param('name');

    my $tag = $tags_rs->find_or_create({
        name => $name,
    });
    $tag->update();

    my @tagsblocks = $tagsblock_rs->find_or_create({
        idtag => $tag->idtag(),
        idblock => $arg,
    });

    my @tags = $tagsblock_rs->search({ idblock => $arg });


    $c->response->redirect( '/admin/block/' . $arg);
    #$c->stash({ tags => \@tagsblocks, idblock => $arg });
}


=encoding utf8

=head1 AUTHOR

Frederico,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
