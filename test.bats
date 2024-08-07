#!/usr/bin/env bats

function setup() {
    true
}

function teardown() {
    true
}

@test "devel (arg)" {
    source tools/calculate_tags.sh
    run calculate devel 4.0.0 "R Under development (unstable) (2022-03-21 r81954)"
    echo "${lines[0]}"
    echo "${lines[0]}" | grep -q "Tags to add: devel 4.0.0 4.0 4.0.0-devel 4.0-devel `date -I`$"
}

@test "devel (detect)" {
    source tools/calculate_tags.sh
    function get_r_version_number() { echo 4.0.0; }
    export -f get_r_version_number
    run calculate devel
    echo "${lines[0]}"
    echo "${lines[0]}" | grep -q "Tags to add: devel 4.0.0 4.0 4.0.0-devel 4.0-devel `date -I`$"
}

@test "patched (arg)" {
    source tools/calculate_tags.sh
    run calculate next 4.1.3 "R version 4.1.3 Patched (2022-03-10 r82100)"
    echo "${lines[0]}"
    echo "${lines[0]}" | grep -q "Tags to add: next patched 4.1.3-patched 4.1-patched$"
}

@test "patched (detect)" {
    source tools/calculate_tags.sh
    function get_r_version_number() {
        echo 4.1.3;
    }
    function get_r_version_string() {
        echo "R version 4.1.3 Patched (2022-03-10 r82100)"
    }
    run calculate next
    echo "${lines[0]}"
    echo "${lines[0]}" | grep -q "Tags to add: next patched 4.1.3-patched 4.1-patched$"
}

@test "next (arg)" {
    source tools/calculate_tags.sh
    run calculate next 4.2.0 "R version 4.2.0 alpha (2022-04-03 r82074)"
    echo "${lines[0]}"
    echo "${lines[0]}" | grep -q "Tags to add: next 4.2.0 4.2 alpha 4.2.0-alpha 4.2-alpha$"
}

@test "next (detect)" {
    source tools/calculate_tags.sh
    function get_r_version_number() {
        echo 4.2.0;
    }
    function get_r_version_string() {
        echo "R version 4.2.0 alpha (2022-04-03 r82074)";
    }
    export -f get_r_version_number
    export -f get_r_version_string
    run calculate next
    echo "${lines[0]}"
    echo "${lines[0]}" | grep -q "Tags to add: next 4.2.0 4.2 alpha 4.2.0-alpha 4.2-alpha$"
}

@test "release (arg)" {
    source tools/calculate_tags.sh
    function get_r_release_version() {
        echo 4.1.3;
    }
    export -f get_r_release_version
    run calculate 4.1.3 4.1.3
    echo "${lines[0]}"
    echo "${lines[0]}" | grep -q "Tags to add: 4.1.3 4.1 release latest$"
}

@test "release (detect)" {
    source tools/calculate_tags.sh
    function get_r_version_number() {
        echo 4.1.3;
    }
    function get_r_release_version() {
        echo 4.1.3;
    }
    export -f get_r_version_number
    export -f get_r_release_version
    run calculate 4.1.3
    echo "${lines[0]}"
    echo "${lines[0]}" | grep -q "Tags to add: 4.1.3 4.1 release latest$"
}

@test "old (arg)" {
    source tools/calculate_tags.sh
    function get_r_release_version() {
        echo 4.1.3;
    }
    export -f get_r_release_version
    run calculate 4.1.2 4.1.2
    echo "${lines[0]}"
    echo "${lines[0]}" | grep -q "Tags to add: 4.1.2 4.1$"
}

@test "old (detect)" {
    source tools/calculate_tags.sh
    function get_r_version_number() {
        echo 4.1.2;
    }
    function get_r_release_version() {
        echo 4.1.3;
    }
    export -f get_r_version_number
    export -f get_r_release_version
    run calculate 4.1.2
    echo "${lines[0]}"
    echo "${lines[0]}" | grep -q "Tags to add: 4.1.2 4.1$"

}
