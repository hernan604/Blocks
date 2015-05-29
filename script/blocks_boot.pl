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

my $blocks_rs = $schema->resultset('Block');
my @blocks = $blocks_rs->all();

if ( ! @blocks ) {
    my $content = join "", <DATA>;

    my $block = $blocks_rs->create({
        idblock     => 1,
        title       => "Start",
        content     => $content,
    });
}

__DATA__

Welcome to the Blocks CMS
=========================

What is this CMS about?
-----------------------

Blocks CMS is a block content oriented CMS.
We don't have posts or pages or any kind of special content. All content is a block.

Actually all blocks are markdown text. If you don`t know markdown, should have a look at this link:

<a href="http://daringfireball.net/projects/markdown/">Markdown</a>

Design
------

Some points were taken when designing this CMS:

### Multi-Language Support

The default block is language agnostic, but it is possible to link with a block of other language.

This means that if you have a text and want it in two languages, just create another block and
mark it as language desired. Example, block 1 is in English and block 56 is the same content in
portuguese. When the browser sends the user agent the Blocks CMS will sent the correct language.

### Raw and Page Blocks

The application can send a block in raw html, just what should be the body. Or the full html, with
headers and all tags. The difference is that usually the browser ask first for a "page",full html
and this page get another blocks

How to use?
-----------

Login into the admin area:

<a href="/admin">Admin Area</a>

If you never did it, it will ask to change the admin password. The default instalation user and
password are admin and we strong recomend to change it as soon as possible.

The root page always ask for the block number 1. In this case block number 1 is not edited.
When you open it you will see the markdown of this page. Feel free to edit it as you need.

It is possible to include blocks adding the script to markdown, calling the block by it number.

    <script>loadBlock( number )</script>

This will load the block content at that point. It creates a div with the id of the block and
fill it with the html content rendered from the markdown. Very simple.

Development
-----------

Since this is the first alpha alpha version, a lot of stuff needs to be develop. Actually we
don't have a roadmap but patches are welcome.

The next big plan is add support to tags and atributes.


