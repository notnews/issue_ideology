"

Scrape FB pages of congressmembers

"

# Set dir
ifelse(grepl("Gaurav", getwd()), setwd(basedir), setwd("/Users/aguess/Dropbox/"))
setwd("issue_ideology/")

#library(devtools)
#install_github("pablobarbera/Rfacebook/Rfacebook")
library(Rfacebook)

#fb_oauth <- fbOAuth(app_id = "58977173834", app_secret = "61fb0a7e9cab4ecfdc1c35e2b21dca32")
#fb_oauth <- fbOAuth(app_id = "510274349147035", app_secret = "17331ff71f7de32ebf9394ad9c6ffdea") # use this
#save(fb_oauth, file = "~/fb_oauth")
load("~/fb_oauth")

# temp token
#token <- "CAACEdEose0cBAP9qKIcZBNbGL7wkr3YuN17zfy8NSaEnawRfbdhKeX9g7ypvURd8bZAZBkSDf4hX4BfVjgX6CZCRsRZC7R9OJHrDimndyxUgx4TFuYH6jPeZCGwsnIvW4hpLhfVIJNb0SbzHzcXz8FL3HlaTmvlsMjQqZBqh2IhmpA3rCPQ4ZAxFXYc02glGtq3PCbEijpfJo4UrdrewYgSq"

#head(fb_page)

# Congress
pages <- c("RobertAderholt", "repjustinamash", "MarkAmodeiNV2", "RepJoeBarton", "XavierBecerra", "sanfordbishop", "SpeakerJohnBoehner", "kevinbrady", "congresswomanbrown", "RepRobertBrady", "marshablackburn", "madeleine.bordallo", "michaelcburgess", "RepRobBishop", "congressmangkbutterfield", "RepBoustany", "GusBilirakis", "CongressmanBuchanan", "CongressmanLouBarletta", "RepKarenBass", "CongressmanDan", "DianeBlackTN06", "155220881193244", "RepLarryBucshon", "congresswomanbonamici", "RepJoyceBeatty", "RepAndyBarr", "CongressmanJimBridenstine", "congresswomansusanwbrooks", "RepJuliaBrownley", "RepCheri", "RepAmiBera", "RepByrne", "70063393423", "RepSteveChabot", "138013351189", "jameseclyburn", "CongressmanConyers", "JimCooper", "elijahcummings", "loiscapps", "RepMichaelCapuano", "repjoecrowley", "200388204657", "CongressmanCulberson", "109135405838588", "judgecarter", "TomColeOK04", "RepJimCosta", "emanuelcleaverii", "mike.conaway", "152569121550", "USRepKathyCastor", "repyvettedclarke", "CongressmanSteveCohen", "joecourtney", "CongressmanAndreCarson", "CongressmanJasonChaffetz", "repmikecoffman", "CongressmanGerryConnolly", "RepJudyChu", "JohnCarneyDE", "CongressmanDavidCicilline", "RepRickCrawford", "CongressmanMattCartwright", "326420614138023", "RepChrisCollins", "RepresentativeDougCollins", "RepPaulCook", "CongressmanKevinCramer", "repcardenas", "CongresswomanClark", "280757931935749", "RepPeterDeFazio", "DianaDeGette", "CongresswomanRosaDeLauro", "lloyddoggett", "usrepmikedoyle", "CongressmanDuncan", "RepSusanDavis", "mdiazbalart", "CongressmanDent", "CongressmanTedDeutch", "RepJeffDenham", "RepSeanDuffy", "RepJeffDuncan", "ScottDesJarlaisTN04", "RepDelBene", "RepRodneyDavis", "congressmanjohndelaney", "RepDeSantis",
           "CongresswomanTammyDuckworth", "RepEliotLEngel", "RepAnnaEshoo", "Keith.Ellison", "107297211756", "reneeellmers", "RepEsty", "RepSamFarr", "repfattah", "rfrelinghuysen", "randyforbes", "TrentFranks", "jefffortenberry", "RepVirginiaFoxx", "RepFitzpatrick", "CongressmanBillFoster", "RepMarciaLFudge", "repjohnfleming", "RepFincherTN08", "repchuck", "BlakeFarenthold", "RepBillFlores", "RepLoisFrankel", "BobGoodlatte", "RepKayGranger", "RepGeneGreen", "RepGutierrez", "118514606128", "repscottgarrett", "Rep.Grijalva", "50375006903", "repalgreen", "repgaramendi", "reptomgraves", "RepBobGibbs", "RepChrisGibson", "repgosar", "143059759084016", "RepMorganGriffith", "RepTulsiGabbard", "95696782238", "CongressmanRubenHinojosa", "WhipHoyer", "RepMikeHonda", "RepHensarling", "RepBrianHiggins", "GreggHarper", "CongressmanJimHimes", "DuncanHunter", "reprichardhanna", "AndyHarrisMD", "Congresswoman.Hartzler", "RepJoeHeck", "herrerabeutler", "congressmanhuelskamp", "RepHuizenga", "RepHultgren", "RepRobertHurt", "RepJaniceHahn", "CongressmanDennyHeck", "CongressmanGeorgeHolding", "RepRichHudson", "RepHuffman", "darrellissa", "RepSteveIsrael", "169479190984", "CongresswomanEBJtx30", "RepSamJohnson", "15083070102", "115356957005", "repjimjordan", "replynnjenkins", "RepBillJohnson", "RepHakeemJeffries", "RepDaveJoyce", "repdavidjolly", "RepresentativeMarcyKaptur", "repronkind", "stevekingia", "repjohnkline", "RepKirkpatrick", "Congressman.Keating", "191056827594903", "RepKinzinger", "301936109927957", "RepDanKildee", "derek.kilmer", "CongresswomanAnnieKuster", "reprobinkelly", "RepSandyLevin", "RepJohnLewis", "zoelofgren", "RepLowey", "7872057395", "RepBarbaraLee", "FrankLoBiondo", "RepJohnLarson", "CongressmanJimLangevin",
           "RepRickLarsen", "repstephenlynch", "repdanlipinski", "CongressmanDougLamborn", "DaveLoebsack", "boblatta", "CongressmanLance", "BlaineLuetkemeyer", "RepBenRayLujan", "152754318103332", "raul.r.labrador", "Rep.Billy.Long", "RepLowenthal", "RepLujanGrisham", "RepCarolynMaloney", "RepJimMcGovern", "CongressmanJimMcDermott", "JohnMica", "gregorymeeksny05", "repbettymccollum", "RepJeffMiller", "CongresswomanCandiceMiller", "reptimmurphy", "CongressmanMcHenry", "michaeltmccaul", "RepKennyMarchant", "mcmorrisrodgers", "GwenSMoore", "doris.matsui", "CongressmanKevinMcCarthy", "jerrymcnerney", "81125319109", "144408762280226", "RepMcKinley", "CongressmanPatrickMeehan", "MulvaneySC5", "RepThomasMassie", "RepSeanMaloney", "Repmarkmeadows", "repgracemeng", "RepLukeMesser", "CongressmanMarkwayneMullin", "CongressmanPatrickMurphy", "CongressmanNadler", "325642654132598", "UsRepRickNolan", "CongresswomanNorton", "RepGraceNapolitano", "rep.randy.neugebauer", "RepRichNugent", "CongressmanNunnelee", "20718168936", "betoorourketx16", "repfrankpallone", "pascrell", "NancyPelosi", "94156528752", "RepStevePearce", "reptomprice", "106631626049851", "RepPerlmutter", "CongressmanErikPaulsen", "pedropierluisi", "ChelliePingree", "jaredpolis", "bill.posey15", "stevenpalazzo", "CongressmanPompeo", "DonaldPayneJr", "Rep.ScottPerry", "congressmanpittenger", "repmarkpocan", "CongressmanScottPeters", "repmikequigley", "CBRangel", "CongressmanHalRogers", "iroslehtinen", "RepRoybalAllard", "EdRoyce", "congressmanbobbyrush", "reppaulryan", "171770326187035", "184756771570504", "timryan", "repdavereichert", "RepRoskam", "DrPhilRoe", "reptomrooney", "RepTomReed", "repjimrenacci", "CongressmanReidRibble", "RepRichmond", "RepScottRigell",
           "Representative.Martha.Roby", "RepToddRokita", "dennis.ross.376", "reptomrice", "keithrothfus", "CongressmanRaulRuizMD", "RepMattSalmon", "LorettaSanchez", "RepSanfordSC", "CongressmanBobbyScott", "RepSensenbrenner", "RepJoseSerrano", "petesessions", "63158229861", "repshimkus", "RepLouiseSlaughter", "RepAdamSmith", "RepChrisSmith", "LamarSmithTX21", "janschakowsky", "96007744606", "RepAdamSchiff", "Rep.Shuster", "CongresswomanLindaSanchez", "113303673339", "81058818750", "JackieSpeier", "RepSteveScalise", "153423912663", "RepAaronSchock", "repschrader", "repdavidschweikert", "RepSewell", "116058275133542", "CongressmanMarlinStutzman", "RepAustinScott", "CongresswomanSinema", "RepChrisStewart", "CongressmanEricSwalwell", "repjasonsmith", "7259193379", "repmacthornberry", "RepMikeThompson", "RepPatTiberi", "RepMikeTurner", "RepTsongas", "CongressmanGT", "CongresswomanTitus", "paul.tonko", "CongressmanScottTipton", "RepMarkTakano", "RepFredUpton", "8037068318", "repvisclosky", "chrisvanhollen", "CongressmanDavidValadao", "RepJuanVargas", "CongressmanMarcVeasey", "USCongressmanFilemonVela", "MaxineWaters", "RepEdWhitfield", "repgregwalden", "JoeWilson", "71389451419", "RepDWS", "RepWalberg", "PeterWelch", "RepRobWittman", "RepWebster", "RepWilson", "RepSteveWomack", "RepRobWoodall", "RepAnnWagner", "RepJackieWalorski", "TXRandy14", "RepBradWenstrup", "RepRogerWilliams", "RepDonYoung", "214258646163", "CongressmanKevinYoder", "RepToddYoung", "CongressmanTedYoho", "senatorlamaralexander", "kellyayottenh", "SenatorBlunt", "senatorboxer", "SenatorRichardBurr", "TammyBaldwin", "JohnBoozman", "johnbarrasso", "Begich", "senatorbennet", "SenBlumenthal", "senatorbencardin", "tomcarper", "180671148633644", "mikecrapo", 
           "susancollins", "8057864757", "sen.johncornyn", "SenatorBobCasey", "bobcorker", "senatorchriscoons", "RepTomCotton", "SenatorTedCruz", "SenatorDurbin", "senatordonnelly", "SteveDainesMT", "mikeenzi", "senatorfeinstein", "senatorjeffflake", "senatordebfischer", "USSenatorLindseyGraham", "grassley", "CongressmanGardner", "SenDeanHeller", "MartinHeinrich", "SenatorJohnHoeven", "SenatorHeidiHeitkamp", "jiminhofe", "senronjohnson", "SenatorKirk", "SenatorAngusSKingJr", "SenatorKaine", "SenatorPatrickLeahy", "RepLankford", "senatormikelee", "EdJMarkey", "johnmccain", "mitchmcconnell", "senatormenendez", "SenatorMikulski", "jerrymoran", "SenLisaMurkowski", "chrismurphyct", "senatormccaskill", "jeffmerkley", "JoeManchinIII", "senrobportman", "RepGaryPeters", "SenatorRandPaul", "SenJackReed", "SenatorReid", "SenPatRoberts", "SenatorMarcoRubio", "senatorsanders", "chuckschumer", "RichardShelby", "jeffsessions", "SenatorShaheen", "SenatorTimScott", "SenBrianSchatz", "senatortoomey", "senatortester", "senatortomudall", "SenatorWicker", "SenatorWhitehouse", "MarkRWarner", "senatorelizabethwarren", "SenatorJohnWalsh")

fb_pages <- as.list(array(NA, length(pages)))

p2 <- 1
for(p in p2:length(pages)) {
  
  fb_page <- try(getPage(page = pages[p], token = fb_oauth), silent = TRUE)
  if(class(fb_page) != "try-error") {
    fb_pages[[p]] <- fb_page$message
  }
  if(p%%6 == 0) { Sys.sleep(5) }
  
}
p2 <- p

length(which(is.na(fb_pages)))
fb_pages[[441]]

k <- 0
for(p in which(is.na(fb_pages))) {
  
  k <- k + 1
  fb_page <- try(getPage(page = pages[p], token = fb_oauth), silent = TRUE)
  if(class(fb_page) != "try-error") {
    fb_pages[[p]] <- fb_page$message
  }
  if(k%%6 == 0) { Sys.sleep(5) }
  
}

library(plyr)

names(fb_pages) <- pages
#fb_pages$senatorelizabethwarren
df_fb_pages <- ldply(fb_pages, function(l) { if(!is.na(l)) {
                                              return(as.vector(l))
                                            }
                                            else { return(NULL) } }, .id = "mc_name")

df_fb_pages_wide <- reshape(df_fb_pages, varying = 2:101, sep = "", idvar = "mc_name", direction = "long")
df_fb_pages_wide <- df_fb_pages_wide[order(df_fb_pages_wide$mc_name),]
rownames(df_fb_pages_wide) <- NULL
names(df_fb_pages_wide)[2:3] <- c("post", "text")

# Save rdata
save(df_fb_pages_wide, file = "data/cong_smedia/cong_fb_pages.RData")
