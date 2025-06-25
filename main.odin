#+feature dynamic-literals
package main

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:unicode/utf8"

main :: proc() {
	assert(containsDuplicates([]int{1, 24, 3, 4, 5, 5}))

	assert(isAnagram("racecar", "carrace"))
	assert(!isAnagram("jar", "jam"))

	assert(twoSum([]int{3, 4, 5, 6}, 7) == twoSumAnswer{value1 = 0, value2 = 1})
	assert(twoSum([]int{4, 5, 6}, 10) == twoSumAnswer{value1 = 0, value2 = 2})
	assert(twoSum([]int{5, 5}, 10) == twoSumAnswer{value1 = 0, value2 = 1})
	assert(
		compare_string_groups(
			[dynamic][]string {
				[]string{"act", "cat"},
				[]string{"stop", "pots", "tops"},
				[]string{"hat"},
			},
			groupAnagrams([]string{"act", "pots", "tops", "cat", "stop", "hat"}),
		),
	)
	assert(compare_string_groups([dynamic][]string{[]string{"x"}}, groupAnagrams([]string{"x"})))
	assert(compare_string_groups([dynamic][]string{[]string{""}}, groupAnagrams([]string{""})))
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

twoSumAnswer :: struct {
	value1: int,
	value2: int,
}

twoSum :: proc(components: []int, target: int) -> twoSumAnswer {
	distanceToTarget := make(map[int]int)

	for val, index in components {
		distanceToTarget[val] = index
	}

	for val, index in components {
		lookup := target - val
		valIndex, found := distanceToTarget[lookup]
		if distanceToTarget[lookup] != index {
			return twoSumAnswer{value1 = index, value2 = valIndex}
		}
	}
	return {}
}

groupAnagrams :: proc(inputs: []string) -> [dynamic][]string {
	containedCharactersToIndices := make(map[string][dynamic]int)

	for str, index in inputs {
		characters := [dynamic]rune{}
		for character in str {
			append_elem(&characters, character)
		}
		slice.sort(characters[:])

		key := utf8.runes_to_string(characters[:])

		val, found := containedCharactersToIndices[key]
		append_elem(&val, index)
		containedCharactersToIndices[key] = val
	}

	output := [dynamic][]string{}

	for _, val in containedCharactersToIndices {
		group := [dynamic]string{}
		for index in val {
			append_elem(&group, inputs[index])
		}
		append_elem(&output, group[:])
	}

	return output
}

compare_string_groups :: proc(a, b: [dynamic][]string) -> bool {
	if len(a) != len(b) do return false

	for group in a {
		hasMatch := false
		for group2 in b {
			if len(group) == len(group2) {
				allEntriesMatch := true
				for entry1 in group {
					hasEntryMatch := false
					for entry2 in group2 {
						if entry1 == entry2 {
							hasEntryMatch = true
							break
						}
					}
					if !hasEntryMatch {
						allEntriesMatch = false
						break
					}
				}

				if allEntriesMatch {
					hasMatch = true
					break
				}
			}
		}
		if !hasMatch {
			return false
		}
	}
	return true
}
