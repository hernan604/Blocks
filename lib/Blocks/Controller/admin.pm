package Blocks::Controller::admin;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blocks::Controller::admin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

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
        $block->title( $title );
        $block->content( $content );
        $block->update();
    }else{
        $block->create({
            title => $title,
            content => $content,
        });
    }
    $c->response->redirect( '/admin/block/'. $block->idblock() );
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
