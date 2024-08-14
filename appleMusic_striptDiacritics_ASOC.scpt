use framework "Foundation"
use scripting additions

tell application "Music"
	activate
	
	set diacriticIDs to current application's NSMutableArray's array()
	set diacriticNames to current application's NSMutableArray's array()
	set diacriticArtists to current application's NSMutableArray's array()
	
	-- Fetch the tracks' persistent IDs, names, and artists
	set {trackIDs, trackNames, trackArtists} to {persistent ID, name, artist} of tracks of library playlist 1
	
	-- Create a dictionary with persistent IDs as keys and {name, artist} pairs as values
	set theDict to current application's NSMutableDictionary's dictionary()
	repeat with i from 1 to (count of trackIDs)
		set trackID to item i of trackIDs as text -- Ensure trackID is in text format
		set trackName to item i of trackNames as text
		set trackArtist to item i of trackArtists as text
		
		-- Add the name and artist pair to the dictionary with the persistent ID as the key
		(theDict's setObject:{trackName, trackArtist} forKey:trackID)
	end repeat
	
	-- Define the predicate to filter names or artists containing diacritics
	set predicate to current application's NSPredicate's predicateWithFormat:"self MATCHES %@" argumentArray:{".*[À-ɍ].*"}
	
	-- Create a new mutable dictionary to store the filtered key-value pairs
	set filteredDict to current application's NSMutableDictionary's dictionary()
	
	-- Filter and populate filteredDict based on both name and artist
	repeat with trackID in theDict's allKeys()
		set trackData to (theDict's objectForKey:trackID)
		set trackName to item 1 of trackData
		set trackArtist to item 2 of trackData
		
		-- Check if either the track name or artist matches the predicate
		if ((predicate's evaluateWithObject:trackName) as boolean) or ((predicate's evaluateWithObject:trackArtist) as boolean) then
			(filteredDict's setObject:trackData forKey:trackID)
		end if
	end repeat
	
	-- Iterate through each persistent ID in the filtered dictionary
	repeat with trackID in filteredDict's allKeys()
		set trackData to (filteredDict's objectForKey:trackID)
		set originalName to item 1 of trackData
		set originalArtist to item 2 of trackData
		
		-- Manually replace 'ø' and 'Ø' with 'o' and 'O'
		set originalName to (originalName's stringByReplacingOccurrencesOfString:"ø" withString:"o" options:(current application's NSLiteralSearch) range:{0, originalName's |length|()})
		set originalName to (originalName's stringByReplacingOccurrencesOfString:"Ø" withString:"O" options:(current application's NSLiteralSearch) range:{0, originalName's |length|()})
		
		set originalArtist to (originalArtist's stringByReplacingOccurrencesOfString:"ø" withString:"o" options:(current application's NSLiteralSearch) range:{0, originalArtist's |length|()})
		set originalArtist to (originalArtist's stringByReplacingOccurrencesOfString:"Ø" withString:"O" options:(current application's NSLiteralSearch) range:{0, originalArtist's |length|()})
		
		-- Apply transformations to both the name and artist
		set transformedName to (originalName's stringByApplyingTransform:(current application's NSStringTransformToLatin) |reverse|:false)
		set transformedName to (transformedName's stringByApplyingTransform:(current application's NSStringTransformStripCombiningMarks) |reverse|:false)
		set transformedName to (transformedName's stringByApplyingTransform:(current application's NSStringTransformStripDiacritics) |reverse|:false)
		
		set transformedArtist to (originalArtist's stringByApplyingTransform:(current application's NSStringTransformToLatin) |reverse|:false)
		set transformedArtist to (transformedArtist's stringByApplyingTransform:(current application's NSStringTransformStripCombiningMarks) |reverse|:false)
		set transformedArtist to (transformedArtist's stringByApplyingTransform:(current application's NSStringTransformStripDiacritics) |reverse|:false)
		
		-- Store the transformed name, artist, and track ID in arrays
		(diacriticIDs's addObject:trackID)
		(diacriticNames's addObject:transformedName)
		(diacriticArtists's addObject:transformedArtist)
	end repeat
	
	-- Bulk update the Music library
	repeat with i from 0 to ((diacriticIDs's |count|()) - 1)
		set trackID to (diacriticIDs's objectAtIndex:i) as text
		set transformedName to (diacriticNames's objectAtIndex:i) as text
		set transformedArtist to (diacriticArtists's objectAtIndex:i) as text
		
		-- UNCOMMENT THE FOLLOWING TO: Update both the name and artist in a single operation per track
		--set theTrack to (some track of library playlist 1 whose persistent ID is trackID)
		--set name of theTrack to transformedName
		--set artist of theTrack to transformedArtist
	end repeat
end tell

