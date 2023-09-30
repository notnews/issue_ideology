## Clean Media Data

### Output:

1. Appendix table that summarizes the media data that we have. Columns:  
   Show, Network, from, to, n_transcripts

2. CSVs. Row = collapse all transcripts for a show (on a particular network) on a particular day.

3. Write up for the ms.: A small note doing two things:
	* summarizing key decisions, especially if they are debatable.  
	* summary stats, sources etc. 

4. Clean scripts:
   * well-commented, sectioned out.  
   * modular: each script does one or two things
   * numbered (to denote location in workflow) and titled (what it does)
   * abstract functions where possible 

### Workflow:

1. Within each dataset, aggregate by paste(show, channel_name), producing a smaller dataset: show, channel_name, n_trans  
2. Merge these smaller datasets, appending another column, src_dataset  
3. Using this merged dataset, straighten out show, channel name and produce two more columns --> clean_show, clean_channel  
   	- General Rules
   		- If show name varies by article 'a, the', anchor, even potentially weekday, day/night, we may want to combine
   		- We do take care of over time stuff --- so a bunch of it should come in via anchor stage  
   	- Sanity Checks
   		- Conventional Fox News Shows can't be assigned to another channel. So do ad hoc sanity checks. Report what was done.
   	- Specific Points
	   	* Concerns: 
			* why so few lou dobbs? (01-02; show on thru 2011)
			* why o'reilly, hannity only go back to 09?
		* Remove:
			* Kabc 7 News at 11pm should be dropped? (local)
		* Combine
			- American Morning, American Morning: Wake Up Call
			- CNN Presents, Presents
			- CNN Newsroom, Newsroom, Newsroom/World View
			- CNN Saturday Morning, Saturday Morning News
			- CNN Sunday Morning, Sunday Morning News
			- Hardball, Chris Matthews
			- Live Event, Live Event/Special
			- American Morning Paula Zahn, Mornings Paula Zahn
			- Situation Room, The Situation Room
			- Sunday Morning, Sunday Morning News
			- cnn state of (the) union
			- cnn starting point (soledad)
			- cnn showbiz (tonight/today)
			- cnn saturday
			- cnn Newsroom /Newsroom/World View
			- abc news/saturday/sunday
			- cnn asia tonight (multiple)
			- early start (collapse all)
			- collapse by Cenk Uygur
			- fox news sunday (plus chris wallace), news sunday
		* Potentially combine:
			-State of Union, State of the Union, State of the Union with Candy Crowley [agree -ag]
			-Fox News Sunday variants (w, w/o Wallace) [yes -ag]
			-Fox Report variants (w, w/o Hume + Special)
			-Starting Point (w,w/o Obrien)
			-American Morning (w, w/o Zahn) [yes to all]
		* Combine later (if data seem too less) [I think also a good idea -ag]
			-ABC World News variants (anchors, days)
			-CBS Evening News variants (anchors)
			-CBS Morning variants (sunday, 'this morning' 'morning')
			-CNN Morning variants (Sat, Sun, other)
			-CNN Early Start variants (anchors)
			-Live variants (days, morning, other)
			-MSNBC Live variants (anchor, other)
			-MSNBC News variants (days)
			-Q&a variants (anchors)
			-Showbiz variants (time)
			-Special Report (anchors)
			-Worldview, World Report ?
			-2 with Wolf Blitzer
4. Then tally which paste0(clean_show, clean_channel) don't have n_trans > 100 and create a column drop_show  
5. Merge back to original data  
6. Use drop_show to drop 
7. standardized_date within datasets 
	- why do we have dates with NA, NA
	- year that is over 3000 --- check --- do table(media_data$year) to see year 3007 (!)
8. De-duplicate within datasets: Remove duplicate of story within same show/channel. paste(clean_show, clean_channel, text)
	* Go with number of shows than number of transcripts. Show = anything on one date. 
9. Output: (clean_show, clean_channel, standardized_date, source, clean-text) --- make sure column names are the same across datasets and only output the reduced set of columns

