# fit_map

To work with Mapbox, you need to have a secret token issued by Mapbox. [This guide](https://docs.mapbox.com/android/maps/guides/install/ "This guide") explains in the first two sections how to get that secret token on Mapbox. Then create the file ```{USER_HOME}/.gradle/gradle.properties```. USER_HOME being your home directory. This file may or may not exist for you already. Place the following line of code in it:

```MAPBOX_DOWNLOADS_TOKEN=YOUR_SECRET_MAPBOX_ACCESS_TOKEN```

Replacing YOUR_SECRET_MAPBOX_ACCESS_TOKEN with whatever your secret token is. 