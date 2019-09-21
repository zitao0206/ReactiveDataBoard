#!/bin/bash
git status
sleep 2
echo "-------Begin-------"
git add .
git commit -am "自动化代码提交"
git push origin master

git fetch
result=$(git tag --list)

OLD_IFS="$IFS"
arr=($result)
IFS="$OLD_IFS"

lastTag=${arr[${#arr[*]}-1]}

OLD_IFS=$IFS
IFS='.'
arr1=($lastTag)
IFS=$OLD_IFS

lastchar=${arr1[${#arr1[*]}-1]}

latestChar=$[$lastchar+1]
echo $latestChar
latestTag=${arr1[0]}.${arr1[1]}.$latestChar

for((k=0;k<100;k++)) do
    if [[ "${arr[@]}" =~ $latestTag ]];then
        latestChar=$[$latestChar+1]
        latestTag=${arr1[0]}.${arr1[1]}.$latestChar
    fi
done;

echo "自动升级tag为："$latestTag
git tag $latestTag
git push -v origin refs/tags/$latestTag
sleep 3
echo "自动发版到MDSpecs"
./publishHelper.sh

echo "--------End--------"
