var map = function() {
	var length = 0;
	if(this.splatts) {
		length = this.splatts.length
	}
	emit ("count", length);
};

var reduce = function(key, val) {
	var data = 0;
	val.forEach(function(v) {
		data += v;
	});
};

db.users.mapReduce(
	map,
	reduce,
	{
		out: {inline: 1}
	}
)

