#!/usr/bin/env python

import sys
import logging
import traceback
import ConfigParser
import MySQLdb

logging.basicConfig(level = logging.DEBUG)

def get_config_item(section, item):
    config = ConfigParser.ConfigParser()
    config.readfp(open("mysql.conf"))
    return config.get(section, item)

def get_db_cursor(host, port, username, password, db):
    conn = MySQLdb.connect(host = host, port = port, user = username, passwd = password, db = db)
    conn.autocommit(True)
    cursor = conn.cursor()
    return conn.cursor()

def get_table_and_rows(cursor):
    table_list = []
    cursor.execute("SHOW TABLES")
    rowset = cursor.fetchall();
    for row in rowset:
        table_name = row[0]
        cursor.execute("SELECT COUNT(*) FROM %s" % table_name)
        count_rowset = cursor.fetchone()
        count = count_rowset[0]
        table_list.append("%s:%s\r\n" % (table_name, count))

    return table_list

if __name__ == "__main__":
    source_cursor = get_db_cursor(get_config_item("source", "host"), int(get_config_item("source", "port")), get_config_item("source", "username"), get_config_item("source", "password"), get_config_item("source", "db"))
    source_table_list = get_table_and_rows(source_cursor)
    dest_cursor = get_db_cursor(get_config_item("dest", "host"), int(get_config_item("dest", "port")), get_config_item("dest", "username"), get_config_item("dest", "password"), get_config_item("dest", "db"))
    dest_table_list = get_table_and_rows(dest_cursor)
    result = cmp(source_table_list, dest_table_list)
    if result == 0:
        print "%s" % "match fully!"
    else:
        with open("source.tables", "w") as sf:
            sf.writelines(source_table_list)
        with open("dest.tables", "w") as df:
            df.writelines(dest_table_list)
        print "these db not match fully! please check log" 



