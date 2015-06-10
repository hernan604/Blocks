package Blocks::Controller::conference;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use JSON;
use utf8;

=head1 NAME

Blocks::Controller::papers - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Blocks::Controller::papers in papers.');
}

sub register :Local :ActionClass('REST') { }

# create a user

sub register_POST{
    my ( $self, $c, $arg ) = @_;

    my $email   = $c->request->param("email");
    my $name    = $c->request->param("name");
    my $address = $c->request->param("address");
    my $tshirt  = $c->request->param("tshirt");
    my $type    = $c->request->param("type");
    my $message = $c->request->param("message");

    my $user_rs = $c->model('Blocks::User');

    if ( $email and $name and $address  ) {

        my $user = $user_rs->find_or_new({
            email => $email,
        });

        if ( !$user->in_storage ){
            my $details = {
                email       => $email,
                name        => $name,
                address     => $address,
                tshirt      => $tshirt,
                type        => $type,
            };
            $user->details( encode_json $details );
            $user->insert();
            if ( $message ) {
                $c->response->redirect( $message );
            }else{
                $c->response->body( "success" );
            }
        }else{
            $c->response->body( "The user already exists");
            # error forbiden
        }
    }else{
        $c->response->body( "missing information" );
        #error missing info
    }
}

sub paper :Local :ActionClass('REST') { }

sub paper_POST {
    my ( $self, $c, $arg ) = @_;

    my $title   = $c->request->param("title");
    my $content = $c->request->param("content");
    my $email   = $c->request->param("email");
    my $message = $c->request->param("message");

    my $block_rs = $c->model('Blocks::Block');

    my $block = $block_rs->create({
        title => $title,
        content => join ("\n", $email, $content ),
    });

    $block->update();

    my $tags_rs = $c->model( 'Blocks::Tag' );
    my $tagsblock_rs = $c->model( 'Blocks::Tagsblock' );

    my $tag = $tags_rs->find_or_create({
        name => "call_for_papers",
    });
    $tag->update();

    my $tagsblocks = $tagsblock_rs->find_or_create({
        idtag => $tag->idtag(),
        idblock => $block->idblock(),
    });

    if ( $message ) {
        $c->response->redirect( $message );
    }else{
        $c->response->body( "success" );
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
