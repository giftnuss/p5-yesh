package Yesh::Schema::Result::UserSiteRole;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "Yesh::Default",
  "UTF8Columns",
  "InflateColumn::DateTime",
  "Core",
);
__PACKAGE__->table("user_site_role");
__PACKAGE__->add_columns(
  "user",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_foreign_key => 1,
    is_nullable => 0,
    size => 10,
  },
  "site_role",
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
__PACKAGE__->set_primary_key("user", "site_role");
__PACKAGE__->belongs_to("user", "Yesh::Schema::Result::User", { id => "user" });
__PACKAGE__->belongs_to(
  "site_role",
  "Yesh::Schema::Result::SiteRole",
  { id => "site_role" },
);


# Created by DBIx::Class::Schema::Loader v0.04999_08 @ 2009-09-12 21:15:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lse2kNUYcWk5u0c3LA2UUg



1;
