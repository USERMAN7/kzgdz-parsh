read -p "Input page number: " page_num
read -p "Input exercise number: " task
result=$(grep "p_${page_num}:" conf| cut -d: -f2 | tr ',' '\n' | grep -E "^${task}(-[0-9]+)?$")
echo $result

