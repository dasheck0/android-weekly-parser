# android-weekly-parser
This will generate markdown files for the library section of all android weekly iusses

1) Run the downloader to download the whole android weekly archive
2) Run the parser To generate the library.json containg all the needed data
3) Optionally: Run the tagger to autogenerate tags using idftags
4) Run the formatter to generate a confluence.txt and a markdown.md containg the formatted data from libraries. json
5) Profit

To run all of this you need [hpricot](https://github.com/hpricot/hpricot) and [idftags](https://github.com/dasheck0/idftags). So make sure you have tehm installed before running the files.
