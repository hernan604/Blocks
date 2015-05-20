use utf8;
package Blocks::Schema::Result::Block;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Blocks::Schema::Result::Block

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<Blocks>

=cut

__PACKAGE__->table("Blocks");

=head1 ACCESSORS

=head2 idblock

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 timestamp

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 content

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "idblock",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "timestamp",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "content",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</idblock>

=back

=cut

__PACKAGE__->set_primary_key("idblock");

=head1 UNIQUE CONSTRAINTS

=head2 C<title_UNIQUE>

=over 4

=item * L</title>

=back

=cut

__PACKAGE__->add_unique_constraint("title_UNIQUE", ["title"]);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-05-20 01:10:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0uCU7EcO5656k3iR2U0rGw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
