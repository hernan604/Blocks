package Blocks::Controller::setup;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blocks::Controller::setup - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

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

=encoding utf8

=head1 AUTHOR

Frederico,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
