#!/usr/bin/env perl
use strict;
use warnings;

package utils;
    use strict;
    use warnings;

    sub bool_to_string {
        return $_[0] ? "true" : "false";
    }

package jsonplaceholder;
    use strict;
    use warnings;

    use constant BASE_URL => "https://jsonplaceholder.typicode.com";

package jsonplaceholder::todos;
    use strict;
    use warnings;

    require HTTP::Request;
    require LWP::UserAgent;

    use JSON::XS;
    use Time::HiRes qw(time);

    sub get {
        my $todo_id = shift;
        my $url = jsonplaceholder::BASE_URL . "/todos/$todo_id";

        my $ua = LWP::UserAgent->new;

        print "[jsonplaceholder] info: fetching Todo... url='$url'\n";
        my $start_time = time();
        my $res = $ua->request(HTTP::Request->new(
            GET => $url
        ));
        my $elapsed_ms = (time() - $start_time) * 1_000;
        printf('[jsonplaceholder] info: done fetching Todo. todo_id=%d status_line="%s" elapsed_ms=%.2f' . "\n", $todo_id, $res->status_line, $elapsed_ms);

        if (!$res->is_success) {
            warn "[jsonplaceholder] error: request failed (TODO add error context)\n";
            exit 1;
        }

        my $todo = decode_json($res->decoded_content);
        return $todo;
    }

package main;
    require Data::Dumper;
    # require jsonplaceholder;

    use Data::Dumper;

    my $todo = jsonplaceholder::todos::get(7);
    print Dumper($todo);

    print("todo.id = ", $todo->{"id"}, "\n");
    print("todo.userId = ", $todo->{"userId"}, "\n");
    print("todo.title = ", $todo->{"title"}, "\n");
    print("todo.completed = ", utils::bool_to_string($todo->{"completed"}), "\n");

