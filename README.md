# rt-kits-tb-api
Experiments with Thunderbird and the SUMO aka Kitsune API 

## 2023-05-14 How to get questions with answers after my latest answer and open in a web browser

* Not perfect (only handles your last 20 answers, only handles 1 page of answers, doesn't handle where you answer more than once and other edge cases :-) ~!)
```bash
mlr --csv head -n 20 rtanglao-answers.csv | ./get-questions-with-answers-after-my-last-answer.rb 2>/tmp/rtlogfile | xargs -n 1 open
```

## 2023-05-13 How to get answers by creator
* The following creates [rtanglao-answers.csv](https://github.com/rtanglao/rt-kits-tb-api/blob/main/rtanglao-answers.csv)
```bash
./get-answers-by-creator.rb rtanglao
```

## 2023-05-13 How to use SQLite to search all the Firefox and Thunderbird kb articles including the HTML (sadly Markdown not available)
* Using datasette lite, load the CSV files.
  * [Firefox](https://lite.datasette.io/?csv=https%3A%2F%2Fraw.githubusercontent.com%2Frtanglao%2Frt-kits-tb-api%2Fmain%2Fdetails-firefox-kb-title-slug-all-articles.csv#/data/details-firefox-kb-title-slug-all-articles): Load https://github.com/rtanglao/rt-kits-tb-api/blob/main/details-firefox-kb-title-slug-all-articles.csv into datasette lite
  * [Thunderbird](https://lite.datasette.io/?csv=https%3A%2F%2Fraw.githubusercontent.com%2Frtanglao%2Frt-kits-tb-api%2Fmain%2Fthunderbird-kb-title-slug-all-articles-details.csv): Load https://github.com/rtanglao/rt-kits-tb-api/blob/main/thunderbird-kb-title-slug-all-articles-details.csv into datasette lite
## 2023-05-13 get all the Firefox kb articles
* The following creates: [firefox-kb-title-slug-all-articles.csv](https://github.com/rtanglao/rt-kits-tb-api/blob/main/firefox-kb-title-slug-all-articles.csv) (over 400 as of this writing) which you can then search using [datasette lite](https://lite.datasette.io/?csv=https%3A%2F%2Fraw.githubusercontent.com%2Frtanglao%2Frt-kits-tb-api%2Fmain%2Ffirefox-kb-title-slug-all-articles.csv) and recall :-) that you can also s[earch thunderbird articles using datasette lite](https://lite.datasette.io/?csv=https%3A%2F%2Fraw.githubusercontent.com%2Frtanglao%2Frt-kits-tb-api%2Fmain%2Fthunderbird-kb-title-slug-all-articles.csv#/data/thunderbird-kb-title-slug-all-articles)
```bash
 ./get-ff-kb-articles-list.rb
```
The following creates: [details-firefox-kb-title-slug-all-articles.csv](https://github.com/rtanglao/rt-kits-tb-api/blob/main/details-firefox-kb-title-slug-all-articles.csv)
```bash
./get-kb-article-detailed-list.rb firefox-kb-title-slug-all-articles.csv
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
