#!/bin/bash

clear

echo "[-----------------	Starting	-----------------]"
echo "\n\n"

echo "[-----------------	Filtering out 2017-18 data from article1.csv	-----------------]"
echo "\n\nStarting..."
awk -F, '$7 + 0 == 2017 || $7 + 0 == 2018' ./all-the-news/articles1.csv > ./all-the-news/news1.csv
echo "...Done!\n\n"

echo "[-----------------	Filtering out 2017-18 data from article2.csv	-----------------]"
echo "\n\nStarting..."
awk -F, '$7 + 0 == 2017 || $7 + 0 == 2018' ./all-the-news/articles2.csv > ./all-the-news/news2.csv
echo "...Done!\n\n"

echo "[-----------------	Filtering out 2017-18 data from article3.csv	-----------------]"
echo "\n\nStarting..."
awk -F, '$7 + 0 == 2017 || $7 + 0 == 2018' ./all-the-news/articles3.csv > ./all-the-news/news3.csv
echo "...Done!\n\n"

echo "[-----------------	Combining outputs into 201718-all-the-news.csv	-----------------]"
echo "\n\nStarting..."
OutFileName="./all-the-news/201718-all-the-news.csv"
i=0
for filename in ./all-the-news/news*.csv; do 
 if [ "$filename"  != "$OutFileName" ] ;
 then 
   if [[ $i -eq 0 ]] ; then 
      head -1  $filename >   $OutFileName 
   fi
   tail -n +2  $filename >>  $OutFileName
   i=$(( $i + 1 ))
 fi
done
echo "...Done!\n\n"

echo "[-----------------	Removing unused files	-----------------]"
echo "\n\nRemoving files..."
ls -l ./all-the-news/news*.csv
rm ./all-the-news/news*.csv
echo "...Files removed!\n\n"

echo "[-----------------	Filtering related crypto data by keyword	-----------------]"
echo "\n\nStarting..."
awk -F, '$3 ~ /[Bb][Ii][Tt][Cc][Oo][Ii][Nn]/ || $3 ~ /[Ee][Tt][Hh][Ee][Rr][Ee][Uu][Mm]/ || $3 ~ /[Cc][Rr][Yy][Pp][Tt][Oo][Cc][Uu][Rr][Rr][Ee][Nn][Cc][Yy]/ || $10 ~ /[Bb][Ii][Tt][Cc][Oo][Ii][Nn]/ || $10 ~ /[Ee][Tt][Hh][Ee][Rr][Ee][Uu][Mm]/ || $10 ~ /[Cc][Rr][Yy][Pp][Tt][Oo][Cc][Uu][Rr][Rr][Ee][Nn][Cc][Yy]/' ./all-the-news/201718-all-the-news.csv > ./all-the-news/201718-filtered-news.csv 
echo "...Done!\n\n"

echo "[-----------------	Adding header to 201718-filtered-news.csv	-----------------]"
echo "\n\nStarting..."
{ echo 'rownumber,id,title,publication,author,date,year,month,url,content'; cat ./all-the-news/201718-filtered-news.csv; } > ./all-the-news/201718-filtered-news-complete.csv
echo "...Done!\n\n"

echo "[-----------------	Finished	-----------------]"

