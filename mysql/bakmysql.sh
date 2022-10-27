dblist="
ncbd
"

for db in ${dblist}
do
	/usr/local/mysql/bin/mysqldump -uroot -p123456a ${db} > ${db}.$(date +%F).sql
done

