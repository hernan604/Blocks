package Blocks::Controller::user;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use Data::Dumper;
use Digest::MD5 qw/md5_hex/;
use JSON;

=head1 NAME

Blocks::Controller::user - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

sub begin :Private {
    my ( $self, $c ) = @_;

    if ( ! $c->user() ){
        $c->session->{ return_uri } = $c->request->uri;
        $c->response->redirect( '/auth/login' );
    }
}

=cut

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->redirect( '/user/user' );
}

sub user :Local :ActionClass('REST') { }

sub user_GET{
    my ( $self, $c ) = @_;

    my $user_rs = $c->model( 'Blocks::User' );
    $user_rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
    my $session_user = $c->user();
    my $user = $user_rs->find( $session_user->uid() );
    my $details = decode_json $user->{ details }
        if $user->{ details };

    $c->stash({
        user => $user,
        details => $details,
    });
}

sub user_POST{
  my ( $self, $c ) = @_;

    my $details = $c->request->parameters();
    print Dumper $details;

    my $user_rs = $c->model( 'Blocks::User' );
    my $session_user = $c->user();
    my $user = $user_rs->find( $session_user->uid() );

    if ( $user ) {

        if ( $details and exists $details->{ password } ){
            $user->password( md5_hex $details->{ password } );
            delete $details->{ password };
        }

        if ( keys %$details ){
            my $detail = encode_json $details;
            $user->details( $detail );
        }

        $user->update();
    }

    $c->response->redirect( '/user/user' );
}

=encoding utf8

=head1 AUTHOR

Todo Devel

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
