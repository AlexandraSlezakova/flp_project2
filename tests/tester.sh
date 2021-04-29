#!/usr/bin/env bash
#title         : tester.sh
#description   : Test correctness of flp20-log.pl
#author        : Alexandra Slezakova (xsleza20)
#Year          : 2021
#usage         : ./tester [OPTION] see --help
#=================================================

RED='\033[0;31m'
BPur='\e[1;35m';
NC=$'\e[0m'
GREEN=$'\e[0;32m'

TIME=0

test_log_project()
{
  echo "----------------------------------------------------------"
  echo -e "${BPur}Tests for correctness of implementation${NC}"
  echo "----------------------------------------------------------"
  for ((i = 0 ; i < 19; i++)); do
        echo "File: test${i}.in"
        
        if [[ ${TIME} -eq 1 ]]; then
          CMD="time ${FILE} < test${i}.in"
        else
          CMD="${FILE} < test${i}.in"
        fi
        
        eval OUTPUT=\$\($CMD\)
        
        if [[ ${TIME} -eq 1 ]]; then
          printf "\n"
        fi
        
        if [[ $(< "test${i}".out) != "$OUTPUT" ]]; then
          echo -e "Result: ${RED}the program output and the required output are different${NC}"
        else
          echo "Result: ${GREEN}OK${NC}"
        fi

        if [[ ${i} -lt 18 ]]; then
          echo "----------------"
        fi

  done
}

help()
{
    echo "When no option is used, test results are printed, usage:"
    echo "   ./tester.sh [OPTION]"
    echo -e "\t-t print execution time of each test file"
}


FILE=../flp20-log
if [ ! -f "$FILE" ]; then
  echo "Error: Executable file $FILE doesn't exist."
  exit 0
fi

if [ "$1" == "--help" ]; then
   help
   exit 0
elif [ "$1" == "-t" ]
then
  TIME=1    
fi

test_log_project
