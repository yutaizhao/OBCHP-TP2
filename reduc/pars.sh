#!/bin/zsh
#check dotprod scripts for more commentaires
Path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
#sourceshttps://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself

n="8"
mediane=51
#READ IT !!!
echo "Trier $(( (mediane-1)*2+1 )) resultats pour n = $n, modifier ce script pour changer les valeurs"
sleep 1
echo "Par defaut : n vaut 8"


#ici j'ai utilise CC mais pas compiler comme le nom du variable comme dans exe.sh, sinon le nom du fichier sera trop long
for CC in gcc clang
do
    cd $Path
    cd $CC
    rm -rf "base_"$n "unroll_"$n
    sleep 2 #so that you can see the files has been deleted

    mkdir "base_"$n "unroll_"$n
    echo "Creating directories for base, unroll compiled by $CC"
    cd "base_"$n
    mkdir build
    cd ..
    cd "unroll_"$n
    mkdir build
    cd ..
    
    echo "Creating files for base"

    for flag in "O0" "O1" "O2" "O3" "Ofast"
    do
        #sort result according to mbps
        grep -v -e "title" -e "UNROLL" $CC"_"$flag"_"$n".txt" | sort -t';' -k12,12 -n > "./base_"$n"/build/sort_BASE_"$CC$flag".txt"
        #get only the info of med result
        echo "$flag" >> "./"$CC$n"_base_med_allflags.txt"
        sed -n $mediane'p' "./base_"$n"/build/sort_BASE_"$CC$flag".txt" >> "./"$CC$n"_base_med_allflags.txt"
        #get only mbps
        sed -n $mediane'p' "./base_"$n"/build/sort_BASE_"$CC$flag".txt" | cut -d";" -f 12 >> "./base_"$n"/"$CC$n"_base_med_mbps_allflags.txt"
        
        grep -v -e "title" -e "UNROLL" $CC"_"$flag"_"$n".txt" | cut -d";" -f 10 >> "./base_"$n"/build/mean_"$CC$flag".txt"
        grep -v -e "title" -e "UNROLL" $CC"_"$flag"_"$n".txt" | cut -d";" -f 11 >> "./base_"$n"/build/stddev_"$CC$flag".txt"
        grep -v -e "title" -e "UNROLL" $CC"_"$flag"_"$n".txt" | cut -d";" -f 12 >> "./base_"$n"/build/mbps_"$CC$flag".txt"
    done

    paste ./base_$n/build/mean_* > "./base_"$n"/"$CC$n"_base_mean_allflags.txt"
    paste ./base_$n/build/stddev_* > "./base_"$n"/"$CC$n"_base_stddev_allflags.txt"
    paste ./base_$n/build/mbps_* > "./base_"$n"/"$CC$n"_base_mbps_allflags.txt"
    sed 's/([^)]*)//g' "./base_"$n"/"$CC$n"_base_stddev_allflags.txt" > "./base_"$n"/"$CC$n"_base_stddev_PURE_allflags.txt"
    #chatgpt:sed 's/([^)]*)//g'
    
    echo "Creating files for unroll"
    
    for flag in "O0" "O1" "O2" "O3" "Ofast"
    do
        grep -v -e "title" -e "BASE" $CC"_"$flag"_"$n".txt" | sort -t';' -k12,12 -n > "./unroll_"$n"/build/sort_UNROLL_"$CC$flag".txt"
        echo "$flag" >> "./"$CC$n"_unroll_med_allflags.txt"
        sed -n $mediane'p' "./unroll_"$n"/build/sort_UNROLL_"$CC$flag".txt"  >> "./"$CC$n"_unroll_med_allflags.txt"
        sed -n $mediane'p' "./unroll_"$n"/build/sort_UNROLL_"$CC$flag".txt" | cut -d";" -f 12 >> "./unroll_"$n"/"$CC$n"_unroll_med_mbps_allflags.txt"
        
        grep -v -e "title" -e "BASE" $CC"_"$flag"_"$n".txt" | cut -d";" -f 10 >> "./unroll_"$n"/build/mean_"$CC$flag".txt"
        grep -v -e "title" -e "BASE" $CC"_"$flag"_"$n".txt" | cut -d";" -f 11 >> "./unroll_"$n"/build/stddev_"$CC$flag".txt"
        grep -v -e "title" -e "BASE" $CC"_"$flag"_"$n".txt" | cut -d";" -f 12 >> "./unroll_"$n"/build/mbps_"$CC$flag".txt"
    done

    paste ./unroll_$n/build/mean_*.txt > "./unroll_"$n"/"$CC$n"_unroll_mean_allflags.txt"
    paste ./unroll_$n/build/stddev_*.txt > "./unroll_"$n"/"$CC$n"_unroll_stddev_allflags.txt"
    paste ./unroll_$n/build/mbps_*.txt > "./unroll_"$n"/"$CC$n"_unroll_mbps_allflags.txt"
    sed 's/([^)]*)//g' "./unroll_"$n"/"$CC$n"_unroll_stddev_allflags.txt" > "./unroll_"$n"/"$CC$n"_unroll_stddev_PURE_allflags.txt"
    #chatgpt:sed 's/([^)]*)//g'

done
echo "FIN"
echo "ATTENTION : les fichiers generes qui ne sont pas dans BUILD servent DIRECTEMENT à la construction des Graphes/Tableaux pour le rapport"
