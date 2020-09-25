
self.addEventListener('install', function (event) {
    event.waitUntil(
        caches.open('cache_name').then(function (cache) {
            return cache.addAll([
                '/',
                '/style.css',
                ...
            ]);
        })
    );
});

self.addEventListener('fetch', function (event) {
    event.respondWith(
        caches.match(event.request)
            .then(function (response) {
                    // Response for the request is found in cache, return the response
                    if (response) {
                        return response;
                    }

                    // Response is not found in cache, make a network request instead
                    return fetch(event.request);
                }
            )
    );
});

self.addEventListener('activate', function (event) {
    // Cache management. E.g. Purging unused data
})