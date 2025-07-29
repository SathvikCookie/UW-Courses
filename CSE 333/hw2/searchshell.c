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

// Feature test macro for strtok_r (c.f., Linux Programming Interface p. 63)
#define _XOPEN_SOURCE 600

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <ctype.h>

#include "libhw1/CSE333.h"
#include "./CrawlFileTree.h"
#include "./DocTable.h"
#include "./MemIndex.h"

//////////////////////////////////////////////////////////////////////////////
// Helper function declarations, constants, etc
static void Usage(void);
static void ProcessQueries(DocTable *dt, MemIndex *mi);
static int GetNextLine(FILE *f, char **ret_str);
static void FreeResults(DocTable **doctable, MemIndex **index);


//////////////////////////////////////////////////////////////////////////////
// Main
int main(int argc, char **argv) {
  if (argc != 2) {
    Usage();
  }

  // Implement searchshell!  We're giving you very few hints
  // on how to do it, so you'll need to figure out an appropriate
  // decomposition into functions as well as implementing the
  // functions.  There are several major tasks you need to build:
  //
  //  - Crawl from a directory provided by argv[1] to produce and index
  //  - Prompt the user for a query and read the query from stdin, in a loop
  //  - Split a query into words (check out strtok_r)
  //  - Process a query against the index and print out the results
  //
  // When searchshell detects end-of-file on stdin (cntrl-D from the
  // keyboard), searchshell should free all dynamically allocated
  // memory and any other allocated resources and then exit.
  //
  // Note that you should make sure the fomatting of your
  // searchshell output exactly matches our solution binaries
  // to get full points on this part.
  // Create DocTable and MemIndex to store our inverted index
  DocTable *dt = NULL;
  MemIndex *mi = NULL;

  printf("Indexing '%s'\n", argv[1]);
  bool success = CrawlFileTree(argv[1], &dt, &mi);

  if (!success) {
    fprintf(stderr, "Failed to crawl directory '%s'\n", argv[1]);
    return EXIT_FAILURE;
  }

  ProcessQueries(dt, mi);

  printf("shutting down...\n");

  FreeResults(&dt, &mi);

  return EXIT_SUCCESS;
}


//////////////////////////////////////////////////////////////////////////////
// Helper function definitions

static void Usage(void) {
  fprintf(stderr, "Usage: ./searchshell <docroot>\n");
  fprintf(stderr,
          "where <docroot> is an absolute or relative " \
          "path to a directory to build an index under.\n");
  exit(EXIT_FAILURE);
}

static void FreeResults(DocTable **doctable, MemIndex **index) {
  if (doctable != NULL && *doctable != NULL) {
    DocTable_Free(*doctable);
    *doctable = NULL;
  }
  if (index != NULL && *index != NULL) {
    MemIndex_Free(*index);
    *index = NULL;
  }
}

static void ProcessQueries(DocTable *dt, MemIndex *mi) {
  char *query_string = NULL;

  // Process queries until EOF
  while (1) {
    // Prompt user for query
    printf("enter query:\n");

    // Read query from stdin
    int query_len = GetNextLine(stdin, &query_string);
    if (query_len <= 0) {
      if (query_string != NULL) {
        free(query_string);
      }
      break;
    }

    char *query_copy = strdup(query_string);
    Verify333(query_copy != NULL);

    char *saveptr;
    char *word;
    char **query_words = NULL;
    int num_words = 0;

    // Split the query into words
    word = strtok_r(query_copy, " \t\n", &saveptr);
    while (word != NULL) {
      if (strlen(word) > 0) {
        char *lowercase_word = strdup(word);
        for (int i = 0; lowercase_word[i]; i++) {
          lowercase_word[i] = tolower(lowercase_word[i]);
        }

        query_words = (char **)realloc(query_words,
            (num_words + 1) * sizeof(char *));
        Verify333(query_words != NULL);
        query_words[num_words] = lowercase_word;
        num_words++;
      }
      word = strtok_r(NULL, " \t\n", &saveptr);
    }

    free(query_copy);

    // If no valid words in query, skip and continue
    if (num_words == 0) {
      free(query_string);
      continue;
    }

    LinkedList *results = MemIndex_Search(mi, query_words, num_words);

    // Print the results
    if (results == NULL || LinkedList_NumElements(results) == 0) {
      // Don't print anything for queries with no results
    } else {
      LLIterator *it = LLIterator_Allocate(results);
      int rank = 1;

      while (LLIterator_IsValid(it)) {
        SearchResult *sr;
        LLPayload_t payload;

        LLIterator_Get(it, &payload);
        sr = (SearchResult *)payload;

        char *doc_name = DocTable_GetDocName(dt, sr->doc_id);

        printf("  %s (%u)\n", doc_name, sr->rank);

        LLIterator_Next(it);
        rank++;
      }

      LLIterator_Free(it);

      LinkedList_Free(results, free);
    }

    for (int i = 0; i < num_words; i++) {
      free(query_words[i]);
    }
    free(query_words);

    free(query_string);
  }
}

static int GetNextLine(FILE *f, char **ret_str) {
  if (f == NULL || ret_str == NULL)
    return -1;

  int buffer_size = 128;
  int offset = 0;
  *ret_str = (char *)malloc(buffer_size);

  if (*ret_str == NULL)
    return -1;

  while (1) {
    // Check if we've hit EOF
    if (fgets(*ret_str + offset, buffer_size - offset, f) == NULL) {
      if (offset == 0) {
        // No input and EOF reached
        free(*ret_str);
        *ret_str = NULL;
        return -1;
      }

      break;
    }

    // Find the newline if any
    char *newline = strchr(*ret_str + offset, '\n');
    if (newline != NULL) {
      // Replace newline with null terminator
      *newline = '\0';
      break;
    }

    // No newline found, so we need to read more
    offset = strlen(*ret_str);
    if (offset + 1 >= buffer_size) {
      buffer_size *= 2;
      char *new_str = (char *)realloc(*ret_str, buffer_size);
      if (new_str == NULL) {
        free(*ret_str);
        *ret_str = NULL;
        return -1;
      }
      *ret_str = new_str;
    }
  }

  return strlen(*ret_str);
}
