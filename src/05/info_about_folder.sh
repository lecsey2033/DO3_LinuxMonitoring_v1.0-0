#!/bin/bash

start=`date +%s`
function TOP_5() {
du -h $1 2>/dev/null | sort -hr | head -5 | awk 'BEGIN{i=1}{printf "%d - %s, %s\n", i, $2, $1; i++}'
}

function TOP_10() {
for num in {1..10}
  do
      file_line=$(find $1 2>/dev/null -type f -exec du -h {} + | sort -rh | head -10 | sed "${num}q;d")
      if ! [[ -z $file_line ]]
      then
          echo -n "$num - "
          echo -n "$(echo $file_line | awk '{print $2}'), "
          echo -n "$(echo $file_line | awk '{print $1}'), "
          echo "$(echo $file_line | grep -m 1 -o -E "\.[^/.]+$" | awk -F . '{print $2}')"
      fi
  done
}

function TOP_10_EXEC() {
  echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"
  for num in {1..10}
  do
      file_line=$(find $1 2>/dev/null -type f -executable -exec du -h {} + | sort -rh | head -10 | sed "${num}q;d")
      if ! [[ -z $file_line ]]
      then
          echo -n "$num - "
          echo -n "$(echo $file_line | awk '{print $2}'), "
          echo -n "$(echo $file_line | awk '{print $1}'), "

          path=$(echo $file_line | awk '{print $2}')
          MD5=$(md5sum $path | awk '{print $1}')
          echo "$MD5"
      fi
  done
}

function part5() {
FOLDERS=$(ls -l ${1} | grep ^d | wc -l)
FILES=$(ls -la ${1} | grep ^- | wc -l)
CONF_FILES=$(ls -l ${1} | grep .conf | wc -l)
TEXT_FILES=$(ls -l ${1} | grep .txt | wc -l)
EXECUTABLE_FILES=$(ls -l ${1} | grep .exe | wc -l)
LOG_FILES=$(ls -l ${1} | grep .log | wc -l)
ARCH_FILES=$(ls -l ${1} | grep -E '*.zip|*.7z|*.rar|*.tar' | wc -l)
SYMBOLIC_LINKS=$(find $1 2>/dev/null -type l | wc -l | awk '{print $1}')
echo "Total number of folders (including all nested ones) = ${FOLDERS}"

echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
TOP_5 ${1}

echo "Total number of files = ${FILES}"

echo -n "Number of:
Configuration files (with the .conf extension) = ${CONF_FILES}
Text files = ${TEXT_FILES}
Executable files = ${EXECUTABLE_FILES}
Log files (with the extension .log) = ${LOG_FILES}
Archive files = ${ARCH_FILES}
Symbolic links = ${SYMBOLIC_LINKS}
TOP 10 files of maximum size arranged in descending order (path, size and type):
"
TOP_10 ${1}
TOP_10_EXEC ${1}
end=`date +%s`
echo "Script execution time (in seconds) = $(($end-$start))"
}