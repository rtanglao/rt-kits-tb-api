# rt-kits-tb-api
Experiments with Thunderbird and the SUMO aka Kitsune API 

## 2025-01-26 get all the SUMO KB Localizers
```bash
 mlr --csv --from thunderbird-localized-revisions.csv filter '($datetime =~ "^2024-")' \
then count-distinct -f creator \
then sort -nr count thunderbird-localized-revisions.csv
```
* results n:
```
creator,count
/it/user/michro/,188
/nl/user/markh2/,98
/ru/user/Goudron/,98
/de/user/Artist/,82
/el/user/d.spentzos/,82
/pl/user/TyDraniu/,78
/zh-CN/user/wxie2016/,72
/fr/user/Mozinet/,62
/fr/user/Y.D./,60
/pt-PT/user/Manuela.Silva/,54
/fr/user/moz_contrib/,54
/uk/user/hotr1pak/,48
/pl/user/teo951/,26
/pt-BR/user/marcelo.ghelman/,20
/ja/user/trsn4649/,18
/cs/user/soucet/,16
/hu/user/kkemenczy/,16
/el/user/norhorn/,12
/zh-CN/user/aiwwe0897/,12
/pt-BR/user/jhonatasrm/,12
/de/user/graba/,10
/nl/user/Mad_Maks/,10
/ja/user/marsf/,8
...
```

## 2025-01-22 Search all kb articles, the API has changed! There is now a column with kitsune markdown called `text`
* Search engine for all products: https://lite.datasette.io/?csv=https%3A%2F%2Fraw.githubusercontent.com%2Frtanglao%2Frt-kits-tb-api%2Fmain%2Fdetails-allproducts-kb-title-slug-all-articles.csv#/data/details-allproducts-kb-title-slug-all-articles
## 2025-01-22 Get all the articles to get the 2024 contributors via the revisions
```bash
# 1. the following updates: allproducts-kb-title-slug-all-articles.csv
./get-all-products-kb-articles-list.rb
./get-kb-article-detailed-list.rb allproducts-kb-title-slug-all-articles.csv
# 2. resulting file is: details-allproducts-kb-title-slug-all-articles.csv
# 3. get all thunderbird desktop and android articles
 mlr --csv filter '$products_str =~ "thunderbird"' details-allproducts-kb-title-slug-all-articles.csv \
> thunderbird-kb-title-slug-all-articles-details.csv
# 4. get all the en-US revisions
mlr --headerless-csv-output --csv cut -f slug thunderbird-kb-title-slug-all-articles-details.csv | \
./get-revisions-sumo-kb-urls.rb > thunderbird-revisions.csv
# 5. get all the localized URLs
 mlr --headerless-csv-output --csv cut -f slug thunderbird-kb-title-slug-all-articles-details.csv \
| ./get-localized-sumo-kb-urls.rb > thunderbird-localized-sumo-kb-article-slugs.csv
# 6. get all the non en-US revisions, bug, fails if the history is no longer visible to anonymous users i.e. translation wasn't approved.
mlr --headerless-csv-output --csv cut -f localized-slug thunderbird-localized-sumo-kb-article-slugs.csv | \
./get-localized-revisions-sumo-kb-urls.rb > thunderbird-localized-revisions.csv 2>logs-get-localized-revisions-stderr.txt &
```
## 2024-06-24 Get all the Firefox Desktop revisions
```bash
 mlr --headerless-csv-output --csv cut -f slug firefox-kb-title-slug-all-articles.csv | \
./get-revisions-sumo-kb-urls.rb > firefox-revisions.csv
```

## 2024-06-24 Count all the Thunderbird revisions by creator
```bash
roland@Rolands-MacBook-Pro rt-kits-tb-api % mlr --csv count-distinct -f creator then sort -nr count \
thunderbird-revisions.csv
```

```csv
creator,count
/en-US/user/wsmwk/,259
/en-US/user/Tonnes/,210
/en-US/user/Chris_Ilias/,166
/en-US/user/rtanglao/,142
/en-US/user/tb_migration/,87
/en-US/user/firefox877/,81
/en-US/user/MattAuSupport/,73
/en-US/user/michro/,64
/en-US/user/dyvik1001/,55
/en-US/user/upwinxp/,49
/en-US/user/AliceWyman/,46
/en-US/user/Artist/,43
/en-US/user/Swarnava/,40
/en-US/user/kaie/,39
/en-US/user/user669794/,36
/en-US/user/Mozinet/,35
/en-US/user/vesper/,35
/en-US/user/user917725/,30
/en-US/user/heyjoni/,29
/en-US/user/underpass/,28
/en-US/user/buluma_michael/,23
/en-US/user/ideato/,22
/en-US/user/Toad-Hall/,22
/en-US/user/pollti/,17
/en-US/user/ryanleesipes/,15
/en-US/user/markh2/,14
/en-US/user/Zenos/,14
/en-US/user/kenptr/,14
/en-US/user/MakeMyDay/,13
/en-US/user/scootergrisen/,12
/en-US/user/gpiero61/,12
/en-US/user/alta88/,11
/en-US/user/marcelo.ghelman/,9
/en-US/user/john.bieling/,9
/en-US/user/dannycolin/,8
/en-US/user/Goofy_BZ/,8
/en-US/user/TyDraniu/,7
/en-US/user/el.cameleon/,6
/en-US/user/oeekker/,6
/en-US/user/FilipusKlutiero/,6
/en-US/user/jjuslin/,6
/en-US/user/mstanke/,6
/en-US/user/MagicFab/,5
/en-US/user/christ1/,5
/en-US/user/Arpctech/,5
/en-US/user/linuxflower/,5
/en-US/user/cecilebertin/,4
/en-US/user/ComputerWhiz/,4
/en-US/user/Verdi/,4
/en-US/user/denyshon/,4
/en-US/user/philipp/,4
/en-US/user/roy-orbison/,4
/en-US/user/yfdyh000/,4
/en-US/user/Sancus/,4
/en-US/user/soucet/,4
/en-US/user/stancestans/,4
/en-US/user/mkmelin/,4
/en-US/user/moz_contrib/,4
/en-US/user/John99/,3
/en-US/user/Wavid/,3
/en-US/user/plwt/,3
/en-US/user/Giulio.Tripi/,3
/en-US/user/Joergen/,3
/en-US/user/anlazar/,3
/en-US/user/Meghraj/,3
/en-US/user/dane.parsley/,3
/en-US/user/finn0/,3
/en-US/user/bd./,3
/en-US/user/feer56/,3
/en-US/user/elizabethmitchell/,3
/en-US/user/satdav/,3
/en-US/user/jeff.youmans/,2
/en-US/user/jeboftopeka/,2
/en-US/user/abradaranhagh/,2
/en-US/user/Y.D./,2
/en-US/user/ElhemEnohpi/,2
/en-US/user/firefox_helper.inhabitants/,2
/en-US/user/rmcguigan/,2
/en-US/user/romado33/,2
/en-US/user/Terike/,2
/en-US/user/MozGianluc/,2
/en-US/user/kelimutu/,2
/en-US/user/mlj1/,2
/en-US/user/antti.hukkanen/,2
/en-US/user/user47661/,2
/en-US/user/Chicks_Hate_Me/,2
/en-US/user/wensveen/,2
/en-US/user/PascalBoulerie/,2
/en-US/user/cautious/,2
/en-US/user/R33TR0W/,2
/en-US/user/Banban/,2
/en-US/user/Kulla/,2
/en-US/user/drtyghgfpoiiihgg/,2
/en-US/user/zerdo/,2
/en-US/user/davblayn/,2
/en-US/user/LogoX/,2
/en-US/user/wordstar/,2
/en-US/user/bugzilla0248/,2
/en-US/user/dgalindo/,1
/en-US/user/tech53/,1
/en-US/user/MMN1/,1
/en-US/user/ashickurnoor/,1
/en-US/user/UltimateSupreme/,1
/en-US/user/lsiebert/,1
/en-US/user/jamie.aurorac/,1
/en-US/user/bugcon/,1
/en-US/user/scoobidiver/,1
/en-US/user/ihaake/,1
/en-US/user/orschiro/,1
/en-US/user/myo33/,1
/en-US/user/eldonquijote23/,1
/en-US/user/marsf/,1
/en-US/user/mihait/,1
/en-US/user/chdlr/,1
/en-US/user/rohan.rhnvrm/,1
/en-US/user/Tacsipacsi/,1
/en-US/user/atErik/,1
/en-US/user/jscher2000/,1
/en-US/user/duggabe/,1
/en-US/user/csobowale2/,1
/en-US/user/teo951/,1
/en-US/user/hotmail./,1
/en-US/user/empty970005/,1
/en-US/user/JlAngelle1/,1
/en-US/user/rrosario/,1
/en-US/user/steve.nordquist1/,1
/en-US/user/geoffpkr/,1
/en-US/user/seulgi/,1
/en-US/user/dskmori/,1
/en-US/user/amsg/,1
/en-US/user/jensb/,1
/en-US/user/larry118/,1
/en-US/user/mark332/,1
/en-US/user/Stevec5088/,1
/en-US/user/jkohler9/,1
/en-US/user/boersenfeger/,1
/en-US/user/SirTobey20/,1
/en-US/user/WoodBTech/,1
/en-US/user/jhhere/,1
/en-US/user/doug.hs/,1
/en-US/user/mikeshipka/,1
/en-US/user/edward14/,1
/en-US/user/rwhogg/,1
/en-US/user/shift7solutions/,1
/en-US/user/Noah_SUMO/,1
/en-US/user/keriou/,1
/en-US/user/mdjango/,1
/en-US/user/Arfantrendy09/,1
/en-US/user/evgeniya.zbitskaya/,1
/en-US/user/peregrin.hendley/,1
/en-US/user/decode/,1
/en-US/user/cem.grundig/,1
/en-US/user/diegocr/,1
/en-US/user/MERose/,1
/en-US/user/gierschv/,1
/en-US/user/Kaartic/,1
/en-US/user/jevangelho/,1
/en-US/user/sijanecantonluka/,1
/en-US/user/tekaham/,1
/en-US/user/user955666/,1
/en-US/user/niilos/,1
/en-US/user/anthony.m.mancini/,1
/en-US/user/hossainalikram/,1
/en-US/user/otherechoes/,1
/en-US/user/NeilErdwien/,1
/en-US/user/bbonacci/,1
/en-US/user/erling.rosag/,1
/en-US/user/hythmkhyry00/,1
/en-US/user/roosterbkc888/,1
/en-US/user/lisah933/,1
/en-US/user/sagarroka53/,1
/en-US/user/khosraviakbar02/,1
/en-US/user/msarthur/,1
/en-US/user/user145160793143493487427306403094455651964/,1
/en-US/user/and4258/,1
/en-US/user/.xss/,1
/en-US/user/jorgk/,1
/en-US/user/anonymous_/,1
/en-US/user/DJKing101/,1
/en-US/user/Chelmite/,1
/en-US/user/amagdo/,1
/en-US/user/rafael.granado/,1
/en-US/user/user19880069563622738483721635866239326327/,1
/en-US/user/aglamon/,1
/en-US/user/stuples/,1
/en-US/user/benwrk/,1
/en-US/user/henry35/,1
/en-US/user/daniel224/,1
/en-US/user/nf5/,1
/en-US/user/hwj1/,1
/en-US/user/rptb1+firefox/,1
/en-US/user/steve.chessin/,1
/en-US/user/justman10000/,1
/en-US/user/oopsallnaps/,1
/en-US/user/symbolices/,1
/en-US/user/aparise/,1

```
## 2024-06-23 How To get all the Thunderbird revisions
```bash
mlr --headerless-csv-output --csv cut -f slug thunderbird-kb-title-slug-all-articles-details.csv | \
./get-revisions-sumo-kb-urls.rb > thunderbird-revisions.csv
```

## 2024-04-01 remove all non Thunderbird URLs
```bash
./remove-non-thunderbird-lines.rb thunderbird-localized-sumo-kb-article-slugs.csv just-pageviews-2024-04-01-GA-jan1-dec31-2023-top5000-pageviews.csv

```
## 2024-03-31 how to get all the Thunderbird localized URLs
```bash
 mlr --headerless-csv-output --csv cut -f slug thunderbird-kb-title-slug-all-articles-details.csv \
| ./get-localized-sumo-kb-urls.rb > thunderbird-localized-sumo-kb-article-slugs.csv
```

## 2024-03-24 how to search thunderbird-kb-title-slug-all-articles-details.csv

* Open it in datasette: https://lite.datasette.io/?csv=https%3A%2F%2Fraw.githubusercontent.com%2Frtanglao%2Frt-kits-tb-api%2Fmain%2Fthunderbird-kb-title-slug-all-articles-details.csv

## 2023-03-31 Better way to produce thunderbird-kb-title-slug-all-articles-details.csv!
```bash
 mlr --csv filter '$products_str =~ "thunderbird"' details-allproducts-kb-title-slug-all-articles.csv \
> thunderbird-kb-title-slug-all-articles-details.csv
```

## 2024-03-24 manual way: how to produce thunderbird-kb-title-slug-all-articles-details.csv
```sql
select id, title, slug, url, locale, summary, html, products_str, topics_str \
from [details-allproducts-kb-title-slug-all-articles] where "products_str" like :p0 order by rowid 
```
and then save as thunderbird-kb-title-slug-all-articles-details.csv which you can load into sqlite using datasette and search it



#### To count the number of filtered records!
```bash
roland@Rolands-MacBook-Pro rt-kits-tb-api % mlr --csv filter '$products_str =~ "thunderbird"' then count details-allproducts-kb-title-slug-all-articles.csv                      
count
154
```


## 2023-08-01 get articles for all products and search for "firefox account"

```bash
./get-all-products-kb-articles-list.rb
# the above script creates: allproducts-kb-title-slug-all-articles.csv
 ./get-kb-article-detailed-list.rb allproducts-kb-title-slug-all-articles.csv
# resulting file is: details-allproducts-kb-title-slug-all-articles.csv
```

*  Add  [details-allproducts-kb-title-slug-all-articles.csv](https://github.com/rtanglao/rt-kits-tb-api/blob/main/details-allproducts-kb-title-slug-all-articles.csv) to google drive and have fun :-)
* AND / OR search it with datasette lite: https://lite.datasette.io/?csv=https%3A%2F%2Fraw.githubusercontent.com%2Frtanglao%2Frt-kits-tb-api%2Fmain%2Fdetails-allproducts-kb-title-slug-all-articles.csv#/data/details-allproducts-kb-title-slug-all-articles
  * SQLite query: `select rowid, id, title, slug, url, locale, summary, html, products_str, topics_str from [details-allproducts-kb-title-slug-all-articles] where "html" like :p0 order by rowid limit 101` where `p0` = `%firefox account%` [datasette sqlite query returns 147 rows](https://lite.datasette.io/?csv=https%3A%2F%2Fraw.githubusercontent.com%2Frtanglao%2Frt-kits-tb-api%2Fmain%2Fdetails-allproducts-kb-title-slug-all-articles.csv#/data/details-allproducts-kb-title-slug-all-articles?_filter_column=html&_filter_op=contains&_filter_value=firefox+account&_sort=rowid) where the `html` column contains `Firefox account` ; also available as a CSV file that you can upload to Google Sheets: [https://github.com/rtanglao/rt-kits-tb-api/blob/main/all-desktop-articles-that-have-firefox-account-in-the-html-column.csv](https://github.com/rtanglao/rt-kits-tb-api/blob/main/all-products-articles-that-have-firefox-account-in-the-html-column.csv)
## 2023-08-01 get all desktop articles and search for "Firefox accounts"

```bash
# changed API delay to 10 seconds to prevent dreaded 429 error code
 ./get-ff-kb-articles-list.rb
# changed API delay to 5 seconds 
 ./get-kb-article-detailed-list.rb firefox-kb-title-slug-all-articles.csv
# resulting file is: details-firefox-kb-title-slug-all-articles.csv
```

* Add  [details-firefox-kb-title-slug-all-articles.csv](https://github.com/rtanglao/rt-kits-tb-api/blob/main/details-firefox-kb-title-slug-all-articles.csv) to google drive and have fun :-)
* AND / OR search it with datasette lite: https://lite.datasette.io/?csv=https%3A%2F%2Fraw.githubusercontent.com%2Frtanglao%2Frt-kits-tb-api%2Fmain%2Fdetails-firefox-kb-title-slug-all-articles.csv#/data/details-firefox-kb-title-slug-all-articles
  * SQLite query: `select rowid, id, title, slug, url, locale, summary, html, products_str, topics_str from [details-firefox-kb-title-slug-all-articles] where "html" like :p0 order by rowid limit 101` where `p0` = `%firefox account%` [datasette sqlite query returns 54 rows](https://lite.datasette.io/?csv=https%3A%2F%2Fraw.githubusercontent.com%2Frtanglao%2Frt-kits-tb-api%2Fmain%2Fdetails-firefox-kb-title-slug-all-articles.csv#/data/details-firefox-kb-title-slug-all-articles?_filter_column_1=html&_filter_op_1=contains&_filter_value_1=firefox+account&_filter_column=&_filter_op=exact&_filter_value=&_sort=rowid) where the `html` column contains `Firefox account` ; also available as a CSV file that you can upload to Google Sheets: https://github.com/rtanglao/rt-kits-tb-api/blob/main/all-desktop-articles-that-have-firefox-account-in-the-html-column_files.csv
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
