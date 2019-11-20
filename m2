@@ -0,0 +1,72 @@
﻿﻿**------------------------------------------------------------------------------------------------
* @header_start
* WebGrab+Plus ini for grabbing EPG data from TvGuide websites
* @Site: vodafone.pt
* @MinSWversion: V1.57
* @Revision 2 - [21/10/2016] Francis De Paemeleere
*  - adding channel icons
* @Revision 1 - [21/10/2016] Francis De Paemeleere
*  - adding show icons
* @Revision 0 - [16/10/2016] Blackbear199
*  - creation
* @Remarks:
* @header_end
**------------------------------------------------------------------------------------------------
site {url=vodafone.pt|timezone=Europe/Lisbon|maxdays=7|cultureinfo=pt-PT|charset=UTF-8|titlematchfactor=90}
site {ratingsystem=Pt|episodesystem=onscreen}
*
url_index{url|https://tvnetvoz.vodafone.pt/sempre-consigo/epg.do?action=getPrograms}
*
urldate.format {datestring|yyyy-MM-dd}
*
url_index.headers {method=POST}
url_index.headers {accept=application/json, text/plain, */*}
url_index.headers {contenttype=application/x-www-form-urlencoded; charset=UTF-8}
url_index.headers {postdata=chanids='channel'&day='urldate'}
*
index_showsplit.scrub {regex||.*||}

index_urlchannellogo.scrub		  {regex||^.*?"id"\s*:\s*"([^"\\]*(?:\\.[^"\\]*)*)"||}
scope.range{(datelogo)|end}
index_urlchannellogo.modify {addstart|https://tvnetvoz.vodafone.pt/sempre-consigo/imgs?action=logo_channel_tablet_details&chanid=}
index_urlchannellogo.modify {addend|&mime=true&no_default=false}
end_scope

scope.range{(splitindex)|end}
index_temp_2.modify {substring(type=regex)|'index_showsplit' }
global_temp_1.modify {substring(type=regex)|'index_showsplit' "^.*?"callLetter"\s*:\s*"([^"\\]*(?:\\.[^"\\]*)*)""}
index_showsplit.modify {substring(type=regex)|\{"startTime"[^\}]*\}}

index_temp_1.modify {substring(type=regex)|'index_showsplit' "\"sid\":\"([^\"]*)\""}
index_temp_1.modify {cleanup(removeduplicates link="index_showsplit")}
end_scope
*
scope.range{(indexshowdetails)|end}
index_date.scrub {single(force)|"date":"||"|"}
index_start.scrub {single|"startTime":"||"|"}
index_stop.scrub {single|"endTime":"||"|"}
index_title.scrub {single(separator=" - " include=first)|"programTitle":"||"|"}
index_subtitle.scrub {single(separator=" - " include=flast)|"programTitle":"||"|"}
index_description.scrub {single|"programDetails":"||"|"}
index_temp_2.scrub {regex||^.*?"pid"\s*:\s*"([^"\\]*(?:\\.[^"\\]*)*)"||}
*
index_temp_1.modify {substring(type=regex)|'index_title' ":(T\d+)"}
index_episode.modify {substring(type=regex pattern="T'S1' Ep.'E1'""T'S1'""Ep.'E1'")|'index_title' "\s(Ep\.\d+)"}
index_episode.modify {addstart('index_temp_1' not "")|'index_temp_1' }
*
index_title.modify {remove(type=regex)|:T\d+}
index_title.modify {remove(type=regex)|\sEp\.\d+}
index_description.modify {cleanup}
*http://web.ottimg.vodafone.pt/iptvimageserver/Get/EURSP2_12380816/16_9/325/244
index_showicon.modify {addstart|http://web.ottimg.vodafone.pt/iptvimageserver/Get/'global_temp_1'_'index_temp_2'/16_9/325/244}
end_scope
*
**  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _
**      #####  CHANNEL FILE CREATION (only to create the xxx-channel.xml file)
**
** @auto_xml_channel_start
*url_index {url|https://tvnetvoz.vodafone.pt/sempre-consigo/datajson/epg/channels.jsp}
*index_site_id.scrub {multi|"id":"||"|"}
*index_site_channel.scrub {multi|"name":"||"|"}
*index_site_id.modify {cleanup(removeduplicates=equal,100 link="index_site_channel")}
** @auto_xml_channel_end
