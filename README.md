# Applescript Objective-C ASOC

This repository contains a collection of scripts I have been working on mostly around Music.app

## 1. appleMusic_striptDiacritics_ASOC.scpt

#### Using the following constants enable us to strip many diacritics from the Title / Artist in Music.app

```
NSStringTransformToLatin
NSStringTransformStripCombiningMarks
NSStringTransformStripDiacritics
```

## Summary

### Understanding NSStringTransformToLatin and Diacritic Stripping

The `NSStringTransformToLatin` transformation converts any non-Latin characters to their Latin equivalents. This includes:

**Greek, Cyrillic, Armenian, Hebrew, Arabic, Syriac, Thaana, Devanagari, Bengali, Gurmukhi, Gujarati, Oriya, Tamil, Telugu, Kannada, Malayalam, Sinhala, Thai, Lao, Tibetan, Myanmar, Georgian, Hangul (Korean), Ethiopic, Cherokee, Canadian Aboriginal Syllabics, Mongolian, Khmer, Bopomofo, Han (Chinese), Hiragana (Japanese), Katakana (Japanese), Yi, Tagalog, Hanunoo, Buhid, Tagbanwa, Braille**

The `NSStringTransformStripCombiningMarks` transformation then removes any combining marks (like accents, tildes, etc.) that are still present in the Latinised text.

The `NSStringTransformStripDiacritics` transformation ensures that any remaining diacritics (special characters like accents) are removed.

This process standardises the text into a format that is simple, unaccented, and compatible with basic QWERTY keyboards, while keeping the original structure of the word intact.
