#!/bin/bash

#TUNE THIS!
#First day of the year is
#Monday
day_counter=0

#Tuesday
#day_counter=1

#Wednesday
#day_counter=2

#Thursday
#day_counter=3

#Friday
#day_counter=4

#Saturday
#day_counter=5

#Sunday
#day_counter=6


#If current year is leap-year, use 1.
leapyear=0



function generate_month {
#NOTE: This function uses and modifies global $day_counter

total_days=$1
title=$2
#echo $title

echo "\begin{center}" >>body.tex
echo "\textsc{\large $title }" >>body.tex
echo "\end{center}" >> body.tex



#If month starts with any number of empty cells -> previous week is still continuing
if [[ $day_counter -ne 0 ]]
then
week_number=$((week_number-1))
fi


#Check if this month needs six rows for weeks
six_weeks=0
if [ $(($day_counter+$total_days)) -gt 35 ]  #If empty cells and total number of days are 36,37...
then
six_weeks=1
fi


#Week-numbers, depending how many weeks needed
if [ $six_weeks -eq 0 ]
then
rows="2 5.5 9 12.5 16"
else
rows="1.5 4.5 7.5 10.5 13.8 16.5"
fi

for i in $rows
do
echo "\marginnote{ $week_number }[$i cm]" >> body.tex
week_number=$((week_number+1))
done




echo "\begin{calendar}{\hsize}" >> body.tex



for (( i=1; i <= $day_counter; i++ ))
do
echo "\BlankDay"  >> body.tex
done

echo "\setcounter{calendardate}{1}" >> body.tex

for (( i=1; i <= $total_days; i++ ))
do

if [ $six_weeks -eq 0 ]
then
echo '\day{}{\vspace{2.9cm}}'  >> body.tex
else
echo '\day{}{\vspace{2.31cm}}'  >> body.tex
fi
done

echo "\finishCalendar"  >> body.tex
echo "\end{calendar}"  >> body.tex

day_counter=$(( (day_counter + total_days) %7))
}


#initialize global variable
week_number=1 

echo "" > body.tex

generate_month 31 "Tammikuu"
if [ $leapyear -eq 0 ]
then
generate_month 28 "Helmikuu"
else
generate_month 29 "Helmikuu"
fi
generate_month 31 "Maaliskuu"
generate_month 30 "Huhtikuu"
generate_month 31 "Toukokuu"
generate_month 30 "Kesäkuu"
generate_month 31 "Heinäkuu"
generate_month 31 "Elokuu"
generate_month 30 "Syyskuu"
generate_month 31 "Lokakuu"
generate_month 30 "Marraskuu"
generate_month 31 "Joulukuu"



cat header.tex body.tex footer.tex > calendar.tex

#Week-number 1 starts on the first monday of the year.
# So if year is not starting with monday, the first week has number "0".
# This "week 0", could be week 52 or 53, so just leave it empty.
sed  's/marginnote{ 0 }/marginnote{  }/' calendar.tex -i


pdflatex calendar.tex
#pdflatex calendar.tex 2>/dev/null > /dev/null

exit 0
