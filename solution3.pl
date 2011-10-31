#!perl -w
#################################################################
# Author : Ian Egan
#
# 3. Write a MSSQL query that will compare the row counts for all
# tables in two databases with the same schema. Provide a Pass Fail
# column that compares the values for equality.  Example Output:
#
# 
#  --------------------------------------------------------------
# |Table Name  | Rows in DB A | Rows in DB B  | Rows are Equal |
# --------------------------------------------------------------
# |MyTable     | 1020         | 1020          | Pass           |
# --------------------------------------------------------------
# |OtherTable  | 1023         | 5             | Fail           |
# --------------------------------------------------------------
#
# Notes:
# This might be solved in better ways, perhpas with a stored
# procedure that is called from a program. However, this does
# work and was easier for me to write and it might be a little more
# portable between other databases.
# Todo : 1 - Better Error handlying 
#        2 - Unit tests coverage
#################################################################

# The Database Names
my $db1="eg1";
my $db2="eg2";

# db rows
my ($r1,$r2) = (0,0);
my $cmd="sqlcmd -Q";

my $alltables2 ='\"select name from $db2.sys.tables\"';
my @tables = getTableNames($db1);


print "-------------------------------------------------------------\n";
print "|Table Name  | Rows in $db1 | Rows in $db2  | Rows are Equal|\n";
print "-------------------------------------------------------------\n";

#loop over each row name and count the rows
foreach $t (@tables){
#    print "count rows in $t\n";
    $r1 = cntRows($db1, $t);
    $r2 = cntRows($db2, $t);
    print "$t,           $r1,           $r2,           ";
    print $r1 eq $r2 ? "Pass\n" :"Fail\n";
}


#Get an array of the table names
sub getTableNames {
    my $db = $_[0];
    my $select ="select name from $db.sys.tables";    
    my $out        = `$cmd \"$select\"`;
    @fields     = split(/ *\n/, $out);
    my @tables = ();

    foreach $i (@fields) {

#	print "*$i\n";
	if($i !~ /name|^$|-+|rows a.+/){
	    $i =~ s/ *//;
	    chomp($i);
#	    print "~$i\n";
	    push(@tables, $i);

	}
    }
    return @tables;

}

 
# Count the rows of each table
sub cntRows {

    my $db         =$_[0];
    my $table      =$_[1];
    $cntRows    = "select count(*) from ${db}.dbo.${table}";
 #   print "$cmd \"$cntRows\"\n";
    $out        = `$cmd \"$cntRows\"`;
    @fields     = split(/ *\n/, $out);
    foreach $i (@fields) {
#	print "*$i\n";
	if($i =~ /^ +[0-9]+.*$/){
	    $i =~ s/ *//;
	    chomp($i);
#	    print "$i\n";
	    return $i
	}
    }
    return -1;
}



