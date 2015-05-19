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

    $c->session->{ admin } = "admin";
}

# login
sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->redirect( '/admin/block' );
}

sub block :Local :ActionClass('REST') { }

sub block_GET :Args(1){
    my ( $self, $c, $arg ) = @_;

    my $block_rs = $c->model( 'Blocks::Block' );

    my $block;
    if ( $arg ) {
        $block = $block_rs->find($arg);
    }

    print Dumper $c->session;

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

    my $block_rs = $c->model( 'Blocks::Block' );
    my $block;
    if ( $arg ){
        $block = $block_rs->find($arg);
        if ( $block ) {
            $block->title( $title );
            $block->content( $content );
            $block->update();
        }else{
            $c->response->code( 500 );
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
    my @languages = $languages_rs->search( { idblocks => $arg } );

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
        title => undef,
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

=encoding utf8

=head1 AUTHOR

Frederico,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
