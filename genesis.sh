# Alpha tokenization
tr -cs "[:alpha:]" "\n" < genesis.txt > genesis.words.txt

# Strip blank lines
gsed -i '/^$/N;s/\n//' genesis.words.txt

# Case-insensitve count
sort -f genesis.words.txt | uniq -ci | sort -nr > genesis.counts.txt

# Sort by "rhyming" order
rev genesis.words.txt | sort | rev > genesis.rhymes.txt

# Bigrams
tail -n +2 genesis.words.txt | paste genesis.words.txt - > genesis.bigrams.txt

# Trigrams
function words_plus_n() { tail -n +$1 genesis.words.txt; }
paste genesis.words.txt <(words_plus_n 2) <(words_plus_n 3) > genesis.trigrams.txt

# Top bigrams
sort -f genesis.bigrams.txt | uniq -ci | sort -nr | head -n 20

# Top trigrams
sort -f genesis.trigrams.txt | uniq -ci | sort -nr | head -n 20
