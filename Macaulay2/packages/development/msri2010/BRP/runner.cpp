#include "brp.h"
#include <set>
#include <math.h>

class Pair {
  friend bool operator< (const Pair &pair1, const Pair &pair2) {
    if(pair1.j < pair2.j) {
      return true;
    } else if(pair1.j == pair2.j) {
      return pair1.i < pair2.i;
    } else {
      return false;
    }
  }

  public:
  int i;
  int j;

  Pair(int a, int b) {
    if(a < b) {
      i = a;
      j = b;
    } else if(b < a) {
      i = b;
      j = a;
    } else {
      throw "Invalid numbers in Pair.";
    }
  }
}; 

class FunctionPair {
  public: 
  BRP f;
  BRP g;
  bool good;

//  FunctionPair(BRP a, BRP b) {
//    f = a;
//    g = b;
//    good = true;
//  }

  // i < j
  FunctionPair(const Pair &pair, const map<int,BRP> &F, int n )  {
    int i = pair.i;
    int j = pair.j;

    if(F.find(j) == F.end() || (i >= 0 && F.find(i) == F.end())) {
      good = false;
    } else { 
      good = true;
      if(i < 0) { // working with field polynomial, generate x_(-i)
        g = BRP(pow(2,( n - (-i) )));
      } else {
        g = F.find(i) ->second;
      }
      f = F.find(j) ->second;
    }
  }
};

/*
    F = map of functions
    n = number of variables in the ring
*/
set<Pair> makeList(const map<int,BRP> &F, int n) {
  set<Pair> B;
  set<Pair>::iterator position = B.begin();
  for(map<int,BRP>::const_iterator iter = F.begin(); iter != F.end(); ++iter) {
    int j = iter->first;
    for(int i=-n; i<0; i++) {
      Pair pair = Pair(i, j);
      position = B.insert(position, pair);
    }
    for(int i=0; i<j; i++) {
      Pair pair = Pair(i, j);
      position = B.insert(position, pair);
    }
  }
  return B;
}

set<Pair> makeNewPairs(int newIndex, const map<int,BRP> &F, int n) {
  set<Pair> B;
  set<Pair>::iterator position = B.begin();
  for(int i=-n; i<0; i++) {
    Pair pair = Pair(i, newIndex);
    position = B.insert(position, pair);
  }
  for(map<int,BRP>::const_iterator iter = F.begin(); iter != F.end(); ++iter) {
    int j = iter->first;
    Pair pair = Pair(newIndex, j);
    position = B.insert(position, pair);
  }
  return B;
}

bool inList(int i, int j, const set<Pair> &B) {
  Pair p = Pair(i,j);
  return B.find(p) != B.end();
}

bool isGoodPair(const Pair &pair, const map<int,BRP> &F, const set<Pair> &B, int n) {
  FunctionPair fp = FunctionPair(pair, F, n);
  if (!fp.good) {
    return false;
  }
  
  int i = pair.i;
  int j = pair.j;

  int g = fp.g.LT();
  int f = fp.f.LT();
  if( BRP::isRelativelyPrime(g,f) ) {
    return false;
  }

  int lcm = g | f;
  for(map<int, BRP>::const_iterator it = F.begin(); it != F.end(); ++it) {
    int k = it->first;
    BRP K = it->second;

    if(( k != i && k != j && BRP::isDivisibleBy(lcm, K.LT() ) && !inList(i,k,B) && !inList(j,k,B))) {
      return false;
    }
  }
  
  return true;
}


BRP sPolynomial(const Pair &pair, const map<int,BRP> &F, int n) {
  FunctionPair fp = FunctionPair(pair, F, n);
  if (!fp.good) {
    return BRP();
  }

  if (pair.i < 0 ) { 
    // g = ax + b
    BRP a = (fp.f).remainder(fp.g);
    return a * fp.g + a;
  } 
  int f = fp.f.LT();
  int g = fp.g.LT();
  int lcm = f | g;
  return fp.f*(lcm ^ f ) + fp.g*( lcm ^ g );
}

// Reduce the leading term of a polynomial one step using the leading term of
// another a polynomial
// only call this when isLeadingReducibleBy(f,g)
BRP reduceLTOnce(const BRP &f, const BRP &g) {
  int a = f.LT() ^ g.LT();
  return g * a + f ;
}

// Reduce the leading term of f one step with the first polynomial g_i in the
// intermediate basis that satisfies isLeadingReducibleBy(f,g_i)
BRP reduceLTOnce(const BRP &f, const map<int,BRP> &F) {
  for(map<int, BRP>::const_iterator it = F.begin(); it != F.end(); ++it) {
    BRP g = it->second;
    if (f.isLeadingReducibleBy(g.LT())) {
      return reduceLTOnce(f, g);
    }
  }
  return f;
}

// reduce all term of f with leading term of g
BRP reduceLowerTerms(const BRP &f, const BRP &g) {
  BRP tmp = f;
  int a = g.LT();
  list<int>::iterator it  = tmp.mylist.begin();
  while (it != tmp.mylist.end() ) {
    int m = *it;
    if ( BRP::isDivisibleBy(m,a) ) {
      tmp = tmp + g * ( m ^ a );
      break; 
    }
    ++it;
  }
  return tmp;
}

// reduce all terms of f with leading terms of all polynomials in F
// if f is in F, then f is reduced to 0
BRP reduceLowerTerms(BRP f, const map<int,BRP> &F) {
  for(map<int, BRP>::const_iterator it = F.begin(); it != F.end() && f != 0; ++it) {
    BRP g = it->second;
    f = reduceLowerTerms(f,g);
    // don't start over with the loop, because the everytime we check all
    // terms of f, so if no term of f was reducible by g, then so is no term
    // of the new f
  }
  return f;
}

// reduce all terms in f by the leading terms of all polynomials in F
// first reduce the leading term completely, then the lower terms
BRP reduce(BRP f, const map<int,BRP> &F) {
  while (f!=0) {
    BRP g = reduceLTOnce(f, F); // always start over at the beginning of F,
    // the leading term of the new f might be reducible
    if ( f == g || g == 0 ) {
      f = g;
      break; // fully reduced leading term
    }
    f = g;
  }
  if ( f != 0 ) {
    f = reduceLowerTerms(f, F); 
  }
  return f;
}

// make a reduced Groebner basis
void reduce(map<int,BRP> &F) {
  bool changesHappened = true;
  while (changesHappened) {
    changesHappened = false;
    //for(map<int, BRP>::iterator it1 = F.begin(); it1 != F.end(); it1++) {
    map<int, BRP>::iterator it1 = F.begin(); 
    bool iteratorIncreased = false;
    while (it1 != F.end() ) {
      BRP f = it1->second;
      iteratorIncreased = false;
      for(map<int, BRP>::iterator it2 = F.begin(); it2 != F.end(); ++it2) {
        BRP g = it2->second;
        if ( it1 != it2) {
          BRP tmp = reduceLowerTerms(f,g);
          if (tmp != f) {
            if (tmp != 0 ) {
              it1->second = tmp;
              ++it1;
            }
            else {
              F.erase(it1++);
            }
            iteratorIncreased = true;
            changesHappened = true;
            break; // use the next f and compare it to all others
          }
        }
      } 
      if ( (!iteratorIncreased) && it1 != F.end() ) { 
        ++it1;
      }
    }
  }
}

// complete algorithm to compute a Groebner basis F  
void gb( map<int,BRP> &F, int n) {
  reduce(F);
  int nextIndex = F.size(); 
  set<Pair> B = makeList(F, n);
  while (!B.empty()) {
    Pair pair = *(B.begin());
    B.erase(B.begin());
    if (isGoodPair(pair,F,B,n)) {
      BRP S = sPolynomial(pair,F,n);
      S = reduce(S,F);
      if (S != 0 ) {
        set<Pair> newList = makeNewPairs(nextIndex, F, n);
        F[nextIndex] = S;
        nextIndex++;
        B.insert(newList.begin(), newList.end());
        reduce(F);
      }
    }
  }
}

void testSPolynomial() {
  map<int,BRP> G;
  G[0] = BRP(992);
  G[1] = BRP(384) + BRP(256) + BRP(128) + BRP(96) + BRP(64);
  G[2] = BRP(16) + BRP(5) + BRP(2);
  int n = 10;

  Pair p = Pair(-6,2);
  BRP S = sPolynomial(p,G,n);
  BRP correctS = BRP(21) + BRP(18) + BRP(5) + BRP(2);
  if ( S != correctS ) { 
    cout << "error when computing S polynomial" << endl;
    cout << S << endl;
  }
  p = Pair(2,1);
  S = sPolynomial(p,G,n);
  correctS = BRP(389) + BRP(386) + BRP(272) + BRP(144) + BRP(112) + BRP(80);
  if ( S != correctS ) { 
    cout << "error when computing S polynomial" << endl;
    cout << S << endl;
  }
}  


void testShortBasis() {
  map<int,BRP> G;
  G[0] = BRP(992);
  G[1] = BRP(384) + BRP(256) + BRP(128) + BRP(96) + BRP(64);
  G[2] = BRP(16) + BRP(5) + BRP(2);
  int n = 10;

  gb(G,n);
  map<int,BRP> correctG;
  correctG[0] = BRP(384) + BRP(256) + BRP(128) + BRP(96) + BRP(64);
  correctG[1] = BRP( 16) + BRP(5) + BRP(2);
  correctG[2] = BRP(192) + BRP(128);
  correctG[3] = BRP(320) + BRP(256);
  correctG[4] = BRP(160);
  correctG[5] = BRP(288);
  map<int,BRP>::iterator it2 = correctG.begin();
  for(map<int,BRP>::iterator it = G.begin(); it != G.end(); ++it) {
    BRP f = it->second;
    BRP correctf = (it2++)->second;
    if( f != correctf ) {
      cout << "error wrong basis" << f << endl;
    }
  }
}

void testLongBasis() {
  map<int,BRP> G;
  G[0] = BRP(1015808);
  G[1] = BRP(393216) + BRP(262144) + BRP(131072) + BRP(98304) + BRP(65536) ;
  G[2] = BRP(16384) + BRP(5120) + BRP(2048) ;
  G[3] = BRP(16384) + BRP(8192);
  G[4] = BRP(524288) + BRP(65536) ;
  G[5] = BRP(196608) + BRP(2048) + BRP(1024) ;
  G[6] = BRP(4) + BRP(2) + BRP(1);
  G[7] = BRP(192) + BRP(48);
  G[8] = BRP(524288) + BRP(1);
  G[9] = BRP(262146) + BRP(2048) + BRP(208) + BRP(8);
  G[10] = BRP(262146) + BRP(4096) + BRP(16) + BRP(8);
  G[11] = BRP(262146) + BRP(2048) + BRP(200);
  G[12] = BRP(262146) + BRP(2048) + BRP(1027) + BRP(200) + BRP(2);
  G[13] = BRP(262656) + BRP(2) + BRP(1);
  G[14] = BRP(262656) + BRP(3072) + BRP(384) + BRP(64) + BRP(12);
  G[15] = BRP(786432) + BRP(2048) + BRP(256) + BRP(136);
  G[16] = BRP(262656) + BRP(65728) + BRP(2048);
  G[17] = BRP(262144) + BRP(67584) + BRP(448) + BRP(8);
  G[18] = BRP(524800) + BRP(147776);
  G[19] = BRP(131072) + BRP(2048) + BRP(448) + BRP(12) + BRP(8);
  int n = 20;

    
  map<int,BRP>c;
  c[0] = BRP(1);
  c[1] = BRP(2);
  c[2] = BRP(4);
  c[3] = BRP(8);
  c[4] = BRP(48);
  c[5] = BRP(64);
  c[6] = BRP(256);
  c[7] = BRP(1024);
  c[8] = BRP(2048);
  c[9] = BRP(4096) + BRP(16);
  c[10] = BRP(8192);
  c[11] = BRP(16384);
  c[12] = BRP(65536);
  c[13] = BRP(131072);
  c[14] = BRP(262144);
  c[15] = BRP(524288);
  
  gb(G,n);
  for (int i = 0; i < 16; i++ ) {
    bool found = false;
    for (map<int,BRP>::iterator it = G.begin(); it != G.end(); ++it) {
      if (it->second == c[i] ) { 
        found = true;
        G.erase(it);
        break;
      }
    }
    if (!found) {
      cout << "error in basis," << c[i] << " not in it" << endl;
    }
  }
  if (!G.empty()) {
    cout << "error in basis, too many elements" << endl;
  }
}

void clearAll(map<int,BRP> F) {
  F.clear();
}

void testInList() {
  map<int,BRP> F;

  F[0] = BRP(7);
  F[1] = BRP(8);
  F[2] = BRP(2);
//  F.clear();
  set<Pair> B = makeList(F, 4);
  if ( ! inList(1,2,B) || ! inList(2,1,B) ||  ! inList(-4,1,B) || inList(5,7,B) ) { 
    cout << "error in inList" << endl;
  }
}

int main() {
  testSPolynomial();
  testInList();
  testShortBasis(); 
  testLongBasis(); 
  cout << "done testing" << endl;

}
