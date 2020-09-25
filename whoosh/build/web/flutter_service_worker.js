'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "index.html": "33a5e7c189d4f3d1cf50d57e85e2a56e",
"/": "33a5e7c189d4f3d1cf50d57e85e2a56e",
"main.dart.js": "d2b01ec2811bfbdc615901d568a451f8",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/maskable_icon.png": "5ea15218366211f90e66e495d33abf3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/splash_screen_title.png": "2ed9e9fa2ceaeebde4287772da182192",
"icons/bottom_sea.png": "93b295a993d7746ccd6ae0d2172426f5",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "8c0c2b6e324dfc7eb870950a8f9fc97b",
"assets/images/static/enter_button.png": "8222bdd274757d58998ee00529f47fbf",
"assets/images/static/icon.png": "ce1be8ca0f787da96d94386cfcba6578",
"assets/images/static/maskable_icon.png": "5ea15218366211f90e66e495d33abf3c",
"assets/images/static/restaurant_menu_button.png": "c7f53bb20d091e107f9abbfa3785a1f9",
"assets/images/static/restaurant_icon_big.png": "b043ee78aebd740e9b24fb0d1f4ded7f",
"assets/images/static/restaurant_icon.png": "4eb76f80ba66051466824f9b0080af7b",
"assets/images/static/no_account_button.png": "cbfcf62874adce8e5d3b62dccbded2a3",
"assets/images/static/queue_line.png": "cc5e3560915603541a91802fbd89e2f0",
"assets/images/static/counter.png": "fa6ae7a4ce243bcaa72f1482b95440e5",
"assets/images/static/confirm_button.png": "87ae25c464c82b53cae828dff2668943",
"assets/images/static/randomize_button.png": "800f35a175a2550e42f4819524216b91",
"assets/images/static/already_have_account_button.png": "afe2f221bd60959e6bb1f9a82bc7816a",
"assets/images/static/whoosh_heading.png": "2e03ec1c62fb478c574547e0d616b30c",
"assets/images/static/get_started_button.png": "9641d7bcf6622f8f37b7bd73ac7358ee",
"assets/images/static/landing.png": "b65ab84a0456888326d377e78dbb5736",
"assets/images/static/im_ready_button.png": "a96211c01f255e91542bb4dd8b80edd5",
"assets/images/static/view_waitlist_button.png": "d413021e70c5d8c5669dd9895e6d23db",
"assets/images/static/logo.png": "8124580df5416089bdf6caf2b7073c31",
"assets/images/static/restaurant_welcome_monster2.png": "31800010708752092759a822dfd100f8",
"assets/images/static/share_queue_button.png": "c616260d88f8945667fab547557c374d",
"assets/images/static/restaurant_welcome_monster1.png": "6d3c1132ba703b32ee632ba01a61bfbf",
"assets/images/static/queue_line_mask.png": "431caf49eaaa3218c7f9099291d0142e",
"assets/images/static/name_bubble.png": "480808062d6402390f6afcedb3f99843",
"assets/images/static/edit_button.png": "c0b39ebd0c0c12cb7eba70ab0ae119a9",
"assets/images/static/refresh_button.png": "34eeec1742de1988a364f7e901093625",
"assets/images/static/bottom_sea.png": "93b295a993d7746ccd6ae0d2172426f5",
"assets/images/static/enter_queue_button.png": "2baed9fbd29475a21735463735725552",
"assets/images/static/whoosh_icon.png": "338b8372162e3336f8e4c4d0f5cdb94f",
"assets/images/actors/eyes.flr": "1be253c9382b273f7381d6decd555099",
"assets/images/actors/accessories.flr": "acef02cd08392a0e3caaa9257209ffef",
"assets/images/actors/wave.flr": "1fd4d3ef9abda7ff708843fed2ea760d",
"assets/images/actors/mouths.flr": "21270ff5538f1658c0fc38f5be2dab25",
"assets/images/actors/body.flr": "1e7078df8dc42cca3278066e72565642",
"assets/images/actors/effect.flr": "85cb2042edced50d3f5217daf9170743",
"assets/AssetManifest.json": "81f2a3d21608a27d508916d9b19851b5",
"assets/NOTICES": "a8813d26b7d0cd62a9bc645c1cbd4079",
"assets/FontManifest.json": "a40d06a5bc3349679aaf30c02efd50d2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"assets/fonts/VisbyCF-Light.ttf": "bb490cc7d137f74591d79d7dcace9723",
"assets/fonts/VisbyCF-ExtraBold.ttf": "42383cc271b92c600512fa44b98df04a",
"assets/fonts/MaterialIcons-Regular.otf": "a68d2a28c526b3b070aefca4bac93d25"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      // Provide a 'reload' param to ensure the latest version is downloaded.
      console.log('installing');
      return cache.addAll(CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  console.log('cache management');
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');

      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }

      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#')) {
    key = '/';
  }
  // If the URL is not the RESOURCE list, skip the cache.
  if (!RESOURCES[key]) {
    return event.respondWith(fetch(event.request));
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache. Ensure the resources are not cached
        // by the browser for longer than the service worker expects.
        var modifiedRequest = new Request(event.request, {'cache': 'reload'});
        return response || fetch(modifiedRequest).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    return self.skipWaiting();
  }

  if (event.message === 'downloadOffline') {
    downloadOffline();
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey in Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
