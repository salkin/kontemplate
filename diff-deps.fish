# Copyright (C) 2016-2017  Vincent Ambo <mail@tazj.in>
#
# This file is part of Kontemplate.
#
# Kontemplate is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

#!/usr/bin/env fish

function get_remote_master
    git ls-remote "$argv[1]" | \
        grep 'refs/heads/master' | \
        awk '{print $1}'
end

function list_deps
    grep '"git"' -B2 kontemplate.frm | \
    grep -P -o '(?<=silo: ")https://.+(?=")'
end

function diff_dep
    set -l current (grep -B1 "$argv[1]" kontemplate.frm | grep -P -o '(?<=hash: ").+(?=")')
    set -l remote (get_remote_master "$argv[1]")

    if [ $current != $remote ]
        echo "$argv[1]"
        echo -e "current:\t$current"
        echo -e "remote:\t\t$remote\n"
    else
        echo -e "$argv[1] up to date\n"
    end
end

for dep in (list_deps)
    diff_dep $dep
end
