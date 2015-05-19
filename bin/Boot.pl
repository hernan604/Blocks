#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

use Blocks::Model::Blocks;
use Blocks::Schema;
use Config::Any;
use Digest::MD5 qw/md5_hex/;

my $configs = Config::Any->load_files( { files => [ @ARGV ] });

my $conf;
for my $config ( @{ $configs } ){
    ( undef, $conf ) = %{ $config };
}

my $model = Blocks::Model::Blocks->new(
    $conf->{ 'Model::Blocks' }
);
my $schema = $model->schema();
my $user_rs = $schema->resultset('User');

my @users = $user_rs->all();

if ( ! @users ) {
    my $admin_user = $user_rs->create({
        email       => 'admin',
        password    => md5_hex( "123mudar" ),
    });
}
