use POSIX qw(strftime);

$home = "@CIVSDATADIR@";
$thishost = "@THISHOST@";
$civs_bin_path = "@CIVSBINURL@";
$civs_log = $home."/log";
$civs_url = "@CIVSURL@";
$last_election_id_file = $home."/last_election_id";
$private_host_id_file = $home."/private_host_id";
$lockfile = $home."/global_lock";
$cr = "\r\n";
$local_debug = 0;

sub GetPrivateHostID {
    open(HOSTID, $private_host_id_file);
    $private_host_id=<HOSTID>;
    chomp $private_host_id;
    close(HOSTID);
}

sub HTML_Header {
    $title = $_[0];
    print header(), start_html(-title => $title,
			       -style => {'src' => "@CIVSURL@/style.css"});
}

sub CIVS_Header {
print "
<table border=0 width=100% cellspacing=0 cellpadding=7>
  <tr>
    <td width=100% bgcolor=#000080 valign=top nowrap>
    <h1><font color=white face=sans-serif>&nbsp;Condorcet Internet Voting Service</font></h1>
    </td>
    <td bgcolor=#000080 width=0% nowrap valign=top><a href=$civs_url><font color=white face=sans-serif>CIVS Home</font></a></td>
  </tr>
  <tr>
    <td width=100% bgcolor=#000080 valign=top nowrap colspan=2>
    <h2 align=center><font color=white face=sans-serif>$_[0]</font></h2>
    </td>
  </tr>
</table>
";
}

# Log the string provided
sub Log {
    $now = strftime "%a %b %e %H:%M:%S %Y", localtime;
    open(CIVS_LOG, ">>$civs_log");
    print CIVS_LOG $now." ".remote_addr()." ".$_[0]."\n";
    close(CIVS_LOG);
}

1; # ok!
