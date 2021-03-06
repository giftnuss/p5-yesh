package Yesh::Schema::Result::UserArticleRole;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "Yesh::Default",
  "UTF8Columns",
  "InflateColumn::DateTime",
  "Core",
);
__PACKAGE__->table("user_article_role");
__PACKAGE__->add_columns(
  "user",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
    size => 10,
  },
  "article_role",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
    size => 10,
  },
  "created",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 0,
    size => 19,
  },
  "updated",
  {
    data_type => "TIMESTAMP",
    default_value => undef,
    is_nullable => 1,
    size => 14,
  },
);
__PACKAGE__->set_primary_key("user", "article_role");
__PACKAGE__->belongs_to("user", "Yesh::Schema::Result::User", { id => "user" });
__PACKAGE__->belongs_to(
  "article_role",
  "Yesh::Schema::Result::ArticleRole",
  { id => "article_role" },
);


# Created by DBIx::Class::Schema::Loader v0.04999_08 @ 2009-09-12 21:15:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pGX7F1VC1uxL6+O6hgJ54w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
