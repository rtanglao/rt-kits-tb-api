# rt-kits-tb-api
Experiments with Thunderbird and the SUMO aka Kitsune API 
## 2023-05-13 get all the Firefox kb articles
* The following creates: [firefox-kb-title-slug-all-articles.csv](https://github.com/rtanglao/rt-kits-tb-api/blob/main/firefox-kb-title-slug-all-articles.csv) which you can then search using [datasette lite](https://lite.datasette.io/?csv=https%3A%2F%2Fraw.githubusercontent.com%2Frtanglao%2Frt-kits-tb-api%2Fmain%2Ffirefox-kb-title-slug-all-articles.csv)
```bash
 ./get-ff-kb-articles-list.rb
```
## 2023-04-23 get fixed random 2 questions
`brew install coreutils` to get `shuf` and `gshuf` on macOS
```bash
. ./get-fixed-random.sh
cd 2023
# `42` is the fixed seed
mlr -s ../get-unanswered.mlr 2023-04-20-2023-04-20-thunderbird-creator-answers-desktop-all-locales.csv | \
shuf -n 2 --random-source=<(get_fixed_random 42) | xargs -n 1 open
```
## 2023-04-22 open unanswered thunderbird questions in Firefox
```bash
cd 2023
mlr -s ../get-unanswered.mlr 2023-04-20-2023-04-20-thunderbird-creator-answers-desktop-all-locales.csv | xargs -n 1 open
```
## 2023-04-16 add link field using mlr
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
