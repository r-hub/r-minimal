#!/usr/bin/env bats

function setup() {
    true
}

function teardown() {
    true
}

@test "devel (arg)" {
    source tools/calculate_tags.sh
    run calculate devel 4.6.0 "R Under development (unstable) (2025-06-16 r88324)"
    echo "${lines[0]}"
    echo "${lines[0]}" | grep -q "Tags to add: devel 4.6.0 4.6 4.6.0-devel 4.6-devel `date -I`$"
}

@test "devel (detect)" {
    source tools/calculate_tags.sh
    function get_r_version_number() {
        echo 4.6.0;
    }
    export -f get_r_version_number
    function get_r_version_string() {
        echo "R Under development (unstable) (2025-06-16 r88324)"
    }
    export -f get_r_version_string
    run calculate devel
    echo "${lines[0]}"
    echo "${lines[0]}" | grep -q "Tags to add: devel 4.6.0 4.6 4.6.0-devel 4.6-devel `date -I`$"
}

@test "patched (arg)" {
    source tools/calculate_tags.sh
    run calculate next 4.5.1 "R version 4.5.1 Patched (2025-09-24 r88882)"
    echo "${lines[0]}"
    echo "${lines[0]}" | grep -q "Tags to add: next patched 4.5.1-patched 4.5-patched$"
}

@test "patched (detect)" {
    source tools/calculate_tags.sh
    function get_r_version_number() {
        echo 4.5.1;
    }
    function get_r_version_string() {
        echo "R version 4.5.1 Patched (2025-09-24 r88882)";
    }
    run calculate next
    echo "${lines[0]}"
    echo "${lines[0]}" | grep -q "Tags to add: next patched 4.5.1-patched 4.5-patched$"
}

@test "next (arg)" {
    source tools/calculate_tags.sh
    run calculate next 4.5.1 "R version 4.5.1 Patched (2025-09-24 r88882)"
    echo "${lines[0]}"
    echo "${lines[0]}" | grep -q "Tags to add: next patched 4.5.1-patched 4.5-patched$"
}

@test "next (detect)" {
    source tools/calculate_tags.sh
    function get_r_version_number() {
        echo 4.5.1;
    }
    function get_r_version_string() {
        echo "R version 4.5.1 Patched (2025-09-24 r88882)";
    }
    export -f get_r_version_number
    export -f get_r_version_string
    run calculate next
    echo "${lines[0]}"
    echo "${lines[0]}" | grep -q "Tags to add: next patched 4.5.1-patched 4.5-patched$"
}

@test "release (arg)" {
    source tools/calculate_tags.sh
    function get_r_release_version() {
        echo 4.5.1;
    }
    export -f get_r_release_version
    run calculate 4.5.1 4.5.1
    echo "${lines[0]}"
    echo "${lines[0]}" | grep -q "Tags to add: 4.5.1 4.5 release latest$"
}

@test "release (detect)" {
    source tools/calculate_tags.sh
    function get_r_version_number() {
        echo 4.5.1;
    }
    function get_r_release_version() {
        echo 4.5.1;
    }
    export -f get_r_version_number
    export -f get_r_release_version
    run calculate 4.5.1
    echo "${lines[0]}"
    echo "${lines[0]}" | grep -q "Tags to add: 4.5.1 4.5 release latest$"
}

@test "old (arg)" {
    source tools/calculate_tags.sh
    function get_r_release_version() {
        echo 4.5.1;
    }
    export -f get_r_release_version
    run calculate 4.4.3 4.4.3
    echo "${lines[0]}"
    echo "${lines[0]}" | grep -q "Tags to add: 4.4.3 4.4$"
}

@test "old (detect)" {
    source tools/calculate_tags.sh
    function get_r_version_number() {
        echo 4.4.3;
    }
    function get_r_release_version() {
        echo 4.5.1;
    }
    export -f get_r_version_number
    export -f get_r_release_version
    run calculate 4.4.3
    echo "${lines[0]}"
    echo "${lines[0]}" | grep -q "Tags to add: 4.4.3 4.4$"
}
