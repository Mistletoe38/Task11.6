#!/bin/bash
if [ ! -f access.log ]; then
	echo "Файл access.log не существует"
	exit 1
elif [ -f report.txt ]; then
	> report.txt
fi
echo -e "Отчет о логе веб-сервера\n=======================" >> report.txt
allrequest_count=$(wc -l < access.log)
echo -e "Общее количество запросов:\t$allrequest_count" >> report.txt
uniqueIP_count=$(awk '{ print $1 }' access.log | sort -u | wc -l)
echo -e "Количество уникальных IP-адресов:\t$uniqueIP_count" >> report.txt
awk 'BEGIN { print "\nКоличество запросов по методам:" } {
	if ($6 ~ /"GET/) get++;
	else if ($6 ~ /"POST/) post++;
}
END {
	print "\t", get, "GET";
	print "\t", post, "POST\n"}' access.log >> report.txt
awk '{ counts[$7]++ } END {
	max_count=0;
	for(site in counts) {
		if(counts[site]>max_count) {
			max_count=counts[site];
			max_site=site } }
	print "Самый популярный URL: ", max_count, max_site }' access.log >> report.txt
echo "Отчет сохранен в файл report.txt"
