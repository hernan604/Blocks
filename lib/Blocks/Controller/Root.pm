package Blocks::Controller::Root;
use Moose;
use namespace::autoclean;

use Data::Dumper;

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

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $model_rs = $c->model( 'Blocks::User' );

    if ( $c->config->{ Boot } != "done" ){
        $c->config->{ Boot } = "done";
        $c->stash({
            template => "boot.tt"
        });
    }else {
        $c->response->body( Dumper $c->config );
        if ( $c->user() ) {
        }else{
        }
    }

}



sub boot :Local {
    my ( $self, $c ) = @_;

    my $address  = $c->request->param("address");
    my $name     = $c->request->param("name");
    my $username = $c->request->param("username");
    my $password = $c->request->param("password");

    $c->config->{ Model::Blocks }{ connect_info }{ dsn } = "dbi:mysql:$name:$address";
    $c->config->{ Model::Blocks }{ connect_info }{ username } = $username;
    $c->config->{ Model::Blocks }{ connect_info }{ password } = $password;

    try{
        my $blocks_rs = $c->model( "Blocks::posts" );
    }catch{
    };
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
