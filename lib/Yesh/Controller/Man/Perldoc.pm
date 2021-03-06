package Yesh::Controller::Man::Perldoc;
use Moose;
use namespace::autoclean;
BEGIN { extends "Catalyst::Controller" }
no warnings "uninitialized";

use Encode;
use HTML::Entities;
use URI::Escape;

my $POM_AVAILABLE = eval <<'';
    require Pod::POM;
    1;

sub auto : Private {
    my ( $self, $c ) = @_;
    unless ( $POM_AVAILABLE )
    {
        $c->blurb("dependency/pod_pom");
        die "Pod::POM is not installed :( No perldocs for you: $@\n";
    }
    return 1;
}

sub index : Path Args(0) {
    my ( $self, $c ) = @_;
    my $name = $c->req->uri->query;
    ( my $path_part = $name ) =~ s,::,/,g;

    return unless $path_part;

    my $parser = Pod::POM->new({});

    my ( $pom );
    for my $try ( qw( .pm .pod .pl ), "" )
    {
        my $inc_key = $path_part . $try;
        if ( -r $INC{$inc_key} )
        {
            $pom = $parser->parse_file( $INC{$inc_key} );
            last if "$pom";
        }
        else
        {
            for my $path ( @INC )
            {
                if ( -r "$path/$inc_key" )
                {
                    $pom = $parser->parse_file("$path/$inc_key");
                    last if "$pom";
                }
            }
        }
    }

    unless ( "$pom" ) # Try the shell.
    {
        my $path = qx{ perldoc -l $name };
        $pom = $parser->parse_file($path) if $path;
    }

    my $title = "$pom" ? $name : "Pod Viewer";

    my ( @head1, @head2 );
    for my $part ( $pom->content )
    {
        next unless $part->type eq 'head1';
        push @head1, sprintf(qq{<li><a href="#%s">%s</a></li>},
                             uri_escape(encode_entities($part->title)),
                             encode_entities($part->title),
            );
        # push @head1, $part->title if $part->type eq 'head1';
        # LATER, STUPID push @{$head2[@head1]}, $part->title if $part->type eq 'head2';
    }
    my $pod_index = @head1 > 1 ? "<ul>" . join("\n", @head1) . "</ul>" : "";
    $c->stash( pom => "$pom" ? $pom : "",
               title => $title,
               name => $name,
               pod_index => $pod_index,
               pod => Encode::decode_utf8(Yesh::Pod::POM::View::HTML->print($pom)),
               warnings => [ $parser->warnings ],
        );
}

BEGIN {
    package Yesh::Pod::POM::View::HTML;
    eval 'use parent "Pod::POM::View::HTML"';
    use HTML::Entities;
    use URI::Escape;

    sub view_seq_link_transform_path {
        my ( $self, $page ) = @_;
        return "?$page";
    }

    sub view_seq_link {
        my ($self, $link) = @_;

        # view_seq_text has already taken care of L<http://example.com/>
        if ($link =~ /^<a href=/ ) {
            return $link;
        }

        # full-blown URL's are emitted as-is
        if ($link =~ m{^\w+://}s ) {
            return make_href($link);
        }

        $link =~ s/\n/ /g;   # undo line-wrapped tags

        my $orig_link = $link;
        my $linktext;
        # strip the sub-title and the following '|' char
        if ( $link =~ s/^ ([^|]+) \| //x ) {
            $linktext = $1;
        }

        # make sure sections start with a /
        $link =~ s|^"|/"|;

        my $page;
        my $section;
        if ($link =~ m|^ (.*?) / "? (.*?) "? $|x) { # [name]/"section"
            ($page, $section) = ($1, $2);
        }
        elsif ($link =~ /\s/) {  # this must be a section with missing quotes
            ($page, $section) = ('', $link);
        }
        else {
            ($page, $section) = ($link, '');
        }

        # warning; show some text.
        $linktext = $orig_link unless defined $linktext;

        my $url = '';
        if (defined $page && length $page) {
            $url = $self->view_seq_link_transform_path($page);
        }

        # append the #section if exists
        $url .= "#$section" if defined $url and
            defined $section and length $section;

        $linktext =~ s,\A/,, if defined $url and
            defined $section and length $section;

        return Pod::POM::View::HTML::make_href($url, $linktext);
    }

    sub view_head1 {
        my ($self, $head1) = @_;
        my $title = $head1->title->present($self);
        return sprintf(qq{<h2><a name="$title">$title</a></h2>\n\n},
                       uri_escape(encode_entities($title)),
                       encode_entities($title),
            )
            . $head1->content->present($self);
    }

    sub view_head2 {
        my ($self, $head2) = @_;
        my $title = $head2->title->present($self);
        return "<h3>$title</h3>\n"
            . $head2->content->present($self);
    }

    sub view_head3 {
        my ($self, $head3) = @_;
        my $title = $head3->title->present($self);
        return "<h4>$title</h4>\n"
            . $head3->content->present($self);
    }

    sub view_head4 {
        my ($self, $head4) = @_;
        my $title = $head4->title->present($self);
        return "<h5>$title</h5>\n"
            . $head4->content->present($self);
    }

    sub view_pod {
        my ($self, $pod) = @_;
        return join("\n",
                    '<div class="pod">',
                    $pod->content->present($self),
                    '</div>');
    }
}

1;

__END__

sub Pod::POM::View::HTML::view_seq_link_transform_path {
    my ( $self, $page ) = @_;
    return "?$page";
}
