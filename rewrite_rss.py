
import bs4
from feedgenerator import Rss201rev2Feed
import re, glob
from datetime import datetime
from publishconf import SITEURL
#from pelican.utils import get_relative_path, path_to_url, set_date_tzinfo, truncate_html_words
#from pelican.settings import read_settings

        # sitename = Markup(context['SITENAME']).striptags()
        # feed = feed_class(
        #     title=sitename,
        #     link=(self.site_url + '/'),
        #     feed_url=self.feed_url,
        #     description=context.get('SITESUBTITLE', ''))

        # title = Markup(item.title).striptags()
        # feed.add_item(
        #     title=title,
        #     link='%s/%s' % (self.site_url, item.url),
        #     unique_id='tag:%s,%s:%s' % (self.site_url.replace('http://', ''),
        #                                 item.date.date(), item.url),
        #     description=item.get_content(self.site_url),
        #     categories=item.tags if hasattr(item, 'tags') else None,
        #     author_name=getattr(item, 'author', ''),
        #     pubdate=set_date_tzinfo(item.date,
        #         self.settings.get('TIMEZONE', None)))

def rewrite_rss(output_path='./output',rss_path='/feeds/main_rss.xml'):
	#settings = read_settings(settings_path)

	# Feed info
	blog_title = 'themodernscientist'
	blog_link = SITEURL
	blog_description = 'biophysicist, mac-unix zealot, pythonista'
	rss_link = SITEURL + '/feeds/main_rss.xml'
	author = 'modernscientist'

	# Max number of entries
	max_entry_count = None

	# Create the feed
	feed = Rss201rev2Feed(title=blog_title, link=blog_link, feed_url=rss_link, description=blog_description)

	# Get the list of index files
	indexfillist = glob.glob1(output_path ,'index*.html')
	indexfillist.sort()

	entries = list()
	titles = list()
	links = list()
	dates = list()
	for idxfil in indexfillist:
		# Read the file
		fp = open(output_path +'/'+idxfil,'r')
		filstr = fp.read()
		fp.close()

		# Parse up the html
		parsed_html = bs4.BeautifulSoup(filstr)

		# The summary for each entry
		entries.extend([(x.find('p')).text for x in parsed_html.body.findAll('div',attrs={'class':'entry-content'})])

		# The titles and links
		titles_links = [str(x.fetchText()[0]) for x in parsed_html.body.findAll('h1',attrs={'class':'entry-title'})]
		titles.extend([re.search(r'''>(.*?)<''',x).group(1) for x in titles_links])
		links.extend([re.search(r'''href="(.*?)"''',x).group(1) for x in titles_links])

		# Get dates and construct unique ids, ala Pelican
		dates.extend([re.search(r'''datetime="(.*?)"''',str(x)).group(1) for x in parsed_html.body.findAll('time')])
		

	# Shorten to max number of posts if necessary
	if max_entry_count is not(None):
		titles = titles[:max_entry_count]
		links = links[:max_entry_count]
		dates = dates[:max_entry_count]
		entries = entries[:max_entry_count]

	# Add the 'read more' links to entries
	entries_links = [e+'<p><a href="%s">Read More</a></p>'%l for e,l in zip(entries,links)]

	# Create unique id tags for posts
	unique_ids = ['tag:modernscientist.com,'+d.replace('/','-')+':'+l.replace(SITEURL + '/','') for d,l in zip(dates,links)]

	# Convert the date format
	#dates_fmt = [datetime.strptime(x,"%Y-%m-%dT%H:%M:%S").strftime("%a, %d %b %Y %H:%M:%S -0400") for x in dates]
	dates_fmt = [datetime.strptime(x,"%Y-%m-%dT%H:%M:%S") for x in dates]

	# Add them to the RSS feed
	for title,link,date,entry,uid in zip(titles,links,dates_fmt,entries_links,unique_ids):
		feed.add_item(title=title, link=link, unique_id=uid, description=entry, categories=None, author_name=author, pubdate=date)

	fp = open(output_path+'/'+rss_path, 'w')
	feed.write(fp,'utf-8')
	fp.close()