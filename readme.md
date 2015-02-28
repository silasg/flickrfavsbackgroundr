# FlickrFavsBackgroundR
## About
FlickrFavsBackgroundR is an OS X command line application to download the latest favorite photo of a particular Flickr user and set it as OS X desktop wallpaper.

If there is no new favorite photo since the last run FlickrFavsBackgroundR sets one of all photos downloaded before by random.

FlickrFavsBackgroundR only considers images of size 'k' (large, 2048px on longest side).

I wrote it because there was no tool to automatically download favorite photos and set them as wallpaper and as a programming exercise to learn Apple's new programming language Swift.

## Usage
You can run the app by executing `./FlickrFavsBackgroundR flickrApiKey flickrUserId [fetchCount]` in a terminal or --- more common --- place this command in a script. I personally use the app to change the background every time my computer wakes up from sleep using [SleepWatcher](http://www.bernhard-baehr.de/) to excecute a wakeup script.

### Parameters
| Parameter    | Description
| ------------ | -----------
| flickrApiKey | a valid API Key for Flickr
| flickrUserId | a valid Flickr user id 
| fetchCount   | an optional number between 1 and 500, setting how many images should be requested to find one of size 'k'.

### Example (with fictional values)
`./FlickrFavsBackgroundR 714d0642970fac78530fb593c46dfa34 66081508@N42 50`

### Getting API Keys and User IDs
You can get your API key for free in [Flickr's App Garden](https://www.flickr.com/services/api/misc.api_keys.html).

Flickr User IDs can be found out at [idGettr](http://idgettr.com), for example the id of user `flickr` itself is `66956608@N06`.

## Bugs and Feature requests
Feel free to contact me, if you encounter a bug or if you miss a certain feature.

## License: MIT
Copyright (c) 2015 Silas Graffy

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
