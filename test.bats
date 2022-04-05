#!/usr/bin/env bats

function setup() {
    true
}

function teardown() {
    true
}

@test "devel" {
    source tools/calculate_tags.sh
    function get_r_version_number() { echo 4.0.0; }
    export -f get_r_version_number
    run calculate devel
    echo "${lines[2]}"
    echo "${lines[2]}" | grep -q "Tags to add: devel 4.0.0-devel 4.0.0 4.0 4.0-devel$"
}

@test "next" {
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
    echo "${lines[2]}"
    echo "${lines[2]}" | grep -q "Tags to add: next 4.2.0 4.2 alpha 4.2.0-alpha 4.2-alpha$"
}

@test "release" {
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
    echo "${lines[2]}"
    echo "${lines[2]}" | grep -q "Tags to add: 4.1.3 4.1 release latest$"
}

@test "old" {
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
    echo "${lines[2]}"
    echo "${lines[2]}" | grep -q "Tags to add: 4.1.2 4.1$"

}
