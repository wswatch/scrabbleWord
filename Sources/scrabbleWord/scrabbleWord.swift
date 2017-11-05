import Foundation

// the directory use to get the value of each letter

let tileScore: [Character:Int]  = ["a": 1, "c": 3, "b": 3, "e": 1, "d": 2, "g": 2,
                         "f": 4, "i": 1, "h": 4, "k": 5, "j": 8, "m": 3,
                         "l": 1, "o": 1, "n": 1, "q": 10, "p": 3, "s": 1,
                         "r": 1, "u": 1, "t": 1, "w": 4, "v": 4, "y": 4,
                         "x": 8, "z": 10]

// the error type that will appear in this file

public enum myError: Error {
    case wordError;
    case readError;
    case writeError;
}



public struct scrabbleWord {
    var word: String
    var definition: String
    var score: Int
    public init(word: String, def: String ) throws {     // get word,definition and score of each item
        self.word = word
        self.definition = def
        score = 0
        let characterOfWord = Array( word.lowercased() )  // get lower letters
        for ch in characterOfWord{
            if let value = tileScore[ch] {
                score = score + value
            }
            else{
                throw myError.wordError
            }
        }
    }
}

extension scrabbleWord: Equatable, Comparable, CustomStringConvertible {
    static func ==(lhs: Word, rhs: Word) -> Bool {
        if lhs.score == rhs.score {
            return true
        }
        else{
            return false
        }
    }
    
    static func <(lhs: Word, rhs: Word) -> Bool {
        if lhs.score < rhs.score {
            return true
        }
        else if lhs.score == rhs.score {
            if lhs.word < rhs.word {
                return true
            }
            else {
                return false
            }
        }
        else{
            return false
        }
    }
    var description: String {       // word+score+definition
        return "\(word):\t score: \(String(score))\t\(definition)"
    }
}

public func readWords(path:String) throws -> [scrabbleWord] {
    var wordList:[scrabbleWord] = []
   	do{
       	let data = try String(contentsOfFile:path, encoding:String.Encoding.utf8)
       	let lines = data.components(separatedBy: CharacterSet.newlines )
       	for line in lines {
           	if line.count > 0 {
               	var i = line.startIndex
               	while (line[i] != " ") && (line[i] != "\t") {
                   	i = line.index(i, offsetBy: 1)        // next String element
               	}
               	let letters = String(line[ line.startIndex ..< i ])     // get word and def from line with the first mean blank
                while line[i] == " " || line[i] == "\t" {
                   	i = line.index(i, offsetBy: 1)
               	}
               	let def = String( line[ i ..< line.endIndex ] )
               	let word:Word = try Word(word:letters, def:def)
               	wordList.append(word)
            }
        }
    }
    catch{
        throw myError.readError
    }
 	return wordList
}
