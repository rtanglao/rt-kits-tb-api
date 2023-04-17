# rt-kits-tb-api
Experiments with Thunderbird and the SUMO aka Kitsune API 

## 2023-04-16 add linking field using mlr
* The following command line snippet generates `thunderbird-kb-title-slug-all-articles-details-with-link-without-html.csv`
* `\x27` is a single quotation mark, `\x22` i.e. `"` does NOT work (adds two quotation marks instead of one!) for some strange reason. bug?

```bash
mlr --csv put -f make-bare-link.mlr thunderbird-kb-title-slug-all-articles-details-without-html.csv \
> thunderbird-kb-title-slug-all-articles-details-with-link-without-html.csv
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
thunderbird-kb-title-slug-all-articles-details-with-link-without-html.csv
