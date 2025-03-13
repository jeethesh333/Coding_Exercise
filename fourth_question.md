
---

**Subject:** Update on Receipt Data Project – Key Findings and Next Steps  

Dear [Product/Business Leader],  

I hope this finds you well! I’m working on organizing our rewards data into a system (called a star schema) to help us analyze things like customer spending and rewards trends. As I’ve been digging in, I’ve run into some data quirks that I’d love your help with. Below are some questions and thoughts to make sure we’re building something reliable and useful—your input would be a huge help! 

### Questions I Have About the Data  
To keep moving forward, I’d love your perspective on a few things:  
- **What’s the `cpg` table for?** Is it meant to group brands or products? Knowing its purpose would help us tie it into the analysis.  
- **How should I handle brand info?** The item details often miss a `brandCode`, which links them to our `brands` table. I can guess brands from descriptions (e.g., “DORITOS” from “DORITOS TORTILLA CHIP SPICY SWEET CHILI REDUCED FAT BAG 1 OZ”), but it’s not perfect—how accurate does this need to be?
- **Are test brand codes intentional?** Some entries in `brands` look like placeholders (e.g., “TEST BRANDCODE @1598635634882”) instead of real brands like “STARBUCKS.” Should I keep these or filter them out?  

### How I Spotted These Data Issues  
I found these quirks by poking around the data:  
- I noticed duplicate user IDs when checking the `users` table, which stood out since each user should be unique.  
- The missing `brandCode` links came up when I tried matching items to brands—most were blank, so I tested pulling brands from item descriptions as a workaround.  
- The `cpg` table caught my eye because it didn’t connect to anything else, and the test brand codes popped up when I scanned the `brands` table for odd patterns.  

### What I Need to Fix These Issues  
To resolve these data quality problems, here’s what I’m looking for:  
- **A Partner Product File**: The exercise mentions `brandCode` ties to a partner file I don’t access to that yet. 
- **cpg table**: I need more information on what cpg tables is and how does it connects to other tables. 
- **Sample Receipts or Partner Input**: Seeing a few real receipts or talking to whoever supplies the brand data could help us figure out why `brandCode` is missing and how to match items to brands accurately.  
- **A Cleanup Priority List**: Should I focus on filling gaps (like missing spending amounts) or fixing oddities (like test codes) first? Your take on what’s most critical would steer us right.  
- **A Quick Data Source Check**: Could I peek at how the data’s collected (e.g., app scans or uploads)? That might show why dates are messy or IDs repeat, so we can stop it at the source.  

### Optimizing the Data for Bigger Impact  
To make this data even more valuable, I’d need a bit more context:  
- **Key Business Goals**: Are we most interested in tracking spending by user, rewards by brand, or something else? Knowing what matters most will help me prioritize fixes.  
- **Data Sources**: Where does this data come from (e.g., receipt scans, partner feeds)? Understanding the pipeline could reveal why things like `brandCode` are missing.  
- **Growth Expectations**: How much data do we expect to handle in six months or a year? This will guide how we build it to scale.  

### Scaling and Performance in Production  
As we roll this out, I’m thinking about how it’ll hold up:  
- **Volume Concerns**: If we’re processing millions of receipts, slow joins between `receipts` and `rewardsReceiptItemList` (with all its item details) could bog things down. I’d plan to index key fields like `receipt_id` and `user_id` to speed up lookups.  
- **Real-Time Needs**: If we want up-to-the-minute reports, delays in updating `purchaseDate` or `pointsEarned` could be an issue. We might need a faster data refresh process.  
- **Storage Growth**: With detailed item data in `rewardsReceiptItemList`, storage could balloon. I’d suggest archiving old records or summarizing them over time to keep things manageable.  

### Next Steps  
I’m working on cleaning up what I can—like removing duplicates and filling in some `brandCode` gaps—but I’d love to sync with you or the team to nail down those open questions. Could we set up a quick chat to discuss the issues and your priorities? That’ll help me polish this into a tool that really drives decisions.  

Looking forward to hearing your thoughts!  

Best regards,  
Jeethesh   
Data Team  

---


