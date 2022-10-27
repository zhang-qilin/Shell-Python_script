#!/bin/env python3
import pymysql


def mysql_check(host, user="root", password="123456a", port=3306, db="information_schema"):
    conn = pymysql.connect(host=host, user=user, password=password, port=port, db=db)
    cour = conn.cursor()
    sql = "select DATA_LENGTH, TABLE_ROWS , TABLE_NAME ,TABLE_SCHEMA  from information_schema.TABLES"
    cour.execute(sql)
    rows = cour.fetchall()
    cour.close()
    conn.close()
    result = {}
    for row in rows:
        dbbase = row[3]
        size = row[0] or 0
        rows = row[1] or 0
        if result.get(dbbase) is None:
            result[dbbase] = {"size": size, "rows": rows, "tables": 1}
        else:
            result[dbbase]["size"] = result[dbbase]["size"] + size
            result[dbbase]["rows"] = result[dbbase]["rows"] + size
            result[dbbase]["tables"] += 1
    return result


def main(host, user="root", password="123456a", port=3306, db="information_schema"):
    dbinfo = mysql_check(host=host, user=user, password=password, port=port, db=db)
    for basename in dbinfo:
        size = dbinfo[basename]["size"]
        if 1024 < size < 1024 * 1024:
            size = "%.2fkb" % (size / 1024)
        elif 1024 * 1024 - 1 < size < 1024 * 1024 * 1024:
            size = "%.2fmb" % (size / 1024 / 1024)
        else:
            size = "%.2fgb" % (size / 1024 / 1024 / 1024)
        print(host, basename, dbinfo[basename]["tables"], dbinfo[basename]["rows"], size)


if __name__ == "__main__":
    print("主机\t数据库名\t总表数\t总行数\t占用空间")
    main("127.0.0.1")
