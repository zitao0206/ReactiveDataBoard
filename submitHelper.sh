#!/bin/bash
git status
sleep 2

echo "-------Begin-------"
if [ ! $1 ]; then
    read -p "Please input your Video commit message: " input
else
    input=$1
fi

git add -A
if [ -n "$input" ]; then
    git commit -m "$input"
else
    git commit -m "Script Submission"
fi

git push -f origin main

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

echo "Upgrade tag to："$latestTag
git tag $latestTag
git push -v -f origin refs/tags/$latestTag
sleep 3
echo "Publish to MDSpecs"
#./publishHelper.sh

#获取podspec文件名称

packageDIR=`pwd`
podName=${packageDIR##*/}
podspecFile=${podName}'.podspec'
echo "podName ----->"${podName}
echo 'COMMIT-podspec-FILE'
sourceRepo='https://github.com/Leon0206/MDSpecs.git'
sourceRepoName='MDSpecs'
version=`git describe --abbrev=0 --tags 2>/dev/null`
cd ..
specsDir=`pwd`/${sourceRepoName}/
echo "specsdir ---->"$specsDir
if [ -d $specsDir ];
then
cd $specsDir
git pull
else
git clone $sourceRepo
cd $specsDir
fi
echo 'FILE-PATH:'
echo ${specsDir}${podName}/${version}
echo $packageDIR/${podspecFile}
mkdir -p  ${specsDir}${podName}/${version}
echo ${specsDir}${podName}/${version}/${podspecFile}
cp $packageDIR/${podspecFile} ${specsDir}${podName}/${version}
echo '文件copy'
destSource='"'${version}'"'
sed -i ''  's/= smart_version/= '${destSource}'/g' ${specsDir}${podName}/${version}/${podspecFile}
echo 'Replace version number'

nowDIR=`pwd`
echo 'nowDIR->' ${nowDIR}

git status
git add .
git commit -m "[Add] ${podName} (${version})"
git push

cd ..
rm -rf specs

echo "--------End--------"
