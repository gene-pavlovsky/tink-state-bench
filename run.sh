#!/bin/sh

function data() {
	cat <<-END
		100 0 3 100
		100 1 3 100
		100 3 3 100
		100 5 3 100
	 1000 0 3 100
	 1000 1 3 100
	 1000 3 3 100
	 1000 5 3 100
	END
}

data | while read o w s r; do
	node bin/autobench.js $o $w $s $r
done
