#!/bin/sh

. ../../dttools/test/test_runner_common.sh
. ../../chirp/test/chirp-common.sh

c="./hostport.$PPID"
parrot_debug=parrot.debug

parrot() {
	../src/parrot_run --no-chirp-catalog --debug=all --debug-file="$parrot_debug" --timeout=5 --work-dir="/chirp/$hostport/" "$@"
}

prepare()
{
	chirp_start local
	echo "$hostport" > "$c"

	return 0
}

run()
{
	hostport=$(cat "$c")

	set +e

	N=10
	parrot /bin/sh <<EOF1
set -ex
cat > a.py <<EOF2
#!/chirp/$hostport/python

import sys

print(' '.join(sys.argv))
EOF2
cp "$(which python)" "$(which sh)" .
chmod 700 a.py python sh
EOF1
	while [ "$N" -gt 0 ]; do
		parrot -- /bin/sh <<EOF1 &
./a.py
EOF1
		N=$(expr $N - 1)
	done
	rc=0
	for pid in $(jobs -p); do
		wait "$pid"
		result=$?
		if [ $result -ne 0 ]; then
			echo job $pid failed with exit code $result
			rc=1
		fi
	done
	return $rc
}

clean()
{
	chirp_clean
	rm -f "$c" "$parrot_debug"
}

set -e
dispatch "$@"

# vim: set noexpandtab tabstop=4:
