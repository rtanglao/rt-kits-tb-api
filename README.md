# rt-kits-tb-api
Experiments with Thunderbird and the SUMO aka Kitsune API 

## 2023-04-16 add linking field using mlr
* `\x27` is a single quotation mark, `\x22` i.e. `"` does NOT work for some strange reason. bug?
```bash
mlr --csv put '$link = "<a href=\x27https://support.mozilla.org" . $url . "\x27>" . $title . "</a>"' thunderbird-kb-title-slug-all-articles-details-without-html.csv
```

## 2023-04-16 Get a summary article list and then a detailed list and and then delete the `html` column in order to import into a spreadsheet

* 0\. (`brew install miller` on macOS)

* 1\. Get kb article summary list
```bash
 # creates thunderbird-kb-title-slug-all-articles.csv
./get-kb-articles-list.rb
```
* 2\. Get kb article detailed list
```bash
# creates thunderbird-kb-title-slug-all-articles-details.csv
./get-kb-article-detailed-list.rb thunderbird-kb-title-slug-all-articles.csv
```
* 3\. Count the number of articles
```bash
mlr --csv count thunderbird-kb-title-slug-all-articles-details.csv # wc -l is incorrect due to the html field
count
153
```
* 4\. Delete HTML column
```bash
# creates thunderbird-kb-title-slug-all-articles-details-without-html.csv
mlr --csv cut -x -f html thunderbird-kb-title-slug-all-articles-details.csv > \
thunderbird-kb-title-slug-all-articles-details-without-html.csv
```
