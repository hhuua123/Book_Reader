//
//  HYDatabaseMacros.h
//  Book_Reader
//
//  Created by hhuua on 2018/6/25.
//  Copyright © 2018年 hhuua. All rights reserved.
//

#ifndef HYDatabaseMacros_h
#define HYDatabaseMacros_h

#define kHYDatabaseName @"HYDatabase.sqlite"
#define kHYDatabasePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:kHYDatabaseName]


/*-----------------------------------------  t_chapter_text  ----------------------------------------------------*/
#define kHYDBCreateChapterTextTable @"CREATE TABLE IF NOT EXISTS t_chapter_text (\
id INTEGER PRIMARY KEY AUTOINCREMENT,\
chapter_url TEXT NOT NULL,\
book_id TEXT NOT NULL,\
chapter_text TEXT NOT NULL,\
time DATETIME NOT NULL)"

#define kHYDBInsertChapterText(...) @"INSERT INTO t_chapter_text (chapter_url, chapter_text, time, book_id) VALUES (?, ?, ?, ?)",##__VA_ARGS__

#define kHYDBSelectChapterTextWithUrl(url) @"SELECT * FROM t_chapter_text WHERE chapter_url=? LIMIT 1",url

#define kHYDBDeleteChapterTextWithId(chapterId) @"DELETE FROM t_chapter_text WHERE id=?",chapterId

#define kHYDBDeleteChapterTextWithUrl(chapter_url) @"DELETE FROM t_chapter_text WHERE chapter_url=?",chapter_url

#define kHYDBDeleteChapterTextWithBookId(book_id) @"DELETE FROM t_chapter_text WHERE book_id=?",book_id


/*-----------------------------------------  t_chapter  ----------------------------------------------------*/
#define kHYDBCreateChapterTable @"CREATE TABLE IF NOT EXISTS t_chapter (\
id INTEGER PRIMARY KEY AUTOINCREMENT,\
chapter_name TEXT NOT NULL,\
chapter_url TEXT NOT NULL UNIQUE,\
book_id TEXT NOT NULL,\
chapter_id TEXT NOT NULL,\
source_url TEXT NOT NULL,\
time DATETIME NOT NULL\
)"

#define kHYDBInsertChapter(chapter_name, chapter_url, book_id, chapter_id, source_url, time) @"INSERT OR REPLACE INTO t_chapter (chapter_name, chapter_url, book_id, chapter_id, source_url, time)\
VALUES (?, ?, ?, ?, ?, ?)",chapter_name, chapter_url, book_id, chapter_id, source_url, time

#define kHYDBSelectChaptersWithSource_url(source_url) @"SELECT * FROM t_chapter WHERE source_url=?",source_url

#define kHYDBDeleteChapterWithSource_url(source_url) @"DELETE FROM t_chapter WHERE source_url=?",source_url

#define kHYDBSelectAllChapters @"SELECT * FROM t_chapter"


/*-----------------------------------------  t_record  ----------------------------------------------------*/
#define kHYDBCreateRecordTable @"CREATE TABLE IF NOT EXISTS t_record(\
id INTEGER PRIMARY KEY AUTOINCREMENT,\
book_id TEXT NOT NULL UNIQUE,\
chapter_index INTEGER,\
chapter_name TEXT,\
record_text TEXT NOT NULL,\
record_time DATETIME NOT NULL\
)"

#define kHYDBInsertRecord(book_id, chapter_index, record_text, record_time, chapter_name) @"INSERT OR REPLACE INTO t_record (book_id, record_text, chapter_index, record_time, chapter_name) VALUES (?, ?, ?, ?, ?)",book_id, record_text, chapter_index, record_time, chapter_name

#define kHYDBSelectRecordWithBook_id(book_id) @"SELECT * FROM t_record WHERE book_id=? order by id LIMIT 1",book_id

#define kHYDBDeleteRecordWithBook_id(book_id) @"DELETE FROM t_record WHERE book_id=?",book_id


/*-----------------------------------------  t_search_history  ----------------------------------------------------*/
#define kHYDBCreateSearchHistoryTabel @"CREATE TABLE IF NOT EXISTS t_search_history(\
id INTEGER PRIMARY KEY AUTOINCREMENT,\
book_name TEXT NOT NULL UNIQUE,\
time DATETIME NOT NULL\
)"

#define kHYDBInsertSearchHistory(book_name, time) @"INSERT OR REPLACE INTO t_search_history (book_name, time) VALUES (?, ?)",book_name, time

#define kHYDBSelectSearchHistory @"SELECT * FROM t_search_history order by time desc"

#define kHYDBDeleteSearchHistoryWithName(book_name) @"DELETE FROM t_search_history WHERE book_name=?",book_name

#define kHYDBDeleteAllHistory @"DELETE FROM t_search_history WHERE book_name IS NOT NULL"


/*-----------------------------------------  t_book_info  ----------------------------------------------------*/
#define kHYDBCreateBookInfoTabel @"CREATE TABLE IF NOT EXISTS t_book_info(\
id INTEGER PRIMARY KEY AUTOINCREMENT,\
book_name TEXT NOT NULL,\
author TEXT NOT NULL,\
related_id TEXT NOT NULL UNIQUE,\
update_time TEXT NOT NULL,\
book_desc TEXT NOT NULL,\
book_image TEXT,\
book_url TEXT NOT NULL,\
source_name TEXT NOT NULL,\
book_state TEXT NOT NULL,\
book_sort TEXT NOT NULL,\
book_last_chapter TEXT NOT NULL,\
book_word_count INTEGER,\
collection_num INTEGER,\
time DATETIME NOT NULL\
)"

#define kHYDBInsertBookInfo(book_name, author, related_id, update_time, book_desc, book_image, book_url, source_name, book_state, book_sort, book_last_chapter, book_word_count, collection_num, time, user_select_time) @"INSERT OR REPLACE INTO t_book_info (book_name, author, related_id, update_time, book_desc, book_image, book_url, source_name, book_state, book_sort, book_last_chapter, book_word_count, collection_num, time, user_select_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",book_name, author, related_id, update_time, book_desc, book_image, book_url, source_name, book_state, book_sort, book_last_chapter, book_word_count, collection_num, time, user_select_time

#define kHYDBSelectBookInfo @"SELECT * FROM t_book_info order by time desc"

#define kHYDBSelectBookInfoWithRelatedId(related_id) @"SELECT * FROM t_book_info WHERE related_id=?",related_id

#define kHYDBDeleteBookInfo(related_id) @"DELETE FROM t_book_info WHERE related_id=?",related_id

#define kHYDBUpdateBookUserTime(user_select_time, related_id) @"UPDATE t_book_info set user_select_time=? WHERE related_id=?",user_select_time, related_id

#define kHYDBUpdateBookSource(related_id, source_name, book_url) @"UPDATE t_book_info set source_name=?,book_url=? WHERE related_id=?",source_name, book_url, related_id


/*-----------------------------------------  record_book  ----------------------------------------------------*/
#define kHYDBSelectBookInfosAndRecord @"SELECT * FROM t_book_info B LEFT OUTER JOIN t_record R ON related_id = R.book_id order by user_select_time desc"


#endif /* HYDatabaseMacros_h */
