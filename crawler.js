var parser = new DOMParser();

var blog_urls = [ 'https://www.awesomewalls.co.uk/events',
    'https://www.theclimbingdepot.co.uk/nottingham/news',
    'http://www.fenrock.com/news/',
    'https://www.rockstarclimbing.co.uk/events/',
    'http://www.creationwall.co.uk/events.html',
    'https://www.thexc.co.uk/' + (new Date()).getFullYear() + '/',
    'http://highballclimbingnorwich.com/events/',
    'https://www.bigrockclimbing.com/news/',
    'https://www.boulderbrighton.com/events',
    'http://www.high-sports.co.uk/climbing-walls/brighton.html',
    'https://www.thebmc.co.uk/cats/all/competitions',
    'http://www.readingclimbingcentre.com/category/competitions/',
    'http://www.chimeraclimbing.com/about-chimera-climbing',
    'https://www.whitespiderclimbing.com/journal/all/',
    'http://theclimbinghangar.com/london/blog',
    'https://www.archclimbingwall.com/magazine/',
    'https://www.mileendwall.org.uk/news-events/news_blog',
    'https://www.castle-climbing.co.uk/competitions-blog',
    'https://thereach.org.uk/info/news'
];

blog_urls.forEach( function( url ) {
    html = httpGetAsync( url, 'findClimbingComps' );
} );

function findClimbingComps( html ) {
    var doc = parser.parseFromString( html, "text/html" );
    doc.getElementsByTagName( 'a' ).forEach( function( link ) {
        console.log( link.getAttribute( "href" ) );
    } );
}

function httpGetAsync( theUrl, callback ) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = function() {
        if( xmlHttp.readyState == 4 && xmlHttp.status == 200 )
            callback( xmlHttp.responseText );
    };
    xmlHttp.open( "GET", theUrl, true ); // true for asynchronous
    xmlHttp.send( null );
}