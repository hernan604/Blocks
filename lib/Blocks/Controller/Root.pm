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

    print Dumper $c->config;

    if ( $c->config->{ Boot } ne "done" ){
        $c->stash({
            template => "boot.tt"
        });
    }else {
        #$c->response->body( Dumper $c->config );
        if ( $c->user() ) {
        }else{
        }
        my $blocks_rs = $c->model( "Blocks::Block" );
        my @blocks = $blocks_rs->search({ title => "Hotline miami" });

        $c->stash({
            template => "blocks.tt",
            blocks   => \@blocks,
        });
        
        #$c->response->body ( Dumper \@blocks );
    }
}

sub boot :Local {
    my ( $self, $c ) = @_;

    my $address  = $c->request->param("address");
    my $name     = $c->request->param("name");
    my $username = $c->request->param("username");
    my $password = $c->request->param("password");

    $c->config->{ "Model::Blocks" }{ connect_info }{ dsn } = "dbi:mysql:$name:$address";
    $c->config->{ "Model::Blocks" }{ connect_info }{ user } = $username;
    $c->config->{ "Model::Blocks" }{ connect_info }{ password } = $password;

    try{
        #my $schema = Blocks::Schema->connect_info( [ $c->config->{ "Model::Blocks" }{ connect_info } ]);
        #my $blocks_rs = $c->model( "Blocks::Block" );

        # worked
        my $schema = $c->model( "Blocks" )->connect( $c->config->{ "Model::Blocks" }{ connect_info }  );
        my $blocks_rs = $schema->resultset( "Block");

        #$c->model( "Blocks::Block" ) = Blocks::Schema->connect( $c->config->{ "Model::Blocks" }{ connect_info }  );
        #my $blocks_rs = $c->model( "Blocks::Block" );

        print Dumper $blocks_rs;
        my $newpost = $blocks_rs->create({
            title => "Hotline miami",
        });
        if ( $newpost ) {
            $c->response->body("worked");
            $c->config->{ Boot } = "done";
        }
    }catch{
            $c->response->body("try over   $_" . Dumper $c->config->{ "Model::Blocks" });
            #$c->response->body ( Dumper $c->config );
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
