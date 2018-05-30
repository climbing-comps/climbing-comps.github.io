var parser = new DOMParser();

var blog_urls = [ 'https://www.awesomewalls.co.uk/blog',
    'https://www.theclimbingdepot.co.uk/nottingham/news',
    'https://www.fenrock.com/news/',
    'https://www.rockstarclimbing.co.uk/events/',
    'https://www.creationwall.co.uk/events.html',
    'https://www.thexc.co.uk/' + (new Date()).getFullYear() + '/',
    'https://highballclimbingnorwich.com/events/',
    'https://www.bigrockclimbing.com/news/',
    'https://www.boulderbrighton.com/events',
    'https://www.high-sports.co.uk/climbing-walls/brighton.html',
    'https://www.thebmc.co.uk/cats/all/competitions',
    'https://www.readingclimbingcentre.com/category/competitions/',
    'https://www.chimeraclimbing.com/about-chimera-climbing',
    'https://www.whitespiderclimbing.com/journal/all/',
    'https://theclimbinghangar.com/london/blog',
    'https://www.archclimbingwall.com/magazine/',
    'https://www.mileendwall.org.uk/news-events/news_blog',
    'https://www.castle-climbing.co.uk/competitions-blog',
    'https://thereach.org.uk/info/news'
];

blog_urls.forEach( function( url ) {
    xhr = createCORSRequest( 'GET', url );
    if( ! xhr ) {
        console.log( 'CORS not supported' );
    }
    xhr.onload = function() {
        var doc = parser.parseFromString( xhr.responseText, "text/html" );
        doc.getElementsByTagName( 'a' ).forEach( function( link ) {
            console.log( link.getAttribute( "href" ) );
        } );
    };
} );

function createCORSRequest( method, url ) {
    var xhr = new XMLHttpRequest();
    if( "withCredentials" in xhr ) {
        xhr.open( method, url, true );
    } else if( typeof XDomainRequest != "undefined" ) {
        xhr = new XDomainRequest();
        xhr.open( method, url );
    } else {
        xhr = null;
    }
    return xhr;
}