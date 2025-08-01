/*
 * Copyright ©2025 Hal Perkins.  All rights reserved.  Permission is
 * hereby granted to students registered for University of Washington
 * CSE 333 for use solely during Spring Quarter 2025 for purposes of
 * the course.  No other use, copying, distribution, or modification
 * is permitted without prior written consent. Copyrights for
 * third-party components of this work must be honored.  Instructors
 * interested in reusing these course materials should contact the
 * author.
 */

#include <stdint.h>
#include <string.h>

extern "C" {
  #include "./DocTable.h"
}

#include "gtest/gtest.h"
#include "./test_suite.h"

namespace hw2 {

TEST(Test_DocTable, Simple) {
  HW2Environment::OpenTestCase();
  DocTable* t1;
  const char* file1 = "foo/bar/baz.txt";
  const char* file2 = "bar/baz.txt";
  char* f_res;
  DocID_t d1, d2, d_res;
  HashTable* ht;
  HTKeyValue_t kv;

  t1 = DocTable_Allocate();
  ASSERT_TRUE(t1 != NULL);
  ASSERT_EQ(0, DocTable_NumDocs(t1));
  HW2Environment::AddPoints(5);

  // Add two documents.
  d1 = DocTable_Add(t1, const_cast<char*>(file1));
  ASSERT_NE(0U, d1);
  ASSERT_EQ(1, DocTable_NumDocs(t1));
  ASSERT_LE((uint64_t)DocTable_NumDocs(t1), d1);

  d2 = DocTable_Add(t1, const_cast<char*>(file2));
  ASSERT_NE(0U, d2);
  ASSERT_EQ(2, DocTable_NumDocs(t1));
  ASSERT_LE((uint64_t) DocTable_NumDocs(t1), d2);
  HW2Environment::AddPoints(5);

  // Add the same two documents, and verify that the DocTable notices the
  // duplication.
  d_res = DocTable_Add(t1, const_cast<char*>(file2));
  ASSERT_EQ(d2, d_res);
  d_res = DocTable_Add(t1, const_cast<char*>(file1));
  ASSERT_EQ(d1, d_res);
  ASSERT_EQ(2, DocTable_NumDocs(t1));
  HW2Environment::AddPoints(5);

  // Lookup by docID and docName: verify we can get back a document we
  // previously added, and that we do not get back a document that we'd
  // never added.
  d_res = DocTable_GetDocID(t1, const_cast<char*>(file1));
  ASSERT_EQ(d1, d_res);
  d_res = DocTable_GetDocID(t1, const_cast<char*>("nonexistent/file"));
  ASSERT_EQ(0U, d_res);

  f_res = DocTable_GetDocName(t1, d1);
  ASSERT_STREQ(f_res, file1);
  f_res = DocTable_GetDocName(t1, static_cast<uint64_t>(0xDEADBEEF));
  ASSERT_EQ(static_cast<char*>(NULL), f_res);

  HW2Environment::AddPoints(5);

  // Verify the table stores value DocID_t*, not DocID_t
  // For this small test (2 files), all docids will be less
  // than any possible heap address
  ht = DT_GetNameToIDTable(t1);
  HashTable_Find(ht, FNVHash64(
                  reinterpret_cast<unsigned char*>(const_cast<char*>(file1)),
                  strlen(file1)), &kv);

  ASSERT_LE((uint64_t) DocTable_NumDocs(t1), (uint64_t) kv.value);

  // Verify we don't crash when we deallocate.
  DocTable_Free(t1);
  HW2Environment::AddPoints(10);
}

}  // namespace hw2
