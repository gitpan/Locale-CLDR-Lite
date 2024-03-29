#!perl -T

use utf8;
use Test::More;
use Test::Exception;
use strict;

BEGIN {
    use_ok( 'Locale::CLDR::Lite' ) || print "Bail out!\n";
}

diag( "Testing Locale::CLDR::Lite object creation" );

my $locale = new Locale::CLDR::Lite('en_GB');
is( ref $locale, 'Locale::CLDR::Lite', 'Locale object created' );

throws_ok( sub { $locale->numbers }, qr/You must call the get method first/, 'get method requirement thrown ok' );

# Can we get
my $get = $locale->get;
is( ref $get, 'Locale::CLDR::Lite', 'Locale object returned' );
is_deeply( $get->{node}, [], 'Object node is empty' );

# Can we navigate to numbers
my $numbers = $get->numbers;
is( ref $numbers, 'Locale::CLDR::Lite', 'Locale object returned' );
is( $numbers->{node}->[-1]->{name}, 'numbers', 'Object node is numbers' );

# Is get still at get?
is( ref $get, 'Locale::CLDR::Lite', 'Locale object returned' );
is_deeply( $get->{node}, [], 'Object node is empty' );

# To symbols
my $symbols = $numbers->symbols;
is( ref $symbols, 'Locale::CLDR::Lite', 'Locale object returned' );
is( $symbols->{node}->[-1]->{name}, 'symbols', 'Object node is symbols' );

# Is numbers still at numbers?
is( ref $numbers, 'Locale::CLDR::Lite', 'Locale object returned' );
is( $numbers->{node}->[-1]->{name}, 'numbers', 'Object node is numbers' );

# Can we get a value
my $decimal = $numbers->symbols(numberSystem => 'latn')->decimal();
is( $decimal, '.', 'Locale object returned' );


diag( "Testing attribute selector" );

# Test attribute selector
my $calendar = $get->dates->calendars->calendar(type => 'gregorian');
is( ref $calendar, 'Locale::CLDR::Lite', 'Locale object returned' );

my $datepattern = $get->dates->calendars->calendar(type => 'gregorian')->
        dateFormats->dateFormatLength(type => 'full')->dateFormat->pattern();
        # returns EEEE, d MMMM y
is( $datepattern, 'EEEE, d MMMM y', 'Date pattern returned' );

diag( "Testing alias redirect" );

# Test alias redirect
my $currency = $numbers->currencyFormats(numberSystem => 'arab');
is( ref $currency, 'Locale::CLDR::Lite', 'Locale object returned' );


done_testing();
