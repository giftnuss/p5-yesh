package Yesh::Schema::Result::ArticleDisplayGroup;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "Yesh::Default",
  "UTF8Columns",
  "InflateColumn::DateTime",
  "Core",
);
__PACKAGE__->table("article_display_group");
__PACKAGE__->add_columns(
  "article",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
    size => 10,
  },
  "display_group",
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
);
__PACKAGE__->set_primary_key("article", "display_group");


# Created by DBIx::Class::Schema::Loader v0.04999_08 @ 2009-09-12 19:51:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RWZc7MbDu6QfkqrbSlnlpw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
