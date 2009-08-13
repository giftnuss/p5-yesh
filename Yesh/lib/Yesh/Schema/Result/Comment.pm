package Yesh::Schema::Result::Comment;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "Yesh::Default",
  "UTF8Columns",
  "InflateColumn::DateTime",
  "Core",
);
__PACKAGE__->table("comment");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
    size => 10,
  },
  "uuid",
  { data_type => "CHAR", default_value => "", is_nullable => 0, size => 36 },
  "article",
  {
    data_type => "INT",
    default_value => "",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
    size => 10,
  },
  "parent",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
    size => 10,
  },
  "user",
  {
    data_type => "INT",
    default_value => "",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
    size => 10,
  },
  "license",
  {
    data_type => "INT",
    default_value => "",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
    size => 10,
  },
  "title",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "body",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "note",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "data",
  {
    data_type => "BLOB",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "status",
  {
    data_type => "ENUM",
    default_value => "pending",
    extra => { list => ["pending", "approved", "deleted"] },
    is_nullable => 1,
    size => 8,
  },
  "created",
  { data_type => "DATETIME", default_value => "", is_nullable => 0, size => 19 },
  "updated",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 14,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
  "article",
  "Yesh::Schema::Result::Article",
  { id => "article" },
);
__PACKAGE__->belongs_to(
  "parent",
  "Yesh::Schema::Result::Article",
  { id => "parent" },
  { join_type => "LEFT OUTER" },
);
__PACKAGE__->belongs_to("user", "Yesh::Schema::Result::User", { id => "user" });
__PACKAGE__->belongs_to(
  "license",
  "Yesh::Schema::Result::License",
  { id => "license" },
);


# Created by DBIx::Class::Schema::Loader v0.04999_06 @ 2009-03-14 13:01:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lE/KkALDRv8czEWd+Jm3sA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
