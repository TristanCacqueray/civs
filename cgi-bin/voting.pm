package voting;

use civs_common;
use CGI qw(:standard);
use election;
use strict;

sub GenerateVoteForm {

    my ($voter_key, $authorization_key, $choice_index_ref, $rank_ref, $js_ui, $lean) = @_;

    my @choice_index = @{$choice_index_ref};
    my @rank = @{$rank_ref};

    my $rating = $tx->Rank;
    if ($proportional eq 'yes' && $use_combined_ratings) {
	$rating = $tx->Weight;
    }

    print '<form method="POST"
      action="http://@THISHOST@'.$civs_bin_path.'/vote@PERLEXT@"
      enctype="multipart/form-data"
      name="CastVote">', $cr;

    print '<table class="form" id="ballot" border="0" cellpadding="5" cellspacing="0"><tr><td>', $cr;

    print '<table cellpadding="5px" cellspacing="0" border="1" id="preftable">
    <tr class="heading">
	    <th>&nbsp;'.$tx->Choice.'&nbsp;</th>';
    if ($voting_enabled) {
	print '<th>'.$rating.'</th>';
    }
    print '</tr>',$cr;

    print hidden('key', $voter_key), $cr;
    print hidden('id', $election_id), $cr;
    print hidden('akey', $authorization_key), $cr;

#   print $cr, '<!-- Current rankings:', $cr;
#   for (my $i = 0; $i < $num_choices; $i++) {
#	$name = $choices[$i];
#	$name =~ s/"/ /;
#	my $selected = $rank[$i];
#	print "$i \"$choices[$i]\" $selected", $cr;
#    }
#    print "-->", $cr;

    for (my $i = 0; $i < $num_choices; $i++) {
	my $k = $choice_index[$i];
	my $selected = $rank[$k];
	my $choice = $choices[$k];
	if ($js_ui && $voting_enabled) {
	    print "<tr onClick=\"select_row(this, event.shiftKey||event.ctrlKey);\"><td class=choice>$choice</td>", $cr;
	} else {
	    print "<tr><td class=inactive_choice>$choice</td>", $cr;
	}
	if ($voting_enabled) {
	    if ($proportional ne 'yes' || !$use_combined_ratings) {
		print "<td><select size=1 name=\"C$k\" onChange=\"sort_rows()\">", $cr;
		for (my $j = 1; $j <= $num_choices; $j++) {
		    if ($j == $selected) {
				print "  <option selected>$j</option>", $cr;
		    } else {
				print "  <option>$j</option>", $cr;
		    }
		}
		if ($proportional ne 'yes' && $no_opinion eq 'yes') {
		    if ($selected eq "No opinion") {
			print "  <option selected>No opinion</option>";
		    } else {
			print "  <option>No opinion</option>";
		    }
		}
		print "</select></td>", $cr;
	    } else {
		print '<td><input type="text" name="C'.$k.'"
		size="3" value="'. $selected. '"></td>';
	    }
	}
	print "</tr>", $cr;
    }
    print '</table></td>', $cr;
    if ($js_ui && !$lean && $voting_enabled) {
	print '<td rowspan=2 width="0" valign="top" align="center">
	    <input type="button" id="move_top" disabled value="'.$tx->to_top.'"
	    onClick="do_move_top()"><br>
	    <input type="button" id="move_up" disabled value="'.$tx->move_up.'"
	    onClick="do_move_up()"><br>
	    <input type="button" id="make_tie" disabled value="'.$tx->make_tie.'"
	    onClick="do_make_tie()"><br>
	    <input type="button" id="move_down" disabled value="'.$tx->move_down.'"
	    onClick="do_move_down()"><br>
	    <input type="button" id="move_bottom" disabled value="'.$tx->to_bottom.'"
	    onClick="do_move_bottom()">
	    <table class="form"><tr><td>
	    <p id="jsnohelp">'.
	    $tx->buttons_are_deactivated.
	    '</p>
	    <div style="display: none" id="jshelp">
	    <p>'.
	    $tx->ranking_instructions.'
	    </div>
	    </td></tr></table>
	    </td>', $cr;
    }

    print '</tr>', $cr;


    if ($voting_enabled) {
	print '<tr><td><input id=vote type="submit" value="'.$tx->submit_ranking.'" name="Vote"></tr>', $cr;
    }

    print '</table>', $cr;
    print '</form>', $cr;

    if ($writeins eq 'yes') {
	print $cr, '<form method="POST"
	    action="http://@THISHOST@'.$civs_bin_path.'/vote@PERLEXT@"
	    enctype="multipart/form-data"
	    name="AddWritein">', $cr;
	print '<p>', $tx->write_in_a_choice, $cr,
	    ' <input type="text" size="60" name="writein">';
	print '<input type="submit" value="', $tx->Add_writein, '" name="AddWritein"></p>', $cr;
	print hidden('key', $voter_key);
	print hidden('id', $election_id);
	print hidden('akey', $authorization_key);
	print '</form>', $cr;
    }

}

1;
