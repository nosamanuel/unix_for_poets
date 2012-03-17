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

# Count "-ing" words
grep -e "ing$" genesis.words.txt | wc -l

# Count uppercase words
grep -E "^[A-Z]+$" genesis.words.txt | wc -l

# Count 4-letter words
grep -E "^.{4}$" genesis.words.txt | wc -l

# Find words without vowels
grep -Ei "^[^aeiou]{2,}$" genesis.words.txt | sort -f | uniq -i

# Find words with exactly 1 vowel ("1-syllable" words)
grep -Ei "^[^aeiouy]*[aeiouy][^aeiouy]*$" genesis.words.txt | sort -f | uniq -i

# Find words with exactly 2 vowels ("2-syllable" words)
grep -Ei "^[^aeiouy]*[aeiouy][^aeiouy]*[aeiouy][^aeiouy]*$" genesis.words.txt | sort -f | uniq -i > genesis.2syllables.txt

# Delete words ending with silent "e" or containing dipthongs
grep -Eiv "(ow|ou|ie|oi|oo|ea|ee|ai|[aeiou]y).*|[aeiouy][^aeiouy]e$" genesis.2syllables.txt

# Find verses with the word "light"
grep -Ei "^.*\blight\b.*$" genesis.txt

# Count verses with two or more instances of "light"
grep -Ei "^(.*light.*){2,}$" genesis.txt | wc -l

# Count verses with three or more instances of "light"
grep -Ei "^(.*light.*){3,}$" genesis.txt | wc -l

# Count verses with exactly two instances of "light"
grep -Ei "^(.*light.*){2,}$" genesis.txt | grep -Eiv "^(.*light.*){3,}$" | wc -l
grep -P '^((.(?!light))*(.light)(.(?!light))*){2}$' genesis.txt | wc -l

# Count morphs
aspell munch < genesis.words.txt | gsed 's/.*\s//;s/\s//g;s/\/.*$//' | sort -f | uniq -c

# Count word initial consonant sequences
gsed -r 's/^([^aeiou]*)[aeiouy].*$/\1/i' genesis.words.txt | sort -f | uniq -c

# Count word final consonant sequences
gsed -r 's/^.*[aeiouy]([^aeiouy]+)$|^.*[aeiouy]($)/\1/i' genesis.words.txt | sort -f | uniq -c
