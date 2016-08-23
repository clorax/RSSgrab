# RSSgrab

[About](#about)  
[Configuration](#configuration)  
[Verbose Mode](#verbose-mode)

## About

RSSgrab is a perl script that can parse RSS feeds and download linked files.
For example, RSSgrab could parse the RSS feed for a podcast and download the podcast episodes, or parse a torrent RSS feed and download torrents that match certain criteria.  RSSgrab will only download files that are newer than its last run date/time.

## Configuration

RSSgrab is configured via the config.xml file.

The config element has two sub-elements:
* **logfile**: the location of the log file RSSgrab uses to store the timestamp of the last run
* **target_dir**: the directory where RSSgrab will save the files it downloads

RSSgrab can parse any number of RSS feeds, they are configured under the feed element:
* **url**: the URL of the RSS feed to parse
* **title**: the title you want to give to this RSS feed
* **filetype**: the filetype of the files this feed serves

Further, you can configure RSSgrab to only download items that match a specfic string and/or ignore items that match a specific string under the item element for each feed:
* **string**: the string to match for files that should be downloaded
* **exception**: the string to match for files that should not be downloaded

## Verbose Mode

By default, RSSgrab will only output to the console the files it downloads.  By using the verbose command line option, RSSgrab will also output the files it skips due to configured exceptions as well as the files it skips due to not being newer than the previous run date/time.

* Downloaded files will be preceded by a '+'.
* Skipped files due to an excpetion will be preceded by a '-'.
* Skipped files due to date/time will be preceded by a '~'.
