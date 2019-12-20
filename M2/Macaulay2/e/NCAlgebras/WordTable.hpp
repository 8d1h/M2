#ifndef _word_table_hpp_
#define _word_table_hpp_

#include <vector>
#include <ostream>
#include <memory>

#include "FreeMonoid.hpp"
#include "../Polynomial.hpp"

class FreeAlgebra;

class Word
{
public:
  friend std::ostream& operator<<(std::ostream& o, const Word& w);

  // warning: the pointers begin, end, should not go out of scope while this Word is in use.
  Word() : mBegin(nullptr), mEnd(nullptr) {}

  Word(const int* begin, const int* end) : mBegin(begin), mEnd(end) {}

  // keyword 'explicit' to prevent calling this constructor implicitly.  It
  // causes some strange behavior in debugging.
  // to be honest, we should only be using this in the unit-tests file ONLY
  explicit Word(const std::vector<int>& val) : mBegin(val.data()), mEnd(val.data() + val.size()) {}

  void init(const int* begin, const int* end) { mBegin = begin; mEnd = end; }
  // this constructor is a bit dangerous since we have several std::vector<int> types running around
  //void init(const std::vector<int>& val) { mBegin = val.data(); mEnd = val.data() + val.size(); }
                                 
  const int* begin() const { return mBegin; }
  const int* end() const { return mEnd; }

  size_t size() const { return mEnd - mBegin; }

  bool operator==(Word rhs)
  {
    if (size() != rhs.size()) return false;
    for (auto i=0; i<size(); ++i)
      if (mBegin[i] != rhs.mBegin[i])
        return false;
    return true;
  }

private:
  const int* mBegin;
  const int* mEnd;
};

using Overlap = std::tuple<int,int,int>;

class WordTable
{
  // abstract table class.
public:
  friend std::ostream& operator<<(std::ostream& o, const WordTable& wordTable);

  WordTable() {}

  ~WordTable() {}

  void clear() { mMonomials.clear(); }

  size_t monomialCount() const { return mMonomials.size(); }

  size_t insert(Word w);

  size_t insert(Word w, std::vector<Overlap>& newRightOverlaps);

  // access routine
  const Word& operator[](int index) const { return mMonomials[index]; }

  // lookup routines
  
  // return all pairs (i,j), where
  //   the i-th word in the table is w (say)
  //   j is a position in word
  //   such that w appears in word starting at position j.
  void subwords(Word word,
                std::vector<std::pair<int,int>>& output) const;

  // sets 'output' to the first pair (i,j), where
  //   the i-th word in the table is w (say)
  //   j is a position in word
  //   such that w appears in word starting at position j.
  // if such a match is found, output is set, and true is returned.
  // if not, false is returned.
  bool subword(Word word,
                std::pair<int,int>& output) const;

  // returns true if some element in the table is a prefix/suffix of 'word'.
  // In this case, 'output' is set to the index of the corresponding element.
  bool isPrefix(Word word, int& output) const;
  bool isSuffix(Word word, int& output) const;
  
  auto isNontrivialSuperword(Word word, int index1, int index2) const -> bool;
  
  // return all pairs (i,j), where
  //   the i-th word in the table is w (say)
  //   j is a position in w
  //   such that word appears in w starting at position j.
  void superwords(Word word,
                  std::vector<std::pair<int,int>>& output) const;
  
  // given 'word', find all left over laps with elements of the table.
  // A left overlap of 'alpha' and 'beta' is:
  //  a prefix of alpha is a suffix of beta.
  // i.e. alpha = a.b
  //      beta  = c.a (a,b,c are words)
  // returned Overlap for this overlap:
  void leftOverlaps(std::vector<Overlap>& newLeftOverlaps) const;

  // find (right) overlaps with most recent added word 'w'.
  void rightOverlaps(std::vector<Overlap>& newRightOverlaps) const; 

private:
  // returns true if word1 is a prefix/suffix of word2
  static bool isPrefixOf(Word word1, Word word2);
  static bool isSuffixOf(Word word1, Word word2);
  
  static void subwordPositions(Word word1,
                               Word word2,
                               std::vector<int>& result_start_indices);

  static bool subwordPosition(Word word1,
                               Word word2,
                               int& result_start_index);
  
  // overlaps here: suffix of word1 == prefix of word2.
  // overlap value is the start of prefix of word2 in word1.
  static void overlaps(Word word1,
                       Word word2,
                       std::vector<int>& result_overlaps);

private:
  std::vector<Word> mMonomials;
};

std::ostream& operator<<(std::ostream& o, const Word& w);
std::ostream& operator<<(std::ostream& o, const WordTable& wordTable);

std::unique_ptr<WordTable> constructWordTable(const FreeAlgebra& A, const ConstPolyList& gb);

#endif

// Local Variables:
// compile-command: "make -C $M2BUILDDIR/Macaulay2/e "
// indent-tabs-mode: nil
// End:

