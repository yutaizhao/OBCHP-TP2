#!/bin/zsh
#check dotprod scripts for more commentaires
prog="reduc"
run=101
n1=8
r1=1000


echo "Vous etes sur de bien vouloir executer le programme ? les anciens resultats seront perdus"
echo "Entrer q pour quitter, d'autres pour continuer"
read resp
if [[ "$resp" == "q" ]]
then
    echo "Quitter avec succes !"
    exit
fi

echo "le programme est $prog, sera executé $run fois"
echo "si ce n'est pas le cas souhaité, modifier ce script directement"
sleep 1

Path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
#sourceshttps://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself

cd $Path

if ! echo "$Path" | grep -q "$prog"
then
    echo "FAILED !!!"
    echo "On est à : $Path"
    echo "On ne trouve pas les fichiers à compiler pour $prog"
    sleep 1
    echo "Solution 1 : modifier le nom du programme dans ce script"
    echo "Solution 2 : deplacer ce script dans le bon repertoire"
    exit
fi

for compiler in gcc clang
do
    rm -rf $compiler
    sleep 2 #so that you can see the files has been really deleted
    mkdir $compiler
    cd $compiler
    mkdir build
    cd build
    mkdir $compiler"_O0" $compiler"_O1" $compiler"_O2" $compiler"_O3" $compiler"_Ofast"
    cd ..
    cd ..

    for flag in "O0" "O1" "O2" "O3" "Ofast"
    do
        sed -i.bak "s/OFLAGS=-.*/OFLAGS=-$flag/g" Makefile #without bak I got error...
        make CC=$compiler
        echo "test for $compiler, $flag, n=$n1, r=$r1"
        
        for (( i=0; i < $run; ++i ))
        do
            "./"$prog $n1 $r1 >> "./"$compiler"/"$compiler"_"$flag"_"$n1".txt"
        done
        
        mv $prog "./"$compiler"/build/"$compiler"_"$flag
        mv $prog".dSYM" "./"$compiler"/build/"$compiler"_"$flag
    done
done

rm Makefile.bak
echo "FIN"
echo "ATTENTION : $run résultats sont genérés, verifier que la valeur de mediane = $((run/2+1)) dans pars.sh"
echo "ATTENTION : les fichiers generes qui non sont pas dans BUILD servent DIRECTEMENT à pars.sh"
