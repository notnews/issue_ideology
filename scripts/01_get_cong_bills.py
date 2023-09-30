# Full texts of bills are not available on Congress.gov for bills prior to 1993 (103rd Congress).
import csv
from urllib2 import urlopen
from bs4 import BeautifulSoup

f = open("bills93-114.txt")
reader = csv.DictReader(f, delimiter='\t')
print reader.fieldnames
count = 0
topics = {}
for i, r in enumerate(reader):
    major = r['Major']
    minor = r['Minor']
    if major not in topics:
        topics[major] = set()
    topics[major].add(minor)
    if int(r['Year']) >= 1993:
        """
        print r['Major'], r['Minor']
        url = r['URL']
        response = urlopen(url + '/text')
        print response.info()
        html = response.read()
        response.close()  # best practice to close the file
        # do something
        soup = BeautifulSoup(html)
        txt = soup.find('pre')
        #print txt.text
        """
        count += 1
f.close()

print len(topics)
for t in topics:
    print t, "==>", len(topics[t])
print i, count
