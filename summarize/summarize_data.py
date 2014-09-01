import bisect
import calendar
import collections
import datetime
import json
import random

def main():
	# Currently generates sample data, switch to real data
	generate_sample_timestamps
	data = read_timestamps()
	summary = dict()
	summary["minutes"] = summarize_timestamps(data)
	print json.dumps(summary)

def generate_sample_timestamps():
	# Open a file to write generated sample timestamps
	f = open('sample_keystrokes', 'w')

	# Grab some timestamp yesterday
	time = datetime.datetime.now() - datetime.timedelta(days=1)

	# Generate some timestamps spaced out somewhat randomly
	for i in range(10000):
		time = time + datetime.timedelta(seconds=random.randint(0, 5))
		f.write(' '.join(map(str, [calendar.timegm(time.timetuple()), 1, '\n'])))

	f.close()

def read_timestamps():
	data = []
	with open('sample_keystrokes') as f:
		# Extract timestamps
		data = [x.split()[0] for x in f.readlines()]
		# Extract ints
		data = map(int, data)

	return data

# Really messy, need to clean up!
# Buckets timestamps by minute
def summarize_timestamps(data):
	start = datetime.datetime.fromtimestamp(data[0])
	bucket = start.replace(hour=0, minute=0, second=0, microsecond=0)

	# Create one minute buckets
	interval = datetime.timedelta(minutes=1)
	buckets = []
	while (bucket < datetime.datetime.now()):
		buckets.append(calendar.timegm(bucket.timetuple()))
		bucket += interval

	bins = collections.defaultdict(list)
	for time in data:
		idx = bisect.bisect(buckets, time)
		bins[idx].append(1)

	bucket_counts = {buckets[idx]: len(nums) for idx, nums in bins.iteritems()}

	return collections.OrderedDict(sorted(bucket_counts.items()))



main()


