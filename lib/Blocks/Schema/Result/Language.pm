use utf8;
package Blocks::Schema::Result::Language;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Blocks::Schema::Result::Language

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

=head1 TABLE: C<Languages>

=cut

__PACKAGE__->table("Languages");

=head1 ACCESSORS

=head2 idblocks

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 language

  data_type: 'varchar'
  is_nullable: 0
  size: 9

=head2 linked_block

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "idblocks",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "language",
  { data_type => "varchar", is_nullable => 0, size => 9 },
  "linked_block",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</idblocks>

=item * L</language>

=back

=cut

__PACKAGE__->set_primary_key("idblocks", "language");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-05-18 09:10:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:thUl6B3rFidckKg7TqVx9A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
