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

#include "./FileIndexReader.h"

#include <string>

#include <sys/types.h>  // for stat()
#include <sys/stat.h>   // for stat()
#include <unistd.h>     // for stat()

extern "C" {
  #include "libhw1/CSE333.h"
}
#include "./Utils.h"  // for class CRC32.

using std::string;

namespace hw3 {

FileIndexReader::FileIndexReader(const string &file_name,
                                 bool validate) {
  // Stash a copy of the index file's name.
  file_name_ = file_name;

  // Open a (FILE*) associated with filename.  Crash on error.
  file_ = fopen(file_name_.c_str(), "rb");
  Verify333(file_ != nullptr);

  // STEP 1.
  // Make the (FILE*) be unbuffered by the C standard library; see
  // "man setbuf" for more info.  Note that there may still be buffers
  // implemented by the POSIX libraries, the operating system, or even
  // in the hardware itself.


  // STEP 2.
  // Read the entire file header and convert to host format.


  // STEP 3.
  // Verify that the magic number is correct.  Crash if not.


  // Make sure the index file's length lines up with the header fields.
  struct stat f_stat;
  Verify333(stat(file_name_.c_str(), &f_stat) == 0);
  Verify333(
    f_stat.st_size == static_cast<unsigned>(
      sizeof(IndexFileHeader) + header_.doctable_bytes + header_.index_bytes));

  if (validate) {
    // Re-calculate the checksum, make sure it matches that in the header.
    // Use fread() and pass the bytes you read into the crcobj.
    // Note you don't need to do any host/network order conversion,
    // since we're doing this byte-by-byte.
    CRC32 crc_obj;
    static constexpr int kBufSize = 512;
    uint8_t buf[kBufSize];
    int left_to_read = header_.doctable_bytes + header_.index_bytes;
    while (left_to_read > 0) {
      // STEP 4.
      // You should only need to modify code inside the while loop for
      // this step. Remember that file_ is now unbuffered, so care needs
      // to be put into how the file is sequentially read
    }
    Verify333(crc_obj.GetFinalCRC() == header_.checksum);
  }

  // Everything looks good; we're done!
}

FileIndexReader::~FileIndexReader() {
  // Close the (FILE*).
  Verify333(fclose(file_) == 0);
}

DocTableReader* FileIndexReader::NewDocTableReader() const {
  // The docid->name mapping starts at offset sizeof(IndexFileHeader) in
  // the index file.  Be sure to dup the (FILE*) rather than sharing
  // it across objects, just so that we don't end up with the possibility
  // of threads contending for the (FILE*) and associated with race
  // conditions.
  FILE *fdup = FileDup(file_);
  IndexFileOffset_t file_offset = sizeof(IndexFileHeader);
  return new DocTableReader(fdup, file_offset);
}

IndexTableReader* FileIndexReader::NewIndexTableReader() const {
  // The index (word-->docid table) mapping starts at offset
  // (sizeof(IndexFileHeader) + doctable_size_) in the index file.  Be
  // sure to dup the (FILE*) rather than sharing it across objects,
  // just so that we don't end up with the possibility of threads
  // contending for the (FILE*) and associated race conditions.
  return new IndexTableReader(FileDup(file_),
                              sizeof(IndexFileHeader) + header_.doctable_bytes);
}

}  // namespace hw3
