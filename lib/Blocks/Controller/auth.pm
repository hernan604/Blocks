package Blocks::Controller::auth;
use Moose;
use namespace::autoclean;

use Digest::MD5 qw/md5_hex/;
use Email::Stuffer;

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

sub lost_password :Local :ActionClass('REST') { }

sub lost_password_GET {
    my ( $self, $c ) = @_;
}

sub lost_password_POST {
    my ( $self, $c ) = @_;

    my $email = $c->request->param("email");

    my $user_rs = $c->model( 'Blocks::User' );
    my $user = $user_rs->find({ email => $email });

    print Dumper $user;

    if ( $user and $user->password() ){
        my $token = md5_hex $c;

        $user->token( $token );
        $user->update();

        # TODO be a block

        my $body = <<"RECOVER";

Hello,

You, owner of the email $email requested to
reset the password at Blocks CMS application.

Should be fine, it is just a matter of follow this link:

    http://yapcbrasil2015.org/auth/recover?token=$token

Then set your new password.

Thanks, Block CMS

RECOVER

Email::Stuffer->from        ( 'blocks@imovlr.com'   )
              ->to          ( $user->email()        )
              ->bcc         ( 'cartas@frederico.me' )
              ->subject     ( 'blocks recover password' )
              ->text_body   ( $body )
              ->send;

        $c->stash({
            message => "Sent recover email to ". $user->email(),
        });
    }else{
        $c->stash({
            message => "This user does not have access to here",
        });
    }
}

sub recover :Local :ActionClass('REST') { }

sub recover_GET{
    my ( $self, $c ) = @_;

    my $token = $c->request->param("token");

    my $user_rs = $c->model( 'Blocks::User' );
    my $user = $user_rs->find({ token => $token });

    if ( $user ) {
        $c->session->{ token } = $token;
        $c->stash({
            email => $user->email(),
        });
    }else{
        $c->response->redirect( '/auth/login' );
    }
}

sub recover_POST {
    my ( $self, $c ) = @_;

    my $password    = $c->request->param("password");
    my $kagebunshin = $c->request->param("kagebunshin");

    my $token   = $c->session->{ token };
    my $user_rs = $c->model( 'Blocks::User' );
    my $user = $user_rs->find({ token => $token });

    if ( $user and ( $password eq $kagebunshin )) {
        $user->password( md5_hex( $password ) );
        $user->update();
    }

    $c->response->redirect( '/auth/login' );
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
