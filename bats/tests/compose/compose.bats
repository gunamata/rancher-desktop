load '../helpers/load'

local_setup() {
    COMPOSE_FILE_PATH="${PATH_BATS_ROOT}/tests/compose/testdata/compose.yaml"
    if using_windows_exe; then
        COMPOSE_FILE_PATH="$(wslpath -m "${COMPOSE_FILE_PATH}")"
    fi
}

@test 'factory reset' {
    factory_reset
}

@test 'start container engine' {
    start_container_engine
    wait_for_container_engine
}

@test 'compose up' {
    run ctrctl compose -f "$COMPOSE_FILE_PATH" up
    assert_success
}

@test 'verify app' {
    try --max 9 --delay 10 curl --silent --show-error "http://localhost:8000"
    assert_success
    assert_output --partial "Hello World!"
}

@test 'compose down' {
    run ctrctl compose -f "$COMPOSE_FILE_PATH" down
    assert_success
}
