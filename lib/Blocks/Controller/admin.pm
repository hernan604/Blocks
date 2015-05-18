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

    $c->response->body('Matched Blocks::Controller::admin in admin.');
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



=encoding utf8

=head1 AUTHOR

Frederico,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
