package Blocks::Controller::auth;
use Moose;
use namespace::autoclean;

use Digest::MD5 qw/md5_hex/;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blocks::Controller::auth - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    if (! $c->user() ){
        $c->response->redirect( '/auth/login' );
    }
}

sub login :Local :ActionClass('REST') { }

sub login_GET {
    my ( $self, $c ) = @_;

    $c->stash();
}

sub login_POST {
    my ( $self, $c ) = @_;

    my $username = $c->request->param('user');
    my $password = $c->request->param('password');

    if ( $c->authenticate( { email => $username, password => $password })){
        my $url =  $c->session->{ return_uri } || '/admin/blocks';
        $c->response->redirect( $url );
    }else{
        $c->response->redirect( '/auth/login' );
    }
}

sub logout :Local{
    my ( $self, $c ) = @_;

    $c->logout();

    $c->response->redirect('/auth/login');
}

sub user :Local :ActionClass('REST' ) { }

sub user_GET {
    my ( $self, $c ) = @_;

    my $user_rs = $c->model( 'Blocks::User' );

    my @users = $user_rs->all();

    $c->stash({
        users => \@users,
    });
}

sub user_POST {
    my ( $self, $c ) = @_;

    my $email = $c->request->param( "user" );
    my $password = $c->request->param( "password" );

    if ( $email and $password ) {
        my $user_rs = $c->model( 'Blocks::User' );
        my $user = $user_rs->find( { email => $email } );
        if ( $user ){
            $user->password( md5_hex $password );
            $user->update();
        }else{
            $user = $user_rs->create({
                email => $email,
                password => md5_hex( $password ),
            });
        }
    }
    $c->response->redirect( '/auth/user' );
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
