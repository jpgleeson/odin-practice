package main

import "core:fmt"
import "core:slice"
import "core:strings"

main :: proc() {
	assert(containsDuplicates([]int{1, 24, 3, 4, 5, 5}))

	assert(isAnagram("racecar", "carrace"))
	assert(!isAnagram("jar", "jam"))
}

containsDuplicates :: proc(input: []int) -> bool {
	slice.sort(input)
	for i := 0; i < len(input) - 1; i += 1 {
		if input[i] == input[i + 1] {
			return true
		}
	}
	return false
}

isAnagram :: proc(word1: string, word2: string) -> bool {
	word1Normalised := strings.to_lower(word1)
	word2Normalised := strings.to_lower(word2)
	if word1Normalised == word2Normalised {
		return true
	}

	if len(word1Normalised) != len(word2Normalised) {
		return false
	}

	characterOccurrences := make(map[rune]int)
	for character in word1Normalised {
		characterOccurrences[character] += 1
	}

	characterOccurrences2 := make(map[rune]int)
	for character in word2Normalised {
		characterOccurrences2[character] += 1
	}

	for character, count in characterOccurrences {
		if characterOccurrences2[character] != count {
			return false
		}
	}

	return true
}
