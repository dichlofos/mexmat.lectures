#!/bin/bash
set -xe

if [ $# -lt 2 ] ; then
	echo "Usage: $0 <dir-name> <course-num>"
	exit 1
fi

dirName="$1"
course="$2"
nn="$3"

discipline="`echo $dirName | perl -p -e 's/EP - ([^-]+) - .*/\1/'`"
author="`echo $dirName | perl -p -e 's/EP - .* - (.*)/\1/'`"

properAuthor="`echo -n "$author" | sed -e 's/ //g'`"
properDirName="EP.$discipline.[$course].$properAuthor"

disciplineLC="`echo -n "$discipline" | tr [A-Z] [a-z]`"
authorLC="`echo -n "$author" | perl -p -e 's/^[A-Za-z]+\.[A-Za-z]+\. //' | tr [A-Z] [a-z]`"
distCourse="`echo -n "$course" | perl -p -e 's/\./s/g' | perl -p -e 's/$/s/'`"

if [ -n "$nn" ] ; then
	oldTexName="EP - $discipline - $author"
else
	oldTexName="EP - $discipline [$course] - $author"
fi
newTexName="EP.$discipline.[$course].$properAuthor"
distrName="ep-$disciplineLC-$distCourse-$authorLC"

#exit 0

hg mv "$dirName" "$properDirName"
cd "$properDirName"
hg mv "$oldTexName.tex" "$newTexName.tex"
hg rm -f makefile
echo "texify ($newTexName $distrName)" > CMakeLists.txt
hg add CMakeLists.txt
cd -
echo "add_subdirectory($properDirName)" >> CMakeLists.txt