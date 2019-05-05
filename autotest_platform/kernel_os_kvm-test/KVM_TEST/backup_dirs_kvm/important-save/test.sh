#/bin/bash
project_path=$(cd `dirname $0`; pwd)

echo "helloworld"

echo "project_path:$project_path"
sh ${project_path}/call.sh
${project_path}/a.out

echo "==================="
sleep 9
echo "==================="

